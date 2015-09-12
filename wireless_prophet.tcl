#Tcl PRoPHET implementation
#Tesi di Laurea
#Autori: Randazzo Filippo, Parasiliti Parracello Cristina

#physical node parameters

Mac/Simple set bandwidth_ 1Mb

set MESSAGE_PORT 42
set BROADCAST_ADDR -1

set val(chan)           Channel/WirelessChannel    ;#Channel Type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type

set val(mac)		Mac/Simple


set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq


set val(rp) DumbAgent 


#simulation parameters

set sim_stop 0 ;#aging stop flag
set num_nodes 8
set threshold 0.10 ;#delivery predictability threshold

#PRoPHET constant
set Pinit 0.75
set Beta  0.25
set Gamma 0.98
set k 2

#simulation zones 
set z0_x 1
set z0_y 1

set z1_x 1
set z1_y 799

set z2_x 799
set z2_y 799

set z3_x 799
set z3_y 1

#set zone_list
for {set i 0} {$i<4} {incr i} {
	set zone_list($i) null
}



#set topography 
set grid_x 1600
set grid_y 1600
set val(x)  $grid_x
set val(y)  $grid_y
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)

#set new simulator
set ns [new Simulator]

#set trace files
set f [open wireless-prophet-f.tr w]
$ns trace-all $f
set nf [open wireless-prophet-$val(rp).nam w]
$ns namtrace-all-wireless $nf $val(x) $val(y)

set ftracer [open wireless-prophet-tracer.tr w] ;#trace all operation
set fspyer [open wireless-prophet-spyer.tr w] ;#trace all the delivery predictability of nodes known by the spy 
set fgraphSpy [open wireless-prophet-graph_spy.xml w] ;#create xml used for graph creation




#proc for write on tracer file
proc writeFT { data } {
	global ftracer
	puts -nonewline $ftracer $data
}

#proc for write on spyer file
proc writeFS { data } {
	global fspyer
	puts -nonewline $fspyer $data

}

writeFT "File trace\n "
writeFS "File spy\n "
puts  -nonewline $fgraphSpy "<xml version=\"1.0\" encoding=\"UTF-8\">\n"



# Create God
create-god $num_nodes


#node configuration
set chan_1_ [new $val(chan)]

$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -agentTrace OFF \
                -routerTrace OFF \
                -macTrace OFF \
                -movementTrace OFF \
                -channel $chan_1_ 


# subclass Agent/MessagePassing to make it do Prophet
Class Agent/MessagePassing/Prophet -superclass Agent/MessagePassing

#proc for round decimal number to decimalplaces position 
proc tcl::mathfunc::roundto {value decimalplaces} {expr {round(10**$decimalplaces*$value)/10.0**$decimalplaces}} 

#PRoPHET delivery predictability update when node a meet node b
Agent/MessagePassing/Prophet instproc meetNodeProb {nodea nodeb } {
	global delivery_pred Pinit ns k a

	set delivery_pred($nodea,$nodeb) [format "%.4f" [expr ($delivery_pred($nodea,$nodeb) + ((1 - $delivery_pred($nodea,$nodeb) )) * $Pinit)]]
	set current_time [format "%.2f" [expr {double(round(100*[$ns now]))/100}]]
	set delivery_pred($nodea,$nodeb,"time") $current_time	
	
	writeFT "\n$delivery_pred($nodea,$nodeb,"time") -meetNodeProb- => prob($nodea,$nodeb):$delivery_pred($nodea,$nodeb)" 	

}


#PRoPHET delivery predictability aging update 
Agent/MessagePassing/Prophet instproc agingNodeProb {nodea nodeb } {
	global ns k Gamma delivery_pred sim_stop

	set current_time [format "%.2f" [expr {double(round(100*[$ns now]))/100}]]
	set delivery_pred($nodea,$nodeb) [format "%.4f" [expr ($delivery_pred($nodea,$nodeb) * $Gamma**$k)]]	
	set delivery_pred($nodea,$nodeb,"time") $current_time	
		
 	writeFT "\n$delivery_pred($nodea,$nodeb,"time") -agingNodeProb- => prob($nodea,$nodeb):$delivery_pred($nodea,$nodeb)"
		
	
}


#PRoPHET delivery predictability transitive update when node a meet node b
Agent/MessagePassing/Prophet instproc transitiveNodeProb {nodea nodeb nodec} {
	global ns k Gamma Beta delivery_pred a

	set current_time [format "%.2f" [expr {double(round(100*[$ns now]))/100}]]
	set delivery_pred($nodea,$nodec) [format "%.4f" [expr ($delivery_pred($nodea,$nodec) + (1 - $delivery_pred($nodea,$nodec)) * $delivery_pred($nodea,$nodeb) 		* $delivery_pred($nodeb,$nodec) * $Beta )]]
	set delivery_pred($nodea,$nodec,"time") $current_time	

	writeFT "\n$delivery_pred($nodea,$nodec,"time") -transitiveNodeProb- => prob($nodea,$nodec):$delivery_pred($nodea,$nodec)"

}

#Aging manager for every delivery predictability
Agent/MessagePassing/Prophet instproc agingNodeProbManager {nodea} {
	global ns k delivery_pred a num_nodes sim_stop
	$self instvar node_

	for {set i 0} {$i<$num_nodes} {incr i} {
		
		if {( $i != $nodea ) && ( $delivery_pred($nodea,$i) != 0 )} {
			
			$a($nodea) agingNodeProb $nodea $i

		}
	}

	
	#every k unit time aging function is called 
	if {$sim_stop == 0} {
		$ns after $k "$a($nodea) agingNodeProbManager $nodea"
	}


}



		      
#receive function - called for every packet received
Agent/MessagePassing/Prophet instproc recv {source sport size data} {
	$self instvar messages_seen node_ 
	global ns BROADCAST_ADDR  delivery_pred friends a num_nodes array_spy fspyer threshold fgraph fgraphSpy

	#extract message id and data from packet
    set packet_id [lindex [split $data ":"] 0]
    set packet_data [lindex [split $data ":"] 1]
    

	#$source=packet sender       $[$node_ node-addr]=packet receiver
	set packet_receiver [$node_ node-addr]
    set current_time [format "%.2f" [expr {double(round(100*[$ns now]))/100}]]
	
	#check if node is normal(type=0) or spy(type=1) 
	if {$a($packet_receiver,'type') == 0} { 
		#normal node
	
		writeFT "\n$current_time -recvPacket- => pkt_id:$packet_id (NormalNode) pkt_source:$source pkt_receiver:$packet_receiver"
    	


		#delivery predictability algorithm start

		#start aging only if is first time that node (receiver) receive a packet (flag_aging = 0)
		if {$delivery_pred($packet_receiver,"flag_aging") != 1} {
			set delivery_pred($packet_receiver,"flag_aging") 1
			$a($packet_receiver) agingNodeProbManager $packet_receiver
		}

		#set meet delivery predictability
		$a($packet_receiver) meetNodeProb $packet_receiver $source
		# add node met in friends list
		if { [lsearch $friends($packet_receiver) $source] == -1 } { 
			if {$friends($packet_receiver) == "null"} {
				set friends($packet_receiver) $source
			} else {
				lappend friends($packet_receiver) $source  
			}  
			writeFT "\n$current_time -addNewFriend- => node:$packet_receiver friends:$friends($packet_receiver)"
		}
	

		#set transitive delivery predictability for every node that aren't receiver friend 
		#(not set if is pkt_sender or is receiver's friend or is it self)
		for {set x 0} {$x < $num_nodes} {incr x} {
			if { ([lsearch $friends($packet_receiver) $x] == -1) && ( $x != $source) && ( $x != $packet_receiver ) && ( $delivery_pred($source,$x) != 0)} {
				#set transitive delivery predictability
				$a($packet_receiver) transitiveNodeProb $packet_receiver $source $x
			
			} 
		}


		#delivery predictability algorithm finish




	


		if {[lsearch $messages_seen $packet_id] == -1} {
			lappend messages_seen $packet_id  
		} 


	} else { #spy node
		
		
		writeFT "\n$current_time -recvPacket- => pkt_id:$packet_id (SpyNode) pkt_source:$source pkt_receiver:$packet_receiver"
		
		#save all delivery predictability of node met
		for {set i 0} {$i<$num_nodes} {incr i} {
			if {$array_spy($source) == "null"} {
				set array_spy($source) $delivery_pred($source,$i)	
			} else {
				lappend array_spy($source) $delivery_pred($source,$i)
			}
				
			
		}
		
		set var_source $source
		
		#trace of spy node
		writeFS "\n $current_time  delivery_pred of node $source\n"

		#create xml file for rappresent graph of spy's known
		puts -nonewline $fgraphSpy "   <nodi>\n     <nodo>$var_source</nodo> \n"
		for {set j 0} {$j<$num_nodes} {incr j} {
			puts -nonewline $fspyer "prob($source,$j)=$delivery_pred($source,$j)  "
			
			if {$delivery_pred($source,$j)>$threshold} {
						
					puts -nonewline $fgraphSpy "  \n                 <amico>$j</amico> \n    "	
			}			
				
		}
		puts -nonewline $fgraphSpy "</nodi>     \n      \n"
		
	}
}


	      		  		 
#send packet function
Agent/MessagePassing/Prophet instproc send_tables {size packet_id data port} {
    $self instvar messages_seen node_
    global ns MESSAGE_PORT BROADCAST_ADDR 
    lappend messages_seen $packet_id
	set current_time [format "%.2f" [expr {double(round(100*[$ns now]))/100}]]
	writeFT "\n$current_time -sendPacket- => pkt_id:$packet_id pkt_sender:[$node_ node-addr]"

	#send packet in broadcast
    $self sendto $size "$packet_id:$data" $BROADCAST_ADDR $port
}


#update zone procedure - used when a node move to another zone
Agent/MessagePassing/Prophet instproc update_zone {zone} {
	global a zone_list ns
	$self instvar node_
	set current_time [format "%.2f" [expr {double(round(100*[$ns now]))/100}]]
	set old_zone $a([$node_ node-addr],'zone')
	set a([$node_ node-addr],'zone') $zone
	
	writeFT "\n$current_time - aggiornamentoZona => $zone"
	

	set idxNew [lsearch $zone_list($zone) "null"]
	set zone_list($zone) [lreplace  $zone_list($zone) $idxNew $idxNew]
	set idx [lsearch $zone_list($old_zone) "[$node_ node-addr]"]
	set zone_list($old_zone) [lreplace  $zone_list($old_zone) $idx $idx]
	lappend zone_list($zone) [$node_ node-addr]
	
	for {set i 0} {$i<4} {incr i} {
	
		writeFT "\n$current_time -lista zona$i => $zone_list($i)"
	}	
}


#initialize all nodes
for {set i 0} {$i < $num_nodes} {incr i} {
     
	set friends($i) "null" 
	
	for {set j 0} {$j < $num_nodes} {incr j} { 
		
		set delivery_pred($i,$j) 0 
		set delivery_pred($i,$j,"time") 0.0 
		
	}

	set delivery_pred($i,"flag_aging") 0
	set n($i) [$ns node]
	set array_spy($i) "null" 
   	
}

#create spy - move spy first time from out of bound to established zone
proc createSpy {zone x y} {
	global num_nodes n ns MESSAGE_PORT z a 
	$n([expr ($num_nodes-1)]) setdest $x $y 8000)
	set current_time [format "%.2f" [expr {double(round(100*[$ns now]))/100}]]
	writeFT "\n$current_time -createspy- => zone_x: $x zone_y: $y"
}



#inizializate nodes' position
$n(0) set Y_ $z0_y
$n(0) set X_ $z0_x
$n(0) set Z_ 0.0
$ns initial_node_pos $n(0) 120

$n(1) set Y_ $z0_y
$n(1) set X_ $z0_x
$n(1) set Z_ 0.0
$ns initial_node_pos $n(1) 120

$n(2) set Y_ $z1_y
$n(2) set X_ $z1_x
$n(2) set Z_ 0.0
$ns initial_node_pos $n(2) 120


$n(3) set Y_ $z2_y
$n(3) set X_ $z2_x
$n(3) set Z_ 0.0
$ns initial_node_pos $n(3) 120

$n(4) set Y_ $z2_y
$n(4) set X_ $z2_x
$n(4) set Z_ 0.0
$ns initial_node_pos $n(4) 120

$n(5) set Y_ $z2_y
$n(5) set X_ $z2_x
$n(5) set Z_ 0.0
$ns initial_node_pos $n(5) 120

$n(6) set Y_ $z3_y
$n(6) set X_ $z3_x
$n(6) set Z_ 0.0
$ns initial_node_pos $n(6) 120



# attach a new Agent/MessagePassing/Flooding to each node on port $MESSAGE_PORT
for {set i 0} {$i <[expr ($num_nodes-1)]} {incr i} {
    set a($i) [new Agent/MessagePassing/Prophet]
    $n($i) attach  $a($i) $MESSAGE_PORT
    $a($i) set messages_seen {}
	set a($i,'zone') 0
	set a($i,'type') 0
}

#initialize spy node 	
$n([expr ($num_nodes-1)]) set Y_ 400.0
$n([expr ($num_nodes-1)]) set X_ 1599.0
$n([expr ($num_nodes-1)]) set Z_ 0.0
$ns initial_node_pos $n([expr ($num_nodes-1)]) 180
set a([expr ($num_nodes-1)]) [new Agent/MessagePassing/Prophet]
$n([expr ($num_nodes-1)]) attach  $a([expr ($num_nodes-1)]) $MESSAGE_PORT
$a([expr ($num_nodes-1)]) set messages_seen {}
set a([expr ($num_nodes-1)],'zone') 3
set a([expr ($num_nodes-1)],'type') 1




# events scheduler

source scenario_tesi1.tcl

#create xml file for rappresent graph of scenario
proc writeFriends {} {
	global num_nodes friends
	set fgraph [open wireless-prophet-graph.xml w]
	puts  -nonewline $fgraph "<xml version=\"1.0\" encoding=\"UTF-8\">\n"
	
	for {set i 0} {$i<$num_nodes} {incr i} {
		
		puts -nonewline $fgraph "   <nodi>\n     <nodo>$i</nodo> "

		for {set j 0} {$j<[llength $friends($i)]} {incr j} {
			puts -nonewline $fgraph "  \n                 <amico>[lindex $friends($i) $j]</amico> \n    "	
			
		}
	puts -nonewline $fgraph "</nodi>     \n      \n"
	}
	
	close $fgraph
}

#trace all delivery predictability at simulation finish
proc writeDeliv {} {
	global num_nodes delivery_pred friends 
	set fdeliv [open wireless-prophet-deliv.tr w]	
	for {set i 0} {$i<$num_nodes} {incr i} {
		puts  -nonewline $fdeliv "\nfriends of node $i: $friends($i)\n"	
		puts  -nonewline $fdeliv "delivery_pred of node $i\n"
		for {set j 0} {$j<$num_nodes} {incr j} {
			puts -nonewline $fdeliv "prob($i,$j)=$delivery_pred($i,$j)\n"
			
		}
		puts -nonewline $fdeliv "\n---------------------\n"
	}
	close $fdeliv
}

#close all trace files
proc finish {} {
	global ns f val ftracer fspyer nf 
	writeDeliv 
	writeFriends
    flush $ftracer
	flush $fspyer
	close $ftracer 
	close $fspyer 
	close $nf
	
	puts "running nam..."
    	exec nam wireless-prophet-$val(rp).nam &
	exit 0
}

$ns run


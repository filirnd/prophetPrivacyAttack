$ns at 0.1 "$a(0) update_zone 0"
$ns at 0.1 "$a(1) update_zone 0"
$ns at 0.1 "$a(2) update_zone 1"
$ns at 0.1 "$a(3) update_zone 2"
$ns at 0.1 "$a(4) update_zone 2"
$ns at 0.1 "$a(5) update_zone 2"
$ns at 0.1 "$a(6) update_zone 3"

#nodo0 e nodo1 si scambiano le tabelle 
$ns at 0.2 "$a(0) send_tables 50 1 {Packetfrom0} $MESSAGE_PORT"
$ns at 0.6 "$a(1) send_tables 50 2 {Packetfrom1} $MESSAGE_PORT"

#nodo3,nodo4 e nodo5 si scambiano le tabelle 
$ns at 1.0 "$a(3) send_tables 50 3 {Packetfrom3} $MESSAGE_PORT"
$ns at 1.4 "$a(4) send_tables 50 4 {Packetfrom4} $MESSAGE_PORT"
$ns at 1.8 "$a(5) send_tables 50 5 {Packetfrom5} $MESSAGE_PORT"

#nodo0 si sposta nella zona1
$ns at 1.0 "$n(0) setdest $z1_x $z1_y 8000"
$ns at 1.2 "$a(0) update_zone 1"

#scambio di tabelle tra nodo0 e nodo2
$ns at 3.8 "$a(2) send_tables 50 6 {Packetfrom0} $MESSAGE_PORT"
$ns at 4.8 "$a(0) send_tables 50 7 {Packetfrom0} $MESSAGE_PORT"

#nodo0 torna nella sua zona0
$ns at 5.2 "$n(0) setdest $z0_x $z0_y 8000"
$ns at 5.6 "$a(0) update_zone 0"

#scambio di tabelle tra nodo0 e nodo1
$ns at 7.6 "$a(1) send_tables 50 8 {Packetfrom0} $MESSAGE_PORT"
$ns at 8.0 "$a(0) send_tables 50 9 {Packetfrom0} $MESSAGE_PORT"

#nodo1 si sposta nella zona2
$ns at 8.6 "$n(1) setdest $z2_x $z2_y 8000"
$ns at 9.0 "$a(1) update_zone 2"

#scambio di tabelle tra nodo1 e nodo3,nodo4,nodo5
$ns at 11.0 "$a(3) send_tables 50 10 {Packetfrom3} $MESSAGE_PORT"
$ns at 11.4 "$a(4) send_tables 50 11 {Packetfrom4} $MESSAGE_PORT"
$ns at 11.8 "$a(5) send_tables 50 12 {Packetfrom5} $MESSAGE_PORT"
$ns at 12.2 "$a(1) send_tables 50 13 {Packetfrom1} $MESSAGE_PORT"

#nodo1 torna nella sua zona0
$ns at 12.6 "$n(1) setdest $z0_x $z0_y 8000"
$ns at 12.6 "$a(1) update_zone 0"

#scambio di tabelle tra nodo0 e nodo1
$ns at 13.8 "$a(0) send_tables 50 14 {Packetfrom0} $MESSAGE_PORT"
$ns at 14.2 "$a(1) send_tables 50 15 {Packetfrom0} $MESSAGE_PORT"


#nodo3 si sposta nella zona1
$ns at 14.4 "$n(3) setdest $z1_x $z1_y 8000"
$ns at 14.4 "$a(3) update_zone 1"

#scambio di tabelle tra nodo3 e nodo2
$ns at 16.4 "$a(2) send_tables 50 16 {Packetfrom2} $MESSAGE_PORT"
$ns at 16.8 "$a(3) send_tables 50 17 {Packetfrom3} $MESSAGE_PORT"

#nodo3 torna nella sua zona2
$ns at 17.4 "$n(3) setdest $z2_x $z2_y 8000"
$ns at 17.4 "$a(3) update_zone 2"

#scambio di tabelle tra nodo3 nodo4 e nodo5
$ns at 19.4 "$a(4) send_tables 50 18 {Packetfrom0} $MESSAGE_PORT"
$ns at 19.8 "$a(5) send_tables 50 19 {Packetfrom0} $MESSAGE_PORT"
$ns at 20.2 "$a(3) send_tables 50 20 {Packetfrom0} $MESSAGE_PORT"

#nodo4 si sposta nella zona0
$ns at 20.6 "$n(4) setdest $z0_x $z0_y 8000"
$ns at 20.6 "$a(4) update_zone 0"

#scambio di tabelle tra nodo4,nodo1 e nodo0
$ns at 22.6 "$a(0) send_tables 50 21 {Packetfrom0} $MESSAGE_PORT"
$ns at 23.0 "$a(1) send_tables 50 22 {Packetfrom1} $MESSAGE_PORT"
$ns at 23.4 "$a(4) send_tables 50 23 {Packetfrom4} $MESSAGE_PORT"

#nodo4 torna nella sua zona2
$ns at 23.8 "$n(4) setdest $z2_x $z2_y 8000"
$ns at 23.8 "$a(4) update_zone 2"

#scambio di tabelle tra nodo4 nodo3 e nodo5
$ns at 26.0 "$a(3) send_tables 50 24 {Packetfrom0} $MESSAGE_PORT"
$ns at 26.4 "$a(5) send_tables 50 25 {Packetfrom1} $MESSAGE_PORT"
$ns at 26.8 "$a(4) send_tables 50 26 {Packetfrom4} $MESSAGE_PORT"

#nodo3 si sposta nella zona1
$ns at 27.2 "$n(3) setdest $z1_x $z1_y 8000"
$ns at 27.2 "$a(3) update_zone 1"

#scambio di tabelle tra nodo2 e nodo3
$ns at 29.2 "$a(2) send_tables 50 27 {Packetfrom2} $MESSAGE_PORT"
$ns at 29.6 "$a(3) send_tables 50 28 {Packetfrom1} $MESSAGE_PORT"

#nodo3 torna nella sua zona2
$ns at 30.0 "$n(3) setdest $z2_x $z2_y 8000"
$ns at 30.0 "$a(3) update_zone 2"

#scambio di tabelle tra nodo3,nodo4 e nodo5
$ns at 32.0 "$a(4) send_tables 50 29 {Packetfrom0} $MESSAGE_PORT"
$ns at 32.4 "$a(5) send_tables 50 30 {Packetfrom1} $MESSAGE_PORT"
$ns at 32.8 "$a(3) send_tables 50 31 {Packetfrom4} $MESSAGE_PORT"

#nodo4 si sposta nella zona0
$ns at 33.2 "$n(4) setdest $z0_x $z0_y 8000"
$ns at 33.2 "$a(4) update_zone 0"

#scambio di tabelle tra nodo4,nodo1 e nodo0
$ns at 35.0 "$a(0) send_tables 50 32 {Packetfrom0} $MESSAGE_PORT"
$ns at 35.4 "$a(1) send_tables 50 33 {Packetfrom1} $MESSAGE_PORT"
$ns at 35.8 "$a(4) send_tables 50 34 {Packetfrom4} $MESSAGE_PORT"

#nodo4 torna nella sua zona2
$ns at 36.2 "$n(4) setdest $z2_x $z2_y 8000"
$ns at 36.2 "$a(4) update_zone 2"

#scambio di tabelle tra nodo4,nodo3 e nodo5
$ns at 38.2 "$a(3) send_tables 50 35 {Packetfrom0} $MESSAGE_PORT"
$ns at 38.6 "$a(5) send_tables 50 36 {Packetfrom1} $MESSAGE_PORT"
$ns at 40.0 "$a(4) send_tables 50 37 {Packetfrom4} $MESSAGE_PORT"

#nodo5 si sposta nella zona1
$ns at 40.4 "$n(5) setdest $z1_x $z1_y 8000"
$ns at 40.4 "$a(5) update_zone 1"

#scambio di tabelle tra nodo5 e nodo2
$ns at 43.0 "$a(2) send_tables 50 38 {Packetfrom2} $MESSAGE_PORT"
$ns at 43.4 "$a(5) send_tables 50 39 {Packetfrom5} $MESSAGE_PORT"


#nodo5 torna nella sua zona2
$ns at 43.8 "$n(5) setdest $z2_x $z2_y 8000"
$ns at 43.8 "$a(5) update_zone 2"

#scambio di tabelle tra nodo5,nodo3 e nodo4
$ns at 46.0 "$a(3) send_tables 50 40 {Packetfrom0} $MESSAGE_PORT"
$ns at 46.4 "$a(4) send_tables 50 41 {Packetfrom1} $MESSAGE_PORT"
$ns at 46.8 "$a(5) send_tables 50 42 {Packetfrom4} $MESSAGE_PORT"

#nodo3 si sposta nella zona1
$ns at 50.0 "$n(3) setdest $z1_x $z1_y 8000"
$ns at 50.0 "$a(3) update_zone 1"

#scambio di tabelle tra nodo3 e nodo2
$ns at 52.0 "$a(2) send_tables 50 43 {Packetfrom2} $MESSAGE_PORT"
$ns at 52.4 "$a(3) send_tables 50 44 {Packetfrom3} $MESSAGE_PORT"


#nodo3 torna nella sua zona2
$ns at 52.8 "$n(3) setdest $z2_x $z2_y 8000"
$ns at 52.8 "$a(3) update_zone 2"

#scambio di tabelle tra nodo3,nodo5 e nodo4
$ns at 55.0 "$a(4) send_tables 50 45 {Packetfrom0} $MESSAGE_PORT"
$ns at 55.4 "$a(5) send_tables 50 46 {Packetfrom1} $MESSAGE_PORT"
$ns at 55.8 "$a(3) send_tables 50 47 {Packetfrom4} $MESSAGE_PORT"

#nodo4 si sposta nella zona1
$ns at 56.2 "$n(4) setdest $z1_x $z1_y 8000"
$ns at 56.2 "$a(4) update_zone 1"

#scambio di tabelle tra nodo4 e nodo2
$ns at 59.0 "$a(2) send_tables 50 48 {Packetfrom2} $MESSAGE_PORT"
$ns at 59.4 "$a(4) send_tables 50 49 {Packetfrom3} $MESSAGE_PORT"


#nodo4 torna nella sua zona2
$ns at 59.8 "$n(4) setdest $z2_x $z2_y 8000"
$ns at 59.8 "$a(4) update_zone 2"

#scambio di tabelle tra nodo4,nodo3 e nodo5
$ns at 62.0 "$a(3) send_tables 50 50 {Packetfrom0} $MESSAGE_PORT"
$ns at 62.4 "$a(5) send_tables 50 51 {Packetfrom1} $MESSAGE_PORT"
$ns at 62.8 "$a(4) send_tables 50 52 {Packetfrom4} $MESSAGE_PORT"

#nodo0 si sposta nella zona2
$ns at 63.2 "$n(0) setdest $z2_x $z2_y 8000"
$ns at 63.2 "$a(0) update_zone 2"

#scambio di tabelle tra nodo0, nodo3, nodo4 e nodo5
$ns at 65.0 "$a(3) send_tables 50 53 {Packetfrom3} $MESSAGE_PORT"
$ns at 65.4 "$a(4) send_tables 50 54 {Packetfrom4} $MESSAGE_PORT"
$ns at 65.8 "$a(5) send_tables 50 55 {Packetfrom5} $MESSAGE_PORT"
$ns at 66.2 "$a(0) send_tables 50 56 {Packetfrom0} $MESSAGE_PORT"

#nodo0 torna nella sua zona0
$ns at 66.6 "$n(0) setdest $z0_x $z0_y 8000"
$ns at 70.6 "$a(0) update_zone 0"

#scambio di tabelle tra nodo0 e nodo1
$ns at 72.6 "$a(1) send_tables 50 57 {Packetfrom1} $MESSAGE_PORT"
$ns at 73.2 "$a(0) send_tables 50 58 {Packetfrom0} $MESSAGE_PORT"


#nodo6 si sposta nella zona1
$ns at 73.8 "$n(6) setdest $z1_x $z1_y 8000"
$ns at 73.8 "$a(6) update_zone 1"

#scambio di tabelle tra nodo6 e nodo2
$ns at 75.8 "$a(2) send_tables 50 59 {Packetfrom2} $MESSAGE_PORT"
$ns at 76.2 "$a(6) send_tables 50 60 {Packetfrom6} $MESSAGE_PORT"

#nodo6 torna nella sua zona3
$ns at 76.8 "$n(6) setdest $z3_x $z3_y 8000"
$ns at 76.8 "$a(6) update_zone 3"

#nodo4 si sposta nella zona0
$ns at 79.0 "$n(4) setdest $z0_x $z0_y 8000"
$ns at 79.0 "$a(4) update_zone 0"

#scambio di tabelle tra nodo4,nodo1 e nodo0
$ns at 81.0 "$a(0) send_tables 50 61 {Packetfrom0} $MESSAGE_PORT"
$ns at 81.4 "$a(1) send_tables 50 62 {Packetfrom1} $MESSAGE_PORT"
$ns at 81.8 "$a(4) send_tables 50 63 {Packetfrom4} $MESSAGE_PORT"

#nodo4 torna nella sua zona2
$ns at 82.0 "$n(4) setdest $z2_x $z2_y 8000"
$ns at 82.0 "$a(4) update_zone 2"

#scambio di tabelle tra nodo4,nodo3 e nodo5
$ns at 83.0 "$a(3) send_tables 50 64 {Packetfrom0} $MESSAGE_PORT"
$ns at 83.6 "$a(5) send_tables 50 65 {Packetfrom1} $MESSAGE_PORT"
$ns at 84.0 "$a(4) send_tables 50 66 {Packetfrom4} $MESSAGE_PORT"

#nodo5 si sposta nella zona1
$ns at 84.4 "$n(5) setdest $z1_x $z1_y 8000"
$ns at 84.4 "$a(5) update_zone 1"

#scambio di tabelle tra nodo5 e nodo2
$ns at 86.6 "$a(2) send_tables 50 67 {Packetfrom2} $MESSAGE_PORT"
$ns at 87.0 "$a(5) send_tables 50 68 {Packetfrom5} $MESSAGE_PORT"


#nodo5 torna nella sua zona2
$ns at 87.6 "$n(5) setdest $z2_x $z2_y 8000"
$ns at 87.6 "$a(5) update_zone 2"

#scambio di tabelle tra nodo5,nodo3 e nodo4
$ns at 90.0 "$a(3) send_tables 50 69 {Packetfrom0} $MESSAGE_PORT"
$ns at 90.6 "$a(4) send_tables 50 70 {Packetfrom1} $MESSAGE_PORT"
$ns at 91.0 "$a(5) send_tables 50 71 {Packetfrom4} $MESSAGE_PORT"

#nodo3 si sposta nella zona1
$ns at 92.0 "$n(3) setdest $z1_x $z1_y 8000"
$ns at 92.0 "$a(3) update_zone 1"

#scambio di tabelle tra nodo3 e nodo2
$ns at 95.0 "$a(2) send_tables 50 72 {Packetfrom2} $MESSAGE_PORT"
$ns at 95.6 "$a(3) send_tables 50 73 {Packetfrom3} $MESSAGE_PORT"


#nodo3 torna nella sua zona2
$ns at 96.0 "$n(3) setdest $z2_x $z2_y 8000"
$ns at 96.0 "$a(3) update_zone 2"

#scambio di tabelle tra nodo3,nodo4 e nodo5
$ns at 98.0 "$a(4) send_tables 50 74 {Packetfrom0} $MESSAGE_PORT"
$ns at 98.6 "$a(5) send_tables 50 75 {Packetfrom1} $MESSAGE_PORT"
$ns at 99.0 "$a(3) send_tables 50 76 {Packetfrom4} $MESSAGE_PORT"

#nodo4 si sposta nella zona1
$ns at 100.0 "$n(4) setdest $z1_x $z1_y 8000"
$ns at 100.0 "$a(4) update_zone 1"

#scambio di tabelle tra nodo4 e nodo2
$ns at 102.0 "$a(2) send_tables 50 77 {Packetfrom2} $MESSAGE_PORT"
$ns at 102.6 "$a(4) send_tables 50 78 {Packetfrom3} $MESSAGE_PORT"


#nodo4 torna nella sua zona2
$ns at 103.0 "$n(4) setdest $z2_x $z2_y 8000"
$ns at 103.0 "$a(4) update_zone 2"

#scambio di tabelle tra nodo4,nodo3 e nodo5
$ns at 105.0 "$a(3) send_tables 50 79 {Packetfrom0} $MESSAGE_PORT"
$ns at 105.6 "$a(5) send_tables 50 80 {Packetfrom1} $MESSAGE_PORT"
$ns at 107.0 "$a(4) send_tables 50 81 {Packetfrom4} $MESSAGE_PORT"

#nodo0 si sposta nella zona2
$ns at 111.0 "$n(0) setdest $z2_x $z2_y 8000"
$ns at 111.4 "$a(0) update_zone 2"

#scambio di tabelle tra nodo0, nodo3, nodo4 e nodo5
$ns at 113.4 "$a(3) send_tables 50 82 {Packetfrom3} $MESSAGE_PORT"
$ns at 113.8 "$a(4) send_tables 50 83 {Packetfrom4} $MESSAGE_PORT"
$ns at 114.0 "$a(5) send_tables 50 84 {Packetfrom5} $MESSAGE_PORT"
$ns at 114.4 "$a(0) send_tables 50 85 {Packetfrom0} $MESSAGE_PORT"

#nodo0 torna nella sua zona0
$ns at 115.0 "$n(0) setdest $z0_x $z0_y 8000"
$ns at 115.8 "$a(0) update_zone 0"

#scambio di tabelle tra nodo1 e nodo0
$ns at 118.0 "$a(1) send_tables 50 86 {Packetfrom0} $MESSAGE_PORT"
$ns at 118.6 "$a(0) send_tables 50 87 {Packetfrom1} $MESSAGE_PORT"

#nodo6 si sposta nella zona1
$ns at 119.0 "$n(6) setdest $z1_x $z1_y 8000"
$ns at 119.0 "$a(6) update_zone 1"

#scambio di tabelle tra nodo 6 e nodo2
$ns at 121.0 "$a(2) send_tables 50 88 {Packetfrom2} $MESSAGE_PORT"
$ns at 121.4 "$a(6) send_tables 50 89 {Packetfrom6} $MESSAGE_PORT"

#nodo6 torna nella sua zona3
$ns at 122.0 "$n(6) setdest $z3_x $z3_y 8000"
$ns at 122.6 "$a(6) update_zone 3"


#nodo7(SPIA) si sposta nella zona3, si scambiano le tabelle con il nodo6
$ns at 125.0 "createSpy 3 760 5"
$ns at 125.4 "$a(7) update_zone 3"
$ns at 127.0 "$a(7) send_tables 50 86 {Packetfrom7} $MESSAGE_PORT"
$ns at 127.6 "$a(6) send_tables 50 87 {Packetfrom6} $MESSAGE_PORT"

#nodo7(SPIA) si sposta nella zona1, si scambiano le tabelle con il nodo2
$ns at 128.4 "$n(7) setdest 2 760 8000"
$ns at 130.0 "$a(7) update_zone 1"
$ns at 132.0 "$a(2) send_tables 50 88 {Packetfrom2} $MESSAGE_PORT"
$ns at 132.8 "$a(7) send_tables 50 89 {Packetfrom7} $MESSAGE_PORT"

#nodo7(SPIA) si sposta nella zona0, si scambiano le tabelle con il nodo0,nodo1
$ns at 133.0 "$n(7) setdest 2 200 8000"
$ns at 133.6 "$a(7) update_zone 0"
$ns at 136.0 "$a(0) send_tables 50 90 {Packetfrom2} $MESSAGE_PORT"
$ns at 136.6 "$a(1) send_tables 50 91 {Packetfrom2} $MESSAGE_PORT"
$ns at 137.0 "$a(7) send_tables 50 92 {Packetfrom2} $MESSAGE_PORT"


#nodo7(SPIA) si sposta nella zona2, si scambiano le tabelle con il nodo3,nodo4,nodo5
$ns at 138.0 "$n(7) setdest 760 760 8000"
$ns at 138.6 "$a(7) update_zone 2"
$ns at 140.6 "$a(3) send_tables 50 93 {Packetfrom2} $MESSAGE_PORT"
$ns at 141.2 "$a(4) send_tables 50 94 {Packetfrom2} $MESSAGE_PORT"
$ns at 141.8 "$a(5) send_tables 50 95 {Packetfrom2} $MESSAGE_PORT"
$ns at 142.2 "$a(7) send_tables 50 96 {Packetfrom2} $MESSAGE_PORT"













$ns at 142.2 "set sim_stop 1"

$ns at 150.0 "finish"

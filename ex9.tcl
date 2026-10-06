# Congestion Control Simulation

set ns [new Simulator]

# Trace files
set tracefile [open congestion.tr w]
$ns trace-all $tracefile

set namfile [open congestion.nam w]
$ns namtrace-all $namfile

# Nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Links
$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 20ms DropTail

# Queue limit
$ns queue-limit $n2 $n3 20

$ns duplex-link $n3 $n4 10Mb 10ms DropTail
$ns duplex-link $n3 $n5 10Mb 10ms DropTail

# TCP Agent
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

# TCP Sink
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink

$ns connect $tcp $sink

# FTP over TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp

# UDP Agent
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

# UDP Sink
set null [new Agent/Null]
$ns attach-agent $n5 $null

$ns connect $udp $null

# CBR over UDP
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packetSize_ 1000
$cbr set interval_ 0.005

# Finish Procedure
proc finish {} {
    global ns tracefile namfile

    $ns flush-trace
    close $tracefile
    close $namfile

    exec nam congestion.nam &
    exit 0
}

# Start Traffic
$ns at 0.5 "$ftp start"
$ns at 1.0 "$cbr start"

# Stop Traffic
$ns at 8.5 "$ftp stop"
$ns at 9.0 "$cbr stop"

# Finish simulation
$ns at 10.0 "finish"

# Run simulation
$ns run


# Distance Vector Routing Simulation

# Create Simulator
set ns [new Simulator]

# Enable Distance Vector routing
$ns rtproto DV

# NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf

# General trace file
set nt [open trace.tr w]
$ns trace-all $nt

# Finish procedure
proc finish {} {
    global ns nf

    $ns flush-trace
    close $nf

    exec nam -a out.nam &
    exit 0
}

# Create nodes
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]

# Create ring topology
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail
$ns duplex-link $n5 $n6 1Mb 10ms DropTail
$ns duplex-link $n6 $n7 1Mb 10ms DropTail
$ns duplex-link $n7 $n8 1Mb 10ms DropTail
$ns duplex-link $n8 $n1 1Mb 10ms DropTail

# Set link orientations
$ns duplex-link-op $n1 $n2 orient left-up
$ns duplex-link-op $n2 $n3 orient up
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n4 $n5 orient right
$ns duplex-link-op $n5 $n6 orient right-down
$ns duplex-link-op $n6 $n7 orient down
$ns duplex-link-op $n7 $n8 orient left-down
$ns duplex-link-op $n8 $n1 orient left

# UDP Agent
set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0

# CBR Traffic
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

# Destination
set null0 [new Agent/Null]
$ns attach-agent $n4 $null0

# Connect source and destination
$ns connect $udp0 $null0

# Node labels
$ns at 0.0 "$n1 label Source"
$ns at 0.0 "$n4 label Destination"

# Start CBR traffic
$ns at 0.5 "$cbr0 start"

# Bring link down
$ns rtmodel-at 1.0 down $n3 $n4

# Bring link back up
$ns rtmodel-at 2.0 up $n3 $n4

# Stop traffic
$ns at 4.5 "$cbr0 stop"

# Finish simulation
$ns at 5.0 "finish"

# Run simulation
$ns run


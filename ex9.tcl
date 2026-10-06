# Create Simulator
set ns [new Simulator]

# Set colors for NAM
$ns color 1 Blue
$ns color 2 Red

# Create NAM trace file
set nf [open out.nam w]
$ns namtrace-all $nf

# Finish procedure
proc finish {} {
    global ns nf

    $ns flush-trace
    close $nf

    exec nam out.nam &
    exit 0
}

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# Create links
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7Mb 20ms DropTail

# Set queue limit
$ns queue-limit $n2 $n3 10

# Set link orientations for NAM
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

# Set queue position
$ns duplex-link-op $n2 $n3 queuePos 0.5

# TCP Agent
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n0 $tcp

# TCP Sink
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink

# Connect TCP and sink
$ns connect $tcp $sink
$tcp set fid_ 1

# FTP Application
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

# UDP Agent
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

# UDP Sink
set null [new Agent/Null]
$ns attach-agent $n3 $null

# Connect UDP and sink
$ns connect $udp $null
$udp set fid_ 2

# CBR Application
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false

# Start CBR
$ns at 0.1 "$cbr start"

# Start FTP
$ns at 1.0 "$ftp start"

# Stop FTP
$ns at 4.0 "$ftp stop"

# Stop CBR
$ns at 4.5 "$cbr stop"

# Detach TCP agents
$ns at 4.5 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n3 $sink"

# Finish simulation
$ns at 5.0 "finish"

# Display CBR parameters
puts "CBR packet size = [$cbr set packet_size_]"
puts "CBR interval = [$cbr set interval_]"

# Run simulation
$ns run


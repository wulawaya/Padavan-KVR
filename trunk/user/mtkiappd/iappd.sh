#!/bin/sh


start() {   if grep -q 'mt76x3_ap' /proc/modules ; then
	    mtkiappd -wi rai0           &
	    sysctl -wq net.ipv4.neigh.rai0.base_reachable_time_ms=10000
	    sysctl -wq net.ipv4.neigh.rai0.delay_first_probe_time=1
            else
	    if grep -q 'rai0' /proc/interrupts; then
	    mtkiappd -wi rai0 -wi ra0   &
	    sysctl -wq net.ipv4.neigh.rai0.base_reachable_time_ms=10000
	    sysctl -wq net.ipv4.neigh.rai0.delay_first_probe_time=1
	    else
	    mtkiappd -wi rax0 -wi ra0   &
	    sysctl -wq net.ipv4.neigh.rax0.base_reachable_time_ms=10000
	    sysctl -wq net.ipv4.neigh.rax0.delay_first_probe_time=1	    
	    fi
	    fi
	    sysctl -wq net.ipv4.neigh.br0.base_reachable_time_ms=10000
	    sysctl -wq net.ipv4.neigh.br0.delay_first_probe_time=1
	    sysctl -wq net.ipv4.neigh.eth2.base_reachable_time_ms=10000
	    sysctl -wq net.ipv4.neigh.eth2.delay_first_probe_time=1
	    sysctl -wq net.ipv4.neigh.ra0.base_reachable_time_ms=10000
	    sysctl -wq net.ipv4.neigh.ra0.delay_first_probe_time=1
	    iptables -A INPUT -i br0 -p tcp --dport 3517 -j ACCEPT
	    iptables -A INPUT -i br0 -p udp --dport 3517 -j ACCEPT 
}





stop() {
    pid=`pidof mtkiappd`
    if [ "$pid" != "" ]; then
        killall -q  mtkiappd
	sleep 1
	killall -q  mtkiappd
	sleep 1
    fi
    
}


case "$1" in
        start)
            start
            ;;

        stop)
            stop
            ;;

        restart)
            start
            ;;

        *)
            echo $"Usage: $0 {start|stop|restart}"
esac

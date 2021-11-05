#!/bin/bash
#
#  Copyright (C) 2021 Red Hat Inc.
# 
# Author: Flavio Leitner <fbl@redhat.com>
# Script to load probes.
# Requirements: kernel-debuginfo.
# 

log_fatal() {
    echo "Error: $*"
    exit 1
}

perf_probe_install() {
    symbol=$1
    if ! perf probe -m "openvswitch" -f -a "$symbol skb=skb"; then
        log_fatal "Failed to add probe at $symbol"
    fi
}

#echo "Removing all exiting perf probes"
#for probe in $( perf probe -l | awk '{ print $1 }' )
#do
#	perf probe -f -d $probe
#done 

echo "Adding necessary perf probes."
echo "It requires the kernel-debuginfo package installed."
echo "Press 'Enter' to continue or ctrl+c to stop"
read A

# Open vSwitch probes
perf_probe_install ovs_vport_receive
perf_probe_install do_output
perf_probe_install ovs_dp_upcall

echo "Start perf recording with the command line below"
echo "Hit CTRL+C to stop the recording"
echo "perf record \\"
echo "  -e probe:ovs_vport_receive \\"
echo "  -e probe:do_output \\"
echo "  -e probe:ovs_dp_upcall"


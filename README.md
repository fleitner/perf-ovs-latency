
# Measure OVS kernel data path latency with Perf!

The two scripts help to measure the packet processing latency in OVS Kernel data path.

See the sample output below:

	CPU skb                latency(us)   ovs_port_receive     do_output         ovs_dp_upcall
	009 0xffff90dadbc78c40    4.21       5623.204036632                         5623.204040839
	018 0xffff90d9bab70700    3.02       5623.204218670                         5623.204221685
	011 0xffff90db5c2c6700    2.89       5623.204317129       5623.204320019
	009 0xffff90dadbc7bb80    3.59       5623.204333256       5623.204336847
	018 0xffff90d9bab70700    1.94       5623.204354105       5623.204356043
	018 0xffff90d9bab70700    0.82       5623.204367938       5623.204368754
	018 0xffff90d9bab70c00    2.31       5623.204375818       5623.204378130
	009 0xffff90dadbc7b040    1.88       5623.204416268       5623.204418152
	018 0xffff90d9bab71800    7.20       5623.244986113       5623.244993309
	018 0xffff90dadbc79780    5.11       5623.245029139       5623.245034249
	018 0xffff90d9bab71800    2.27       5623.245052865       5623.245055130
	018 0xffff90d9bab71800    2.00       5623.245078425       5623.245080430
	009 0xffff90dadbc799c0   10.28       5623.245238991       5623.245249275
	016 0xffff90da9a8b0a00   13.79       5623.245357760       5623.245371547
	[...]
	Best cases:
    0.48
    0.48
    0.48
    0.48
    0.48
    Worst cases:
    20.69
    18.48
    18.26
    18.05
    17.85

The first script called *perf-ovs-latency.sh* installs perf probes at OVS kernel data path entry point *ovs_port_receive*, and at the two egress points *do_output* (packet sent out) or *ovs_dp_upcall* (packet sent to userspace).

After the probes are installed in the kernel, you start *perf record* as below to store the samples:

	perf record  -e probe:ovs_vport_receive -e probe:do_output -e probe:ovs_dp_upcall
  
Then run the workload. You can stop the above command with *CTRL+C* when it captured enough samples.
The recorded data will be on a file called *perf.data* that will be used by the next script to measure latency.

	perf script -s ovs-perf-latency.py

The above script perf script will process all the samples looking for the same packet (*skb*) and calculate how long it took to get in and out of OVS kernel data path processing.



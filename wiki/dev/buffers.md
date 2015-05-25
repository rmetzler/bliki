# Observations on Buffering

None of the following is particularly novel, but the reminder has been useful:

* All buffers exist in one of two states: full (writes outpace reads), or empty
    (reads outpace writes). There are no other stable configurations.

* Throughput on an empty buffer is dominated by the write rate. Throughput on a
    full buffer is dominated by the read rate.

* A full buffer imposes a latency penalty equal to its size in bits, divided by
    the read rate in bits per second. An empty buffer imposes (approximately) no
    latency penalty.

The previous three points suggest that **traffic buffers should be measured in
seconds, not in bytes**, and managed accordingly. Less obviously, buffer
management needs to be considerably more sophisticated than the usual "grow
buffer when full, up to some predefined maximum size."

* Some buffers exist to trade latency against the overhead of coordination. A
    small buffer in this role will impose more coordination overhead; a large
    buffer will impose more latency.

    * These buffers appear where data transits between heterogenous system: for
        example, buffering reads from the network for writes to disk.

    * Mismanaged buffers in this role will tend to cause the system to spend
        an inordinate proportion of latency and throughput negotiating buffer
        sizes and message readiness.

* Some buffers exist to trade latency against jitter. A small buffer in this
    role will expose more jitter to the upstream process. A large buffer in this
    role will impose more latency.

    * These tend to appear in _homogenous_ systems with differing throughputs,
        or as a consequence of some other design choice. Store-and-forward
        switching in networks, for example, implies that switches must buffer at
        least one full frame of network data.

    * Mis-managed buffers in this role will _amplify_ rather than smoothing out
        jitter. Apparent throughput will be high until the buffer fills, then
        change abruptly when full. Upstream processes are likely to throttle
        down, causing them to under-deliver if the buffer drains, pushing the
        system back to a high-throughput mode. [This problem gets worse the
        more buffers are present in a system](http://www.bufferbloat.net).

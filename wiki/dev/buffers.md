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

Point one also implies a rule that I see honoured more in ignorance than in
awareness: **you can't make a full buffer less full by making it bigger**. Size
is not a factor in buffer fullness, only in buffer latency, so adjusting the
size in response to capacity pressure is worse than useless.

There are only three ways to make a full buffer less full:

1. Increase the rate at which data exits the buffer.

2. Slow the rate at which data enters the buffer.

3. Evict some data from the buffer.

In actual practice, most full buffers are upstream of some process that's
already going as fast as it can, either because of other design limits or
because of physics. A buffer ahead of disk writing can't drain faster than the
disk can accept data, for example. That leaves options two and three.

Slowing the rate of arrival usually implies some variety of _back-pressure_ on
the source of the data, to allow upstream processes to match rates with
downstream processes. Over-large buffers delay this process by hiding
back-pressure, and buffer growth will make this problem worse. Often,
back-pressure can happen automatically: failing to read from a socket, for
example, will cause the underlying TCP stack to apply back-pressure to the peer
writing to the socket by delaying TCP-level message acknowledgement. Too often,
I've seen code attempt to suppress these natural forms of back-pressure without
replacing them with anything, leading to systems that fail by surprise when
some other resource – usually memory – runs out.

Eviction relies on the surrounding environment, and must be part of the
protocol design. Surprisingly, most modern application protocols get very
unhappy when you throw their data away: the network age has not, sadly, brought
about protocols and formats particularly well-designed for distribution.

If neither back-pressure nor eviction are available, the remaining option is to
fail: either to start dropping data unpredictably, or to cease processing data
entirely as a result of some resource or another running out, or to induce so
much latency that the data is useless by the time it arrives.

-----

Some uncategorized thoughts:

* Some buffers exist to trade latency against the overhead of coordination. A
    small buffer in this role will impose more coordination overhead; a large
    buffer will impose more latency.

    * These buffers appear where data transits between heterogenous system: for
        example, buffering reads from the network for writes to disk.

    * Mismanaged buffers in this role will tend to cause the system to spend
        an inordinate proportion of latency and throughput negotiating buffer
        sizes and message readiness.

    * A coordination buffer is most useful when _empty_; in the ideal case, the
        buffer is large enough to absorb one message's worth of data from the
        source, then pass it along to the sink as quickly as possible.

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
    
    * An anti-jitter buffer is most useful when _full_; in exchange for a 
        latency penalty, sudden changes in throughput will be absorbed by data
        in the buffer rather than propagating through to the source or sink.

* Multimedia people understand this stuff at a deep level. Listen to them when
    designing buffers for other applications.

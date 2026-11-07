public import Kernel_Clock
public import Synchronization


extension Parsers.Debug.Profile.Stats {
    @usableFromInline
    struct State: Sendable {
        @usableFromInline var invocations: Int = 0
        @usableFromInline var successes: Int = 0
        @usableFromInline var failures: Int = 0
        @usableFromInline var totalDuration: Duration = .zero
        @usableFromInline var minDuration: Duration? = nil
        @usableFromInline var maxDuration: Duration = .zero

        @usableFromInline
        init() {}
    }
}

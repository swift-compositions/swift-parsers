public import Kernel_Clock
public import Synchronization

extension Parsers.Debug.Profile {
    public final class Stats: @unchecked Sendable {
        @usableFromInline
        let _state: Mutex<State>

        @inlinable
        public init() {
            _state = Mutex(State())
        }
    }
}

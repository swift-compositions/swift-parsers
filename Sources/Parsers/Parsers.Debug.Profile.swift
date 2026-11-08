public import Kernel_Clock
public import Synchronization

extension Parsers.Debug {
    public struct Profile<P: Parsing> {

        @usableFromInline
        let inner: P

        public let label: String

        public let stats: Stats

        @inlinable
        public init(_ inner: P, label: String) {
            self.inner = inner
            self.label = label
            self.stats = Stats()
        }
    }
}

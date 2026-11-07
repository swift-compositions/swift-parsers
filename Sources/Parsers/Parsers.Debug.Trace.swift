public import Kernel_Clock
public import Synchronization


extension Parsers.Debug {
    public struct Trace<P: Parsing>
    where P.Input: Swift.Collection {

        @usableFromInline
        let inner: P

        public let label: String

        @usableFromInline
        let output: (String) -> Void

        @inlinable
        public init(
            _ inner: P,
            label: String,
            output: @escaping (String) -> Void = { print($0) }
        ) {
            self.inner = inner
            self.label = label
            self.output = output
        }
    }
}

extension Parsers.Integer {
    public struct Binary: Sendable {

        public let requirePrefix: Bool

        @inlinable
        public init(requirePrefix: Bool = false) {
            self.requirePrefix = requirePrefix
        }
    }
}

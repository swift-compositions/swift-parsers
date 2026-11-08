extension Parsers.Integer {
    public struct Octal: Sendable {

        public let requirePrefix: Bool

        @inlinable
        public init(requirePrefix: Bool = false) {
            self.requirePrefix = requirePrefix
        }
    }
}

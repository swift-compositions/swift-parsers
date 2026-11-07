
extension Parsers.Integer {
    public struct Hexadecimal: Sendable {

        public let requirePrefix: Bool

        @inlinable
        public init(requirePrefix: Bool = false) {
            self.requirePrefix = requirePrefix
        }
    }
}

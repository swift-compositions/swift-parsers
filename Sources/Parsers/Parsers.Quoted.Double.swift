extension Parsers.Quoted {
    public struct Double: Sendable {

        public let allowNewlines: Bool

        @inlinable
        public init(allowNewlines: Bool = false) {
            self.allowNewlines = allowNewlines
        }
    }
}

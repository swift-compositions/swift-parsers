extension Parsers.Whitespace {
    public struct Skip: Sendable {

        public let kind: Kind

        @inlinable
        public init(kind: Kind = .any) {
            self.kind = kind
        }
    }
}

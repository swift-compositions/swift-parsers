
extension Parsers.Comment {
    public struct Line: Sendable {

        @usableFromInline
        let prefixBytes: [UInt8]

        @inlinable
        public init(prefix: StaticString = "//") {
            self.prefixBytes = prefix.withUTF8Buffer { unsafe [UInt8]($0) }
        }
    }
}

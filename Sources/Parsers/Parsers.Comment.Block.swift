extension Parsers.Comment {
    public struct Block: Sendable {

        @usableFromInline
        let openBytes: [UInt8]

        @usableFromInline
        let closeBytes: [UInt8]

        public let nestable: Bool

        @inlinable
        public init(
            open: StaticString = "/*",
            close: StaticString = "*/",
            nestable: Bool = false
        ) {
            self.openBytes = open.withUTF8Buffer { unsafe [UInt8]($0) }
            self.closeBytes = close.withUTF8Buffer { unsafe [UInt8]($0) }
            self.nestable = nestable
        }
    }
}

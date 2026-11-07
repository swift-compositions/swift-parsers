
extension Parsers {
    public struct Surrounded<Delimiter: Parsing, Content: Parsing>
    where Delimiter.Input == Content.Input {

        @usableFromInline
        let delimiter: Delimiter

        @usableFromInline
        let content: Content

        @inlinable
        public init(
            delimiter: Delimiter,
            content: Content
        ) {
            self.delimiter = delimiter
            self.content = content
        }
    }
}

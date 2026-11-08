public import Text

extension Parsers.Diagnostic {
    public struct Source: Sendable {

        public let content: String

        // swift-linter:disable:next raw concept
        // REASON: the label a diagnostic prints for its source and passes on as a fileID, never opened; looked at Path and Path.Component, which name a place on disk and refuse a label such as an empty name, and swift-parsers depends on neither.
        public let filename: String?

        @usableFromInline
        let lineStarts: [String.Index]

        // swift-linter:disable:next raw concept
        // REASON: the label a diagnostic prints for its source and passes on as a fileID, never opened; looked at Path and Path.Component, which name a place on disk and refuse a label such as an empty name, and swift-parsers depends on neither.
        public init(content: String, filename: String? = nil) {
            self.content = content
            self.filename = filename

            var starts: [String.Index] = [content.startIndex]
            let utf8 = content.utf8
            var pos = utf8.startIndex
            while pos < utf8.endIndex {
                if utf8[pos] == 0x0A {
                    let next = utf8.index(after: pos)
                    if next < utf8.endIndex {
                        starts.append(next)
                    }
                }
                pos = utf8.index(after: pos)
            }
            self.lineStarts = starts
        }
    }
}

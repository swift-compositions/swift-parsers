extension Parsers.Quoted {
    public enum Error: Swift.Error, Sendable, Equatable {

        case missingOpenQuote

        case unterminatedString

        case invalidEscape(sequence: String)

        case unexpectedNewline
    }
}


extension Parsers.Comment.Block {
    public enum Error: Swift.Error, Sendable, Equatable {

        case missingOpen

        case unterminatedComment
    }
}

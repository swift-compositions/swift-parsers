public import Text

extension Parsers.Diagnostic {
    public enum Style: Sendable {

        case compact

        case expanded(contextLines: Int = 2)

        case caret

        case rich
    }
}

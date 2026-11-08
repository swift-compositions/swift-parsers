extension Parsers.Integer {
    public enum Error: Swift.Error, Sendable, Equatable {

        case noDigits

        case overflow(String)

        case invalidDigit(character: UInt8, base: Int)

        case missingPrefix(expected: String)
    }
}

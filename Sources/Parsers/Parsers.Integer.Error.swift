extension Parsers.Integer {
    public enum Error: Swift.Error, Sendable, Equatable {

        case noDigits

        /// A zero precedes another digit while leading zeros are disallowed.
        case leadingZero

        case overflow(String)

        case invalidDigit(character: UInt8, base: Int)

        case missingPrefix(expected: String)
    }
}

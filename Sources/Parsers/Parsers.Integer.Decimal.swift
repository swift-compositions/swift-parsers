extension Parsers.Integer {
    public struct Decimal: Sendable {

        public let allowSign: Bool

        public let allowLeadingZeros: Bool

        @inlinable
        public init(
            allowSign: Bool = true,
            allowLeadingZeros: Bool = true
        ) {
            self.allowSign = allowSign
            self.allowLeadingZeros = allowLeadingZeros
        }
    }
}

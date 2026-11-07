
extension Parsers.Quoted {
    public struct Doubling: Sendable {

        public let quote: UInt8

        @inlinable
        public init(quote: UInt8 = .ascii.doubleQuote) {
            self.quote = quote
        }
    }
}

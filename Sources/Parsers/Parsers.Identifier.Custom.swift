extension Parsers.Identifier {
    public struct Custom: Sendable {
        @usableFromInline
        let isStart: @Sendable (UInt8) -> Bool

        @usableFromInline
        let isContinue: @Sendable (UInt8) -> Bool

        @inlinable
        public init(
            start: @escaping @Sendable (UInt8) -> Bool,
            `continue`: @escaping @Sendable (UInt8) -> Bool
        ) {
            self.isStart = start
            self.isContinue = `continue`
        }
    }
}

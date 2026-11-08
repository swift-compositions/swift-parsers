public import Checkpoint

extension Parsers.Expression {
    public struct PrefixOperator<Operand, Op: Parsing> {

        public let parser: Op

        public let apply: (Operand) -> Operand

        @inlinable
        public init(
            parser: Op,
            apply: @escaping (Operand) -> Operand
        ) {
            self.parser = parser
            self.apply = apply
        }
    }
}

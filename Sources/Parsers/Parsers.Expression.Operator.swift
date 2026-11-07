public import Checkpoint


extension Parsers.Expression {
    public struct Operator<Operand, Op: Parsing> {

        public let parser: Op

        public let precedence: Int

        public let associativity: Associativity

        public let apply: (Operand, Operand) -> Operand

        @inlinable
        public init(
            parser: Op,
            precedence: Int,
            associativity: Associativity,
            apply: @escaping (Operand, Operand) -> Operand
        ) {
            self.parser = parser
            self.precedence = precedence
            self.associativity = associativity
            self.apply = apply
        }
    }
}

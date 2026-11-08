public import Checkpoint

extension Parsers.Expression {
    public struct Climbing<Atom: Parsing, Op: Parsing>
    where
        Atom.Input == Op.Input,
        Atom.Input: Copyable & Restorable,
        Atom.Input.Checkpoint: Equatable
    {

        @usableFromInline
        let atom: Atom

        @usableFromInline
        let operators: [Operator<Operand, Op>]

        @usableFromInline
        let prefixOps: [PrefixOperator<Operand, Op>]

        @usableFromInline
        let postfixOps: [PostfixOperator<Operand, Op>]

        @inlinable
        public init(
            atom: Atom,
            operators: [Operator<Operand, Op>],
            prefix: [PrefixOperator<Operand, Op>] = [],
            postfix: [PostfixOperator<Operand, Op>] = []
        ) {
            self.atom = atom

            self.operators = operators.sorted { $0.precedence > $1.precedence }
            self.prefixOps = prefix
            self.postfixOps = postfix
        }
    }
}

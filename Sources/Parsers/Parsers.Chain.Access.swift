public import Checkpoint


extension Parsers.Chain {
    public struct Access<Operand: Parsing> {

        @usableFromInline
        let operand: Operand

        @usableFromInline
        init(operand: Operand) {
            self.operand = operand
        }

        @inlinable
        public func left<Op: Parsing>(
            _ op: Op,
            combine: @escaping (Operand.Output, Op.Output, Operand.Output) -> Operand.Output
        ) -> Parsers.Chain.Left<Operand, Op>
        where Op.Input == Operand.Input, Operand.Input: Copyable & Restorable, Operand.Input.Checkpoint: Equatable {
            Parsers.Chain.Left(operand: operand, operator: op, combine: combine)
        }

        @inlinable
        public func right<Op: Parsing>(
            _ op: Op,
            combine: @escaping (Operand.Output, Op.Output, Operand.Output) -> Operand.Output
        ) -> Parsers.Chain.Right<Operand, Op>
        where Op.Input == Operand.Input, Operand.Input: Copyable & Restorable, Operand.Input.Checkpoint: Equatable {
            Parsers.Chain.Right(operand: operand, operator: op, combine: combine)
        }
    }
}

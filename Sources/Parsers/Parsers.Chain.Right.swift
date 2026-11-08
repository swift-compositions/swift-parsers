public import Checkpoint


extension Parsers.Chain {
    public struct Right<Operand: Parsing, Operator: Parsing>
    where
        Operand.Input == Operator.Input,
        Operand.Input: Copyable & Restorable,
        Operand.Input.Checkpoint: Equatable
    {

        @usableFromInline
        let operand: Operand

        @usableFromInline
        let `operator`: Operator

        @usableFromInline
        let combine: (Operand.Output, Operator.Output, Operand.Output) -> Operand.Output

        @inlinable
        public init(
            operand: Operand,
            operator: Operator,
            combine: @escaping (Operand.Output, Operator.Output, Operand.Output) -> Operand.Output
        ) {
            self.operand = operand
            self.operator = `operator`
            self.combine = combine
        }
    }
}

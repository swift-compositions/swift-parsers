public import Checkpoint

extension Parsers {

    public enum Chain: Sendable {}
}

extension Parsers.Chain {
}

extension Parsers.Chain.Left: Parsing {

    public typealias Input = Operand.Input
    public typealias Output = Operand.Output
    public typealias Failure = Operand.Failure

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {

        var result = try operand.parse(&input)

        while true {
            let saved = input

            let op: Operator.Output
            do throws(Operator.Failure) {
                op = try `operator`.parse(&input)
            } catch {

                input = saved
                break
            }

            let rhs: Operand.Output
            do throws(Operand.Failure) {
                rhs = try operand.parse(&input)
            } catch {

                input = saved
                break
            }

            guard input.checkpoint != saved.checkpoint else {
                input = saved
                break
            }

            result = combine(result, op, rhs)
        }

        return result
    }
}

extension Parsers.Chain {
}

extension Parsers.Chain.Right: Parsing {

    public typealias Input = Operand.Input
    public typealias Output = Operand.Output
    public typealias Failure = Operand.Failure

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {

        let entry = input.checkpoint

        let lhs = try operand.parse(&input)

        let saved = input

        let op: Operator.Output
        do throws(Operator.Failure) {
            op = try `operator`.parse(&input)
        } catch {

            input = saved
            return lhs
        }

        guard input.checkpoint != entry else {
            input = saved
            return lhs
        }

        let rhs: Operand.Output
        do throws(Operand.Failure) {
            rhs = try parse(&input)
        } catch {

            input = saved
            return lhs
        }

        return combine(lhs, op, rhs)
    }
}

extension Parsers.Chain {
}

extension Parsing {

    @inlinable
    public var chain: Parsers.Chain.Access<Self> {
        Parsers.Chain.Access(operand: self)
    }
}

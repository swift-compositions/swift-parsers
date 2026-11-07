public import Checkpoint


extension Parsers.Expression {
    public enum Associativity: Sendable {

        case left

        case right

        case none
    }
}

public import Kernel_Clock
public import Synchronization

extension Parsers {

    public enum Debug: Sendable {}
}

extension Parsers.Debug {
}

extension Parsers.Debug.Trace: Parsing {

    public typealias Input = P.Input
    public typealias Output = P.Output
    public typealias Failure = P.Failure

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        let startCount = input.count
        output("[\(label)] entering at offset \(startCount)")

        do throws(P.Failure) {
            let result = try inner.parse(&input)
            let consumed = startCount - input.count
            output("[\(label)] succeeded, consumed \(consumed) bytes")
            return result
        } catch {
            let consumed = startCount - input.count
            output("[\(label)] failed after consuming \(consumed) bytes: \(error)")
            throw error
        }
    }
}

extension Parsers.Debug {
}

extension Parsers.Debug.Profile {
}

extension Parsers.Debug.Profile.Stats {
}

extension Parsers.Debug.Profile.Stats {

    public var invocations: Int { _state.withLock { $0.invocations } }

    public var successes: Int { _state.withLock { $0.successes } }

    public var failures: Int { _state.withLock { $0.failures } }

    public var totalDuration: Duration { _state.withLock { $0.totalDuration } }

    public var minDuration: Duration? { _state.withLock { $0.minDuration } }

    public var maxDuration: Duration { _state.withLock { $0.maxDuration } }

    @inlinable
    package func recordSuccess(elapsed: Duration) {
        _state.withLock { state in
            state.invocations += 1
            state.successes += 1
            state.totalDuration += elapsed
            if let min = state.minDuration {
                state.minDuration = Swift.min(min, elapsed)
            } else {
                state.minDuration = elapsed
            }
            state.maxDuration = Swift.max(state.maxDuration, elapsed)
        }
    }

    @inlinable
    package func recordFailure(elapsed: Duration) {
        _state.withLock { state in
            state.invocations += 1
            state.failures += 1
            state.totalDuration += elapsed
            if let min = state.minDuration {
                state.minDuration = Swift.min(min, elapsed)
            } else {
                state.minDuration = elapsed
            }
            state.maxDuration = Swift.max(state.maxDuration, elapsed)
        }
    }

    public var successRate: Double {
        _state.withLock { state in
            guard state.invocations > 0 else { return 0 }
            return Double(state.successes) / Double(state.invocations)
        }
    }

    public var averageDuration: Duration {
        _state.withLock { state in
            guard state.invocations > 0 else { return .zero }
            return state.totalDuration / state.invocations
        }
    }

    public func report(label: String = "Parser") -> String {

        let snapshot = _state.withLock { $0 }

        guard snapshot.invocations > 0 else {
            return "\(label): no invocations"
        }

        let successPercent = Int(Double(snapshot.successes) / Double(snapshot.invocations) * 100)
        let average = snapshot.totalDuration / snapshot.invocations
        let minStr = snapshot.minDuration?.formatted(Formatter::Formatter.Duration(numeric: Formatter::Formatter.Number())) ?? "N/A"

        return """
            \(label) Statistics:
              Invocations: \(snapshot.invocations)
              Successes:   \(snapshot.successes) (\(successPercent)%)
              Failures:    \(snapshot.failures)
              Total time:  \(snapshot.totalDuration.formatted(Formatter::Formatter.Duration(numeric: Formatter::Formatter.Number())))
              Average:     \(average.formatted(Formatter::Formatter.Duration(numeric: Formatter::Formatter.Number())))
              Min:         \(minStr)
              Max:         \(snapshot.maxDuration.formatted(Formatter::Formatter.Duration(numeric: Formatter::Formatter.Number())))
            """
    }

    public func reset() {
        _state.withLock { state in
            state = State()
        }
    }
}

extension Parsers.Debug.Profile: Parsing {

    public typealias Input = P.Input
    public typealias Output = P.Output
    public typealias Failure = P.Failure

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        let start = Clock.Continuous.now

        do throws(P.Failure) {
            let result = try inner.parse(&input)
            let elapsed = Clock.Continuous.now.offset - start.offset
            stats.recordSuccess(elapsed: elapsed)
            return result
        } catch {
            let elapsed = Clock.Continuous.now.offset - start.offset
            stats.recordFailure(elapsed: elapsed)
            throw error
        }
    }
}

extension Parsing where Input: Swift.Collection {

    @inlinable
    public func trace(
        _ label: String,
        output: @escaping (String) -> Void = { print($0) }
    ) -> Parsers.Debug.Trace<Self> {
        Parsers.Debug.Trace(self, label: label, output: output)
    }
}

extension Parsing {

    @inlinable
    public func profile(_ label: String) -> Parsers.Debug.Profile<Self> {
        Parsers.Debug.Profile(self, label: label)
    }
}

extension Parsers {

    @inlinable
    public static var debug: Debug.Type { Debug.self }
}

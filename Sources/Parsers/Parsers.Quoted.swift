extension Parsers {

    public enum Quoted: Sendable {}
}

extension Parsers.Quoted {
}

extension Parsers.Quoted {
}

extension Parsers.Quoted {
}

extension Parsers.Quoted.Double: Parsing {

    public typealias Input = Substring.UTF8View
    public typealias Output = String
    public typealias Failure = Parsers.Quoted.Error

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {

        guard input.first == .ascii.doubleQuote else {
            throw .missingOpenQuote
        }
        input.removeFirst()

        var result: [UInt8] = []

        while let byte = input.first {
            if byte == .ascii.doubleQuote {

                input.removeFirst()
                return String(decoding: result, as: UTF8.self)
            } else if byte == .ascii.backslash {

                input.removeFirst()
                guard let escaped = input.first else {
                    throw .unterminatedString
                }
                input.removeFirst()

                switch escaped {
                case .ascii.backslash: result.append(.ascii.backslash)
                case .ascii.doubleQuote: result.append(.ascii.doubleQuote)
                case .ascii.n: result.append(.ascii.lf)
                case .ascii.r: result.append(.ascii.cr)
                case .ascii.t: result.append(.ascii.tab)
                case .ascii.0: result.append(.ascii.nul)
                case .ascii.b: result.append(.ascii.bs)
                case .ascii.f: result.append(.ascii.ff)

                default:
                    throw .invalidEscape(sequence: "\\" + String(UnicodeScalar(escaped)))
                }
            } else if byte == .ascii.lf || byte == .ascii.cr {

                guard allowNewlines else {
                    throw .unexpectedNewline
                }
                result.append(byte)
                input.removeFirst()
            } else {
                result.append(byte)
                input.removeFirst()
            }
        }

        throw .unterminatedString
    }
}

extension Parsers.Quoted {
}

extension Parsers.Quoted.Single: Parsing {

    public typealias Input = Substring.UTF8View
    public typealias Output = String
    public typealias Failure = Parsers.Quoted.Error

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {

        guard input.first == .ascii.apostrophe else {
            throw .missingOpenQuote
        }
        input.removeFirst()

        var result: [UInt8] = []

        while let byte = input.first {
            if byte == .ascii.apostrophe {

                input.removeFirst()
                return String(decoding: result, as: UTF8.self)
            } else if byte == .ascii.lf || byte == .ascii.cr {

                guard allowNewlines else {
                    throw .unexpectedNewline
                }
                result.append(byte)
                input.removeFirst()
            } else {
                result.append(byte)
                input.removeFirst()
            }
        }

        throw .unterminatedString
    }
}

extension Parsers.Quoted {
}

extension Parsers.Quoted.Doubling: Parsing {

    public typealias Input = Substring.UTF8View
    public typealias Output = String
    public typealias Failure = Parsers.Quoted.Error

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {

        guard input.first == quote else {
            throw .missingOpenQuote
        }
        input.removeFirst()

        var result: [UInt8] = []

        while let byte = input.first {
            if byte == quote {
                input.removeFirst()

                guard input.first == quote else {

                    return String(decoding: result, as: UTF8.self)
                }
                result.append(quote)
                input.removeFirst()
            } else {
                result.append(byte)
                input.removeFirst()
            }
        }

        throw .unterminatedString
    }
}

extension Parsers {

    @inlinable
    public static var quoted: Quoted.Type { Quoted.self }
}

extension Parsers {

    public enum Comment: Sendable {}
}

extension Parsers.Comment {
}

extension Parsers.Comment.Line: Parsing {

    public typealias Input = Substring.UTF8View
    public typealias Output = String
    public typealias Failure = Parsers.Match.Error

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {

        var inputCopy = input
        for expected in prefixBytes {
            guard inputCopy.first == expected else {
                throw .predicateFailed(description: "line comment prefix")
            }
            inputCopy.removeFirst()
        }
        input = inputCopy

        var content: [UInt8] = []
        while let byte = input.first, byte != .ascii.lf, byte != .ascii.cr {
            content.append(byte)
            input.removeFirst()
        }

        return String(decoding: content, as: UTF8.self)
    }
}

extension Parsers.Comment {
}

extension Parsers.Comment.Block {
}

extension Parsers.Comment.Block: Parsing {

    public typealias Input = Substring.UTF8View
    public typealias Output = String
    public typealias Failure = Parsers.Comment.Block.Error

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {

        var inputCopy = input
        for expected in openBytes {
            guard inputCopy.first == expected else {
                throw .missingOpen
            }
            inputCopy.removeFirst()
        }
        input = inputCopy

        var content: [UInt8] = []
        var depth = 1

        while !input.isEmpty {

            if matches(closeBytes, in: input) {
                depth -= 1
                if depth == 0 {

                    for _ in closeBytes {
                        input.removeFirst()
                    }
                    return String(decoding: content, as: UTF8.self)
                } else {

                    for byte in closeBytes {
                        content.append(byte)
                        input.removeFirst()
                    }
                }
            }

            else if nestable && matches(openBytes, in: input) {
                depth += 1
                for byte in openBytes {
                    content.append(byte)
                    input.removeFirst()
                }
            } else {
                guard let byte = input.first else {
                    preconditionFailure("input is non-empty inside the scanning loop")
                }
                content.append(byte)
                input.removeFirst()
            }
        }

        throw .unterminatedComment
    }

    @inlinable
    package func matches(_ bytes: [UInt8], in input: Input) -> Bool {
        var check = input
        for expected in bytes {
            guard check.first == expected else { return false }
            check.removeFirst()
        }
        return true
    }
}

extension Parsers {

    @inlinable
    public static var comment: Comment.Type { Comment.self }
}

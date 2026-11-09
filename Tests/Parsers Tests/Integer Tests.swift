import Parsers_Test_Support
import Testing

enum `Integer Tests` {}

extension `Integer Tests` {
    @Suite
    struct `Integer Parsers` {

        @Test
        func `Decimal - basic parsing`() throws {
            let parser = Parsers.Integer<Int>.Decimal()
            var input = "123"[...].utf8
            let value = try parser.parse(&input)
            #expect(value == 123)
            #expect(input.isEmpty)
        }

        @Test
        func `Decimal - negative`() throws {
            let parser = Parsers.Integer<Int>.Decimal()
            var input = "-456"[...].utf8
            let value = try parser.parse(&input)
            #expect(value == -456)
        }

        @Test
        func `Decimal - positive sign`() throws {
            let parser = Parsers.Integer<Int>.Decimal()
            var input = "+789"[...].utf8
            let value = try parser.parse(&input)
            #expect(value == 789)
        }

        @Test
        func `Decimal - leading zero rejected when disallowed`() {
            let parser = Parsers.Integer<Int>.Decimal(allowLeadingZeros: false)
            var input = "007"[...].utf8
            #expect(throws: Parsers.Integer<Int>.Error.leadingZero) {
                try parser.parse(&input)
            }
        }

        @Test
        func `Decimal - lone zero accepted when leading zeros disallowed`() throws {
            let parser = Parsers.Integer<Int>.Decimal(allowLeadingZeros: false)
            var input = "0,1"[...].utf8
            let value = try parser.parse(&input)
            #expect(value == 0)
            #expect(input.first == UInt8(ascii: ","))
        }

        @Test
        func `Decimal - leading zeros accepted by default`() throws {
            let parser = Parsers.Integer<Int>.Decimal()
            var input = "007"[...].utf8
            let value = try parser.parse(&input)
            #expect(value == 7)
        }

        @Test
        func `Decimal - no sign when disabled`() throws {
            let parser = Parsers.Integer<UInt>.Decimal(allowSign: false)
            var input = "123"[...].utf8
            let value = try parser.parse(&input)
            #expect(value == 123)
        }

        @Test
        func `Hexadecimal - basic`() throws {
            let parser = Parsers.Integer<UInt32>.Hexadecimal()
            var input = "FF"[...].utf8
            let value = try parser.parse(&input)
            #expect(value == 255)
        }

        @Test
        func `Hexadecimal - with prefix`() throws {
            let parser = Parsers.Integer<UInt32>.Hexadecimal()
            var input = "0xFF"[...].utf8
            let value = try parser.parse(&input)
            #expect(value == 255)
        }

        @Test
        func `Hexadecimal - required prefix`() throws {
            let parser = Parsers.Integer<UInt32>.Hexadecimal(requirePrefix: true)
            var input = "0xABCD"[...].utf8
            let value = try parser.parse(&input)
            #expect(value == 0xABCD)
        }

        @Test
        func `Binary - basic`() throws {
            let parser = Parsers.Integer<UInt8>.Binary()
            var input = "1010"[...].utf8
            let value = try parser.parse(&input)
            #expect(value == 10)
        }

        @Test
        func `Binary - with prefix`() throws {
            let parser = Parsers.Integer<UInt8>.Binary()
            var input = "0b1111"[...].utf8
            let value = try parser.parse(&input)
            #expect(value == 15)
        }

        @Test
        func `Octal - basic`() throws {
            let parser = Parsers.Integer<Int>.Octal()
            var input = "777"[...].utf8
            let value = try parser.parse(&input)
            #expect(value == 511)
        }
    }
}

// Copyright (c) David Bagwell - https://github.com/dbagwell
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public protocol DivisibleNumeric: Numeric {
    static func / (lhs: Self, rhs: Self) -> Self
}

extension Int: DivisibleNumeric {}
extension Int8: DivisibleNumeric {}
extension Int16: DivisibleNumeric {}
extension Int32: DivisibleNumeric {}
extension Int64: DivisibleNumeric {}
extension UInt: DivisibleNumeric {}
extension UInt8: DivisibleNumeric {}
extension UInt16: DivisibleNumeric {}
extension UInt32: DivisibleNumeric {}
extension UInt64: DivisibleNumeric {}
extension Double: DivisibleNumeric {}
extension Float: DivisibleNumeric {}

// Allows devision by zero where deviding by zero results in zero
infix operator /?: MultiplicationPrecedence
public func /? <Type: DivisibleNumeric> (lhs: Type, rhs: Type) -> Type {
    guard rhs != 0 else { return 0 }
    return lhs / rhs
}

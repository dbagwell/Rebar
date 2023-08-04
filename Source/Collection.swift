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

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    public subscript(safe index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
    
    public func suffix(while predicate: (Element) throws -> Bool) rethrows -> ReversedCollection<Array<Element>.SubSequence> {
        return try self.reversed().prefix(while: predicate).reversed()
    }
    
    public func dropPrefix(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        return try self.drop(while: predicate)
    }
    
    public func dropSuffix(while predicate: (Element) throws -> Bool) rethrows -> ReversedCollection<Array<Element>.SubSequence> {
        return try self.reversed().dropPrefix(while: predicate).reversed()
    }
    
    public func mutatingEach(by transform: (inout Element) throws -> Void) rethrows -> Array<Element> {
        return try self.map({ element in
            var element = element
            try transform(&element)
            return element
        })
     }
    
    public var nilIfEmpty: Self? {
        return self.isEmpty ? nil : self
    }
    
}

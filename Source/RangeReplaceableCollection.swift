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

extension RangeReplaceableCollection {
    
    public mutating func prepend(_ element: Element) {
        self.insert(element, at: self.startIndex)
    }
    
    public func replacingFirst(where condition: (Element) throws -> Bool, with element: Element) rethrows -> Self {
        var collection = self
        
        if let index = try collection.firstIndex(where: condition) {
            collection.remove(at: index)
            collection.insert(element, at: index)
        } else {
            collection.append(element)
        }
        
        return collection
    }
    
    public mutating func replaceFirst(where condition: (Element) throws -> Bool, with element: Element) rethrows {
        self = try self.replacingFirst(where: condition, with: element)
    }
    
    public func removingFirst(where condition: (Element) throws -> Bool) rethrows -> Self {
        guard let index = try self.firstIndex(where: condition) else { return self }
        var collection = self
        collection.remove(at: index)
        return collection
    }
    
    public mutating func removeFirst(where condition: (Element) throws -> Bool) rethrows {
        self = try self.removingFirst(where: condition)
    }
    
}

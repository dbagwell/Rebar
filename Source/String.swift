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

extension String: Error { }

extension String {
    
    public var nilIfEmpty: String? {
        return self.isEmpty ? nil : self
    }
    
    public func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex, to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex, to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound, offsetBy: offset, limitedBy: endIndex) else { break }
            position = index(after: after)
        }
        
        return indices
    }
    
    public func ranges(of searchString: String) -> [Range<String.Index>] {
        let indices = self.indices(of: searchString)
        let count = searchString.utf16.count
        return indices.map({ self.index(startIndex, offsetBy: $0)..<self.index(startIndex, offsetBy: $0 + count) })
    }
    
    public func matches(pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let range = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, options: [], range: range)
        return matches.contains(where: { result in
            return result.range == range
        })
    }
    
}

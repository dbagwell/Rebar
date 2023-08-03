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

public protocol CaseMatchable {}
extension CaseMatchable {
    
    public func matches(_ pattern: Self) -> Bool {
        return "\(self)" == "\(pattern)"
    }
    
    public func matches<AssociatedValue>(_ pattern: (AssociatedValue) -> Self) -> Bool {
        if
            let associatedValue: AssociatedValue = self.associatedValue(),
            "\(self)" == "\(pattern(associatedValue))"
        {
            return true
        } else {
            return false
        }
    }
    
    private func associatedValue<AssociatedValue>() -> AssociatedValue? {
        let mirror = Mirror(reflecting: self)
        
        guard mirror.displayStyle == .enum else {
            return nil
        }
        
        guard MemoryLayout<AssociatedValue>.size > 0 else {
            return unsafeBitCast((), to: AssociatedValue.self)
        }

        if
            let firstChild = mirror.children.first?.1
        {
            if let firstChild = firstChild as? AssociatedValue {
                return firstChild
            } else if let secondChild = Mirror(reflecting: firstChild).children.first?.1 as? AssociatedValue {
                return secondChild
            }
        }
        
        return nil
    }
    
}


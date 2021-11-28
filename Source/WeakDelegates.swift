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

public class AnyWeakObject {
    
    public weak var value: AnyObject?
    
    public init(_ value: AnyObject?) {
        self.value = value
    }
    
}

public class WeakDelegates<Type> {
    
    private var weakDelegates = [AnyWeakObject]()
    
    public init() {}
    
    public func addDelegate(_ delegate: Type) {
        self.weakDelegates.append(AnyWeakObject(delegate as AnyObject))
    }
    
    public func removeDelegate(_ delegate: Type) {
        for (index, delegateInArray) in self.weakDelegates.enumerated().reversed() where delegateInArray.value === delegate as AnyObject {
            self.weakDelegates.remove(at: index)
        }
    }
    
    public func invoke(_ invocation: (Type) -> Void) {
        // Enumerating in reverse order prevents a race condition from happening when removing elements.
        for (index, delegate) in self.weakDelegates.enumerated().reversed() {
            if let delegate = delegate.value {
                if let delegateOfType = delegate as? Type {
                    invocation(delegateOfType)
                }
            } else {
                // ARC killed it, get rid of the element from our array
                self.weakDelegates.remove(at: index)
            }
        }
    }
    
}

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

import UIKit

private var deinitObserversKey: UInt8 = 0

public protocol DeinitObservable: AnyObject {
    func onDeinit(_ execute: @escaping () -> Void)
}

extension DeinitObservable {
    
    private var deinitObservers: [DeinitObserver] {
        get {
            return objc_getAssociatedObject(self, &deinitObserversKey) as? [DeinitObserver] ?? []
        }
        set {
            objc_setAssociatedObject(
                self,
                &deinitObserversKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    public func onDeinit(_ execute: @escaping () -> ()) {
        self.deinitObservers.append(DeinitObserver(deinitAction: execute))
    }
}

extension NSObject: DeinitObservable {}

fileprivate class DeinitObserver {

    private let deinitAction: () -> Void

    init(deinitAction: @escaping () -> Void) {
        self.deinitAction = deinitAction
    }

    deinit {
        self.deinitAction()
    }
}

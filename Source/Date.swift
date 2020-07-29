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

extension Date {
    
    public static func date(
        from string: String,
        withFormat format: String,
        calendar: Calendar = Calendar(identifier: .gregorian)
    ) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = calendar
        return formatter.date(from: string)
    }
    
    public func string(
        withFormat format: String,
        calendar: Calendar = Calendar(identifier: .gregorian)
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.calendar = calendar
        return formatter.string(from: self)
    }

    public var iso8601Zulu: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
    
    public var day: Day {
        return Day(date: self)
    }
    
    public func value(
        of component: Calendar.Component,
        calendar: Calendar = Calendar(identifier: .gregorian)
    ) -> Int {
        return calendar.component(component, from: self)
    }
    
    public func setting(
        _ component: Calendar.Component,
        to value: Int,
        calendar: Calendar = Calendar(identifier: .gregorian)
    ) -> Date? {
        var components = calendar.dateComponents(.all, from: self)
        components.setValue(value, for: component)
        return calendar.date(from: components)
    }
    
    public func adding(
        _ value: Int,
        to component: Calendar.Component,
        calendar: Calendar = Calendar(identifier: .gregorian)
    ) -> Date? {
        return calendar.date(byAdding: component, value: value, to: self)
    }
    
}

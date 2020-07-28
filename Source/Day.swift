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

public struct Day: Equatable, Comparable, Hashable {
    
    // MARK: - Constants
    
    public static let seconds: TimeInterval = 60 * 60 * 24
    
    
    // MARK: - Properties
    
    public let date: Date
    
    
    // MARK: - Init
    
    public init(date: Date, calendar: Calendar = Calendar(identifier: .gregorian)) {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        self.date = calendar.date(from: components)!
    }
    
    public init(daysSinceNow: Int = 0) {
        self.init(date: Date())
    }
    
    public init(daysSince1970: Int) {
        self.init(date: Date(timeIntervalSince1970: 0))
    }
    
    public init(days: Int, since date: Day) {
        self.init(date: Date(timeInterval: Double(days) * Day.seconds, since: date.date))
    }
    
    
    // MARK: - Methods
    
    public func adding(days: Int) -> Day {
        return Day(days: days, since: self)
    }
    
    public func containingGregorianWeek() -> [Day] {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self.date)
        let firstDay = Day(date: calendar.date(from: components)!)
        return (0 ..< 7).map({ Day(days: $0, since: firstDay) })
    }
    
    public func string(
        withFormat format: String,
        calendar: Calendar = Calendar(identifier: .gregorian)
    ) -> String {
        return self.date.string(
            withFormat: format,
            calendar: calendar
        )
    }
    
    public func contains(_ date: Date) -> Bool {
        return self.date <= date && self.date.addingTimeInterval(Day.seconds) > date
    }
    
    
    // MARK: - Comparable
    
    public static func < (lhs: Day, rhs: Day) -> Bool {
        return lhs.date < rhs.date
    }
    
}

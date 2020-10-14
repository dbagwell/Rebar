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

public protocol Defaults {
    
    /// If `suiteName` is `nil`, the `standard` user defaults suite is used.
    /// `suiteName` is ignored if `parentGroup` is not `nil`, and the parent group's suite is used instead.
    var suiteName: String? { get }
    
    /// `userIdentifier` is ignored if `parentGroup` is not `nil`, and the parent group's userIdentifier is used instead.
    var userIdentifier: String? { get }
    
    /// `parentGroup` is used to determine the user defaults suite and key paths to use when data is saved.
    /// Key paths are constructed in the following format `userIdentifierOfBaseGroup.TypeNameOfBaseGroup.TypeNameOfSubGroup.key`.
    var parentGroup: Defaults? { get }
    
}

extension Defaults {
    
    private var defaults: UserDefaults {
        var group: Defaults? = self
        
        while group?.parentGroup != nil {
            group = self.parentGroup
        }
        
        return UserDefaults(suiteName: group?.suiteName) ??  UserDefaults.standard
    }
    
    private func fullKey(forKey key: String) -> String {
        var strings = [key]
        var group: Defaults? = self
        
        while group != nil {
            if
                let concreteGroup = group,
                let string = String(describing: type(of: concreteGroup)).components(separatedBy: ".").last
            {
                strings.prepend(string)
            }
            
            if
                group?.parentGroup == nil,
                let userIdentifier = group?.userIdentifier
            {
                strings.prepend(userIdentifier)
            }
            
            group = group?.parentGroup
        }
        
        return strings.joined(separator: ".")
    }
    
    public func get<ValueType: Codable>(for key: String = #function) -> ValueType? {
        guard let storedValue = self.defaults.value(forKey: self.fullKey(forKey: key)) else {
            return nil
        }
        
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: storedValue, format: .binary, options: 0)
            let decoder = PropertyListDecoder()
            let value = try decoder.decode(ValueType.self, from: data)
            return value
        } catch {
            return storedValue as? ValueType
        }
    }
    
    public func set<ValueType: Codable>(_ value: ValueType? = nil, key: String = #function) {
        let key = self.fullKey(forKey: key)
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(value)
            var plistFormat =  PropertyListSerialization.PropertyListFormat.binary
            let valueToStore = try PropertyListSerialization.propertyList(from: data, format: &plistFormat)
            self.defaults.set(valueToStore, forKey: key)
        } catch {
            self.defaults.set(value, forKey: key)
        }
    }
    
}

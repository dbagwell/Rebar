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
    var suiteName: String? { get }
    var keyPrefixes: [String] { get }
}

public extension Defaults {
    
    var suiteName: String? {
        return nil
    }
    
    var keyPrefixes: [String] {
        return []
    }
    
    private var defaults: UserDefaults {
        return UserDefaults(suiteName: self.suiteName) ??  UserDefaults.standard
    }
    
    func get<ValueType: Codable>(for key: String = #function) -> ValueType? {
        let key = self.keyPrefixes.joined(separator: ".").appending(key)
        
        if self.typeIsPropertyListCompatible(ValueType.self) {
            return self.defaults.value(forKey: key) as? ValueType
        }
        
        guard let data = self.defaults.data(forKey: key) else {
            return nil
        }
        
        do {
            let decoder = PropertyListDecoder()
            let decoded = try decoder.decode(ValueType.self, from: data)
            return decoded
        } catch {
            #if DEBUG
                print(error)
            #endif
        }
        
        return nil
    }
    
    func set<ValueType: Codable>(_ value: ValueType? = nil, key: String = #function) {
        let key = self.keyPrefixes.joined(separator: ".").appending(key)
        
        if let value = value {
            if self.typeIsPropertyListCompatible(ValueType.self) {
                self.defaults.set(value, forKey: key)
                return
            }
            
            do {
                let encoder = PropertyListEncoder()
                let encoded = try encoder.encode(value)
                self.defaults.set(encoded, forKey: key)
                self.defaults.synchronize()
            } catch {
                #if DEBUG
                    print(error)
                #endif
            }
        } else {
            self.defaults.set(nil, forKey: key)
            self.defaults.synchronize()
        }
    }
    
    private func typeIsPropertyListCompatible<ValueType>(_ type: ValueType.Type) -> Bool {
        switch type {
        case is String.Type, is Bool.Type, is Int.Type, is Float.Type, is Double.Type, is Date.Type:
            return true
        default:
            return false
        }
    }
    
}

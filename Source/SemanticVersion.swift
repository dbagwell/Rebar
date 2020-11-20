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

public struct SemanticVersion: Comparable {
    
    // MARK: - Convenience
    
    public static let zero = SemanticVersion("0")!
    
    
    // MARK: - Properties
    
    private let parts: [Int]
    
    
    // MARK: - Init
    
    public init?(_ string: String) {
        guard let parts = string.components(separatedBy: ".").map(Int.init) as? [Int] else { return nil }
        self.parts = parts
    }
    
    
    // MARK: - Comparable
    
    public static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        guard lhs != rhs else { return false }
        
        for (index, lhsPart) in lhs.parts.enumerated() {
            guard let rhsPart = rhs.parts[safe: index] else {
                return false // All the lhs parts were equal to the rhs ones, but lhs has more parts meaning the lhs is greater.
            }
            
            if lhsPart == rhsPart {
                continue // this part is equal check the next one
            }
            
            return lhsPart < rhsPart
        }
        
        return true // All the lhs parts were equal to the rhs ones, but rhs has more parts, meaning that lhs is smaller.
    }

}

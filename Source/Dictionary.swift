//
//  Dictionary.swift
//  Rebar
//
//  Created by David Bagwell on 2021-11-14.
//  Copyright © 2021 David Bagwell. All rights reserved.
//

import Foundation

extension Dictionary {
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        var result = lhs
        
        for (key, value) in rhs {
            result[key] = value
        }
        
        return result
    }
    
}

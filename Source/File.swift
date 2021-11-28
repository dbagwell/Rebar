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

public struct File: Codable, Equatable {
    
    public enum MimeType: Codable, Equatable {
        case image(extension: String)
        case other(extension: String)
        
        private static let imagePrefix = "image"
        private static let otherPrefix = "application"
        
        public init(extension: String) {
            if `extension`.lowercased() == "jpg" || `extension`.lowercased() == "jpeg" || `extension`.lowercased() == "png" {
                self = .image(extension: `extension`)
            } else {
                self = .other(extension: `extension`)
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let components = try container.decode(String.self).components(separatedBy: "/")
            
            guard components.count == 2 else {
                throw DecodingError.typeMismatch(
                    MimeType.self, .init(
                        codingPath: decoder.codingPath,
                        debugDescription: "Unable to decode \(MimeType.self) - invalid number of string components.")
                )
            }
            
            switch components[0] {
            case MimeType.imagePrefix: self = .image(extension: components[1])
            case MimeType.otherPrefix: self = .other(extension: components[1])
            default:
                throw DecodingError.typeMismatch(
                    MimeType.self, .init(
                        codingPath: decoder.codingPath,
                        debugDescription: "Unable to decode \(MimeType.self) - invalid prefix.")
                )
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch self {
            case let .image(`extension`):
                try container.encode("\(MimeType.imagePrefix)/\(`extension`)")
                
            case let .other(`extension`):
                try container.encode("\(MimeType.otherPrefix)/\(`extension`)")
            }
        }
        
    }
    
    public let name: String
    public let mimeType: MimeType
    public let data: Data
    
    public init(
        name: String,
        extension: String,
        data: Data
    ) {
        self.name = "\(name).\(`extension`)"
        self.mimeType = MimeType(extension: `extension`)
        self.data = data
    }
    
}

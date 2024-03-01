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
import MobileCoreServices

public struct File: Codable, Equatable {
    
    public enum MimeType: Codable, Equatable {
        case image(type: String)
        case video(type: String)
        case other(type: String)
        
        public init(type: String) {
            if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, type as CFString, nil)?.takeRetainedValue() {
                if UTTypeConformsTo(uti, kUTTypeImage) {
                    self = .image(type: type)
                } else if UTTypeConformsTo(uti, kUTTypeMovie) {
                    self = .video(type: type)
                } else {
                    self = .other(type: type)
                }
            } else {
                self = .other(type: type)
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let type = try container.decode(String.self)
            
            if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, type as CFString, nil)?.takeRetainedValue() {
                if UTTypeConformsTo(uti, kUTTypeImage) {
                    self = .image(type: type)
                } else if UTTypeConformsTo(uti, kUTTypeMovie) {
                    self = .video(type: type)
                } else {
                    self = .other(type: type)
                }
            } else {
                self = .other(type: type)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch self {
            case let .image(type), let .video(type), let .other(type):
                try container.encode(type)
            }
        }
        
    }
    
    public let name: String
    public let mimeType: MimeType
    public let data: Data
    
    public init(
        name: String,
        extension: String,
        mimeType: MimeType,
        data: Data
    ) {
        self.name = "\(name).\(`extension`)"
        self.mimeType = mimeType
        self.data = data
    }
    
}

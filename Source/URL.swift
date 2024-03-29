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
import UniformTypeIdentifiers

extension URL {
    
    /// Returns a dictionary of the query parameters keyed using lowercased parameter names
    public var queryParams: [String: String] {
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        
        guard let items = components?.queryItems else { return [:] }
            
        return items.reduce([:], { result, item in
                var result = result
                result[item.name.lowercased()] = item.value
                return result
        })
    }
    
    public func appendingQueryParam(name: String, value: String) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return self }
        if components.queryItems == nil {
            components.queryItems = []
        }
        
        components.queryItems?.append(URLQueryItem(name: name, value: value))
        
        return components.url ?? self
    }
    
    public func appendingQueryParams(_ params: [String: String]) -> URL {
        var url = self
        
        for (name, value) in params {
            url = url.appendingQueryParam(name: name, value: value)
        }
        
        return url
    }
    
    public var mimeType: File.MimeType {
        if #available(iOS 14, *), let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
            return File.MimeType(type: mimeType)
        } else if
            let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, self.pathExtension as NSString, nil)?.takeRetainedValue(),
            let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()
        {
            return File.MimeType(type: mimetype as String)
        } else {
            return File.MimeType(type: "application/octet-stream")
        }
    }

}

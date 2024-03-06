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

public class DataFetcher<ResultType, ErrorType: Error> {
    
    private var isFetching = false
    private var completionBlocks = [(Result<ResultType, ErrorType>) -> Void]()
    
    public init() {}
    
    public func fetchData(
        using fetch: (@escaping (Result<ResultType, ErrorType>) -> Void) -> Void,
        processingResultsUsing completion: ((Result<ResultType, ErrorType>) -> Void)? = nil
    ) {
        if let completion = completion {
            self.completionBlocks.append(completion)
        }
        
        guard !self.isFetching else { return }
        self.isFetching = true
        
        fetch({ result in
            while !self.completionBlocks.isEmpty {
                self.completionBlocks.popLast()?(result)
            }
            
            self.isFetching = false
        })
    }
    
}

//
//  MockAPI2.swift
//  Testable API2Tests
//
//  Created by Ankit Saxena on 05/03/23.
//

import Foundation

class MockAPI2: URLProtocol {
    
    static var stubData: Data?
    static var stubError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let hasError = MockAPI2.stubError {
            self.client?.urlProtocol(self, didFailWithError: hasError)
        } else {
            self.client?.urlProtocol(self, didLoad: MockAPI2.stubData ?? Data())
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
    
}

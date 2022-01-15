//
//  RequestSenderMockDependencies.swift
//  ChatAppTFSTUnitTests
//
//  Created by Igor Ladanov on 13.01.2022.
//

import Foundation
@testable import ChatAppTFS

struct MockResponse {
    var foo: String?
}

class MockParserSuccess: ParserProtocol {
    var data: Data?
    var response: MockResponse?
    
    typealias Model = MockResponse
    func parse(data: Data) -> MockResponse? {
        self.data = data
        return response
    }
}

class MockRequestSuccess: RequestProtocol {
    
    var isRequestCalled = false
    var urlString: String?
    
    var urlRequest: URLRequest? {
        isRequestCalled = true
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return nil
        }
        return URLRequest(url: url)
    }
}

class MockRequestFailure: RequestProtocol {
    var isRequestCalled = false

    var urlRequest: URLRequest? {
        isRequestCalled = true
        return nil
    }
}

class MockParserFailure: ParserProtocol {
    typealias Model = MockResponse
    
    func parse(data: Data) -> MockResponse? {
        return nil
    }
}

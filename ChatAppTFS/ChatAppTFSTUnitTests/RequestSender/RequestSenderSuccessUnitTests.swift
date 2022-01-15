//
//  RequestSender.swift
//  ChatAppTFSTUnitTests
//
//  Created by Igor Ladanov on 13.01.2022.
//

import XCTest
@testable import ChatAppTFS

class RequestSenderSuccessUnitTests: XCTestCase {
    
    var requestSender: RequestSender!
    var mockRequest: MockRequestSuccess!

    override func setUpWithError() throws {
        try super.setUpWithError()
        requestSender = RequestSender()
        mockRequest = MockRequestSuccess()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        requestSender = nil
    }

    func testSuccessSendRequestWithParser() throws {
        let parser = MockParserSuccess()
        parser.data = Data()
        parser.response = MockResponse(foo: "Foo")
        mockRequest.urlString = "https://google.com"
        mockRequest.isRequestCalled = false
        let requestConfig = RequestConfig(request: mockRequest, parser: parser)
        let promise = XCTestExpectation()
        var catchResponse: MockResponse?
        
        requestSender.send(config: requestConfig) { result in
            switch result {
            case .success(let response):
                catchResponse = response
                promise.fulfill()
            case .failure: break
            }
        }
        
        wait(for: [promise], timeout: 3.0)
        XCTAssertEqual(catchResponse?.foo, "Foo")
        XCTAssertTrue(mockRequest.isRequestCalled)
    }

    func testSuccessSendRequest() throws {
        let promise = XCTestExpectation()
        mockRequest.urlString = "https://google.com"
        mockRequest.isRequestCalled = false
        
        requestSender.send(request: mockRequest) { result in
            switch result {
            case .success:
                promise.fulfill()
            case .failure: break
            }
        }
        wait(for: [promise], timeout: 1.0)
        XCTAssertTrue(mockRequest.isRequestCalled)
    }

}

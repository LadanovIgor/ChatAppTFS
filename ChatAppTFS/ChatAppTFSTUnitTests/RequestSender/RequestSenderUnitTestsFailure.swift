//
//  RequestSenderUnitTestsFailure.swift
//  ChatAppTFSTUnitTests
//
//  Created by Igor Ladanov on 14.01.2022.
//
import XCTest
@testable import ChatAppTFS

class RequestSenderFailureUnitTests: XCTestCase {
    
    var requestSender: RequestSender!
    var mockRequestFailure: MockRequestFailure!
    var mockRequestSucces: MockRequestSuccess!

    override func setUpWithError() throws {
        try super.setUpWithError()
        requestSender = RequestSender()
        mockRequestFailure = MockRequestFailure()
        mockRequestSucces = MockRequestSuccess()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        requestSender = nil
    }

    func testSuccessSendRequestWithParser() throws {
        let parser = MockParserFailure()
        
        mockRequestSucces.urlString = "https://google.com"
        mockRequestSucces.isRequestCalled = false
        let requestConfig = RequestConfig(request: mockRequestSucces, parser: parser)
        let promise = XCTestExpectation()
        var catchError: Error?
        
        requestSender.send(config: requestConfig) { result in
            switch result {
            case .success: break
            case .failure(let error):
                catchError = error
                promise.fulfill()
            }
        }
        
        wait(for: [promise], timeout: 1.0)
        XCTAssertTrue(mockRequestSucces.isRequestCalled)
        XCTAssertTrue(catchError is ParsingError)
    }

    func testFailureSendRequest() throws {
        let promise = XCTestExpectation()
        mockRequestFailure.isRequestCalled = false
        var catchError: Error?
        
        requestSender.send(request: mockRequestFailure) { result in
            switch result {
            case .success: break
            case .failure(let error):
                catchError = error
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 1.0)
        XCTAssertTrue(mockRequestFailure.isRequestCalled)
        guard let catchError = catchError as? NetworkError else {
            XCTFail("Test failure: catchError is not network error")
            return
        }
        switch catchError {
        case .badURL: break
        default: XCTFail("Test failure: error is not badUrl error")
        }
    }

}

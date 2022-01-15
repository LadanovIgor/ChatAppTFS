//
//  RouterUnitTests.swift
//  ChatAppTFSTUnitTests
//
//  Created by Igor Ladanov on 14.01.2022.
//

import XCTest
@testable import ChatAppTFS

class RouterUnitTests: XCTestCase {
    var router: Router!
    var navigationController: UINavigationController!
    var mockAssemblyBuilder: MockAssemblyBuilder!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        navigationController = UINavigationController()
        mockAssemblyBuilder = MockAssemblyBuilder()
        router = Router(navigationController: navigationController, assemblyBuilder: mockAssemblyBuilder)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        router = nil
        mockAssemblyBuilder = nil
        navigationController = nil
    }

    func testRouteToInitialScreen() throws {
        navigationController.viewControllers = []
        mockAssemblyBuilder.isConversationsListModuleCalled = false
        
        router.initialScreen()
        
        XCTAssertTrue(mockAssemblyBuilder.isConversationsListModuleCalled)
        XCTAssertFalse(navigationController.viewControllers.isEmpty)
        XCTAssertTrue(navigationController.viewControllers[0] is ConversationsListViewController)
    }

    func testRouteToConversationScreen() throws {
        mockAssemblyBuilder.isConversationModuleCalled = false
        
        router.pushConversationScreen(channelId: "Foo", userId: "Baz")
        
        XCTAssertTrue(mockAssemblyBuilder.isConversationModuleCalled)
        XCTAssertFalse(navigationController.viewControllers.isEmpty)
        XCTAssertTrue(navigationController.viewControllers[0] is ConversationViewController)
    }
    
    func testRouteToThemeScreen() throws {
        let view = MockConversationsListView()
        mockAssemblyBuilder.isThemeModuleCalled = false
        
        router.presentThemeScreen(from: view, themeSelected: nil)
        
        XCTAssertTrue(mockAssemblyBuilder.isThemeModuleCalled)
    }
    
    func testRouteToUserProfileScreen() throws {
        let view = MockConversationsListView()
        mockAssemblyBuilder.isUserProfileModuleCalled = false
        
        router.presentUserProfileScreen(from: view, with: nil)
        
        XCTAssertTrue(mockAssemblyBuilder.isUserProfileModuleCalled)
    }
    
    func testRouteToPicturesScreen() throws {
        mockAssemblyBuilder.isPicturesListModuleCalled = false
        let picturesSelected: (Data) -> Void = { _ in
            
        }
        
        router.presentPicturesScreen(for: nil, pictureSelected: picturesSelected)
        
        XCTAssertTrue(mockAssemblyBuilder.isPicturesListModuleCalled)
    }
}

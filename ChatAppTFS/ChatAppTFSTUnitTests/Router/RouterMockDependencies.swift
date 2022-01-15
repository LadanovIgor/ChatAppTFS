//
//  RouterMockDependencies.swift
//  ChatAppTFSTUnitTests
//
//  Created by Igor Ladanov on 14.01.2022.
//

@testable import ChatAppTFS

class MockConversationsListView: ConversationsListViewProtocol {
    func set(userName: String) {}
    func insert(at newIndexPath: IndexPath) {}
    func delete(at indexPath: IndexPath) {}
    func update(at indexPath: IndexPath) {}
    func move(at indexPath: IndexPath, to newIndexPath: IndexPath) { }
    func beginUpdates() {}
    func endUpdates() {}
    func reload() {}
}

class MockAssemblyBuilder: AssemblyBuilderProtocol {
    
    var isConversationsListModuleCalled = false
    var isConversationModuleCalled = false
    var isThemeModuleCalled = false
    var isUserProfileModuleCalled = false
    var isPicturesListModuleCalled = false

    func createConversationsListModule(router: RouterProtocol) -> UIViewController {
        isConversationsListModuleCalled = true
        return ConversationsListViewController()
    }
    
    func createConversationModule(channelId: String, userId: String, router: RouterProtocol) -> UIViewController {
        isConversationModuleCalled = true
        return ConversationViewController()
    }
    
    func createThemeModule(themeSelected: ThemeClosure?, router: RouterProtocol) -> UIViewController {
        isThemeModuleCalled = true
        return UIViewController()
    }
    
    func createUserProfileModule(router: RouterProtocol) -> UIViewController {
        isUserProfileModuleCalled = true
        return UIViewController()
    }
    
    func createPicturesModule(pictureSelected: @escaping (Data) -> Void, router: RouterProtocol) -> UIViewController {
        isPicturesListModuleCalled = true
        return UIViewController()

    }
    
    func createPicturesModule(pictureSelectedURL: @escaping (String) -> Void, router: RouterProtocol) -> UIViewController {
        isPicturesListModuleCalled = true
        return UIViewController()
    }
}

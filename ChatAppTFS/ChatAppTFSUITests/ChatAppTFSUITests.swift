//
//  ChatAppTFSUITests.swift
//  ChatAppTFSUITests
//
//  Created by Ladanov Igor on 08.12.2021.
//

import XCTest

class ChatAppTFSUITests: XCTestCase {
	
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		app.launch()
		app.navigationBars["Channels"].buttons["profile"].tap()
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
		app.terminate()
	}

    func testEditButton() throws {
		let editButton = app.buttons["edit"]
		XCTAssertTrue(editButton.exists)
		editButton.tap()
		XCTAssertFalse(editButton.hasFocus)
    }
	
	func testNameTextFieldExist() {
		app.buttons["edit"].tap()
		
		let nameTextField = app.textFields["name"]
		XCTAssertTrue(nameTextField.exists)
		XCTAssertTrue(nameTextField.isEnabled)
		
		app.buttons["cancel"].tap()
		XCTAssertFalse(nameTextField.isEnabled)
	}
	
	func testInfoTextFieldExist() {
		app.buttons["edit"].tap()
		
		let infoTextField = app.textFields["info"]
		XCTAssertTrue(infoTextField.exists)
		XCTAssertTrue(infoTextField.isEnabled)
		
		app.buttons["cancel"].tap()
		XCTAssertFalse(infoTextField.isEnabled)
	}
	
	func testLocationTextFieldExist() {
		app.buttons["edit"].tap()
		
		let locationTextField = app.textFields["location"]
		XCTAssertTrue(locationTextField.exists)
		XCTAssertTrue(locationTextField.isEnabled)
		
		app.buttons["cancel"].tap()
		XCTAssertFalse(locationTextField.isEnabled)
	}
}

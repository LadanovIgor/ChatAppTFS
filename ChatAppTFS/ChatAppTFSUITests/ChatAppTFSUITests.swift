//
//  ChatAppTFSUITests.swift
//  ChatAppTFSUITests
//
//  Created by Ladanov Igor on 08.12.2021.
//

import XCTest

class ChatAppTFSUITests: XCTestCase {
	
    func testEditButton() throws {
		let app = XCUIApplication()
		app.launch()
		app.navigationBars["Channels"].buttons["profile"].tap()
		let editButton = app.buttons["edit"]
		XCTAssertTrue(editButton.exists)
		editButton.tap()
		XCTAssertFalse(editButton.hasFocus)
    }
	
	func testNameTextFieldExist() {
		let app = XCUIApplication()
		app.launch()
		app.navigationBars["Channels"].buttons["profile"].tap()
		app.buttons["edit"].tap()
		let nameTextField = app.textFields["name"]
		XCTAssertTrue(nameTextField.exists)
	}
	
	func testInfoTextFieldExist() {
		let app = XCUIApplication()
		app.launch()
		app.navigationBars["Channels"].buttons["profile"].tap()
		app.buttons["edit"].tap()
		let infoTextField = app.textFields["info"]
		XCTAssertTrue(infoTextField.exists)
	}
	
	func testLocationTextFieldExist() {
		let app = XCUIApplication()
		app.launch()
		app.navigationBars["Channels"].buttons["profile"].tap()
		app.buttons["edit"].tap()
		let locationTextField = app.textFields["location"]
		XCTAssertTrue(locationTextField.exists)
	}
}

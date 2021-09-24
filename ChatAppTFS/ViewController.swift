//
//  ViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 21.09.2021.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .gray
		printFunctionName(#function)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		printFunctionName(#function)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		printFunctionName(#function)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		printFunctionName(#function)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		printFunctionName(#function)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		printFunctionName(#function)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		printFunctionName(#function)
	}
	
	private func printFunctionName(_ name: String) {
		print(name)
	}
}


//
//  ViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 24.09.2021.
//

import UIKit

class ViewController: UIViewController {
	
	

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .gray
		ApplicationAndViewControllerLifecycleObserver.shared.printFunctionName(#function)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		ApplicationAndViewControllerLifecycleObserver.shared.printFunctionName(#function)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		ApplicationAndViewControllerLifecycleObserver.shared.printFunctionName(#function)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		ApplicationAndViewControllerLifecycleObserver.shared.printFunctionName(#function)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		ApplicationAndViewControllerLifecycleObserver.shared.printFunctionName(#function)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		ApplicationAndViewControllerLifecycleObserver.shared.printFunctionName(#function)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		ApplicationAndViewControllerLifecycleObserver.shared.printFunctionName(#function)
	}
	

}


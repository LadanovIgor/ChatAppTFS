//
//  AppView.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 20.10.2021.
//

import UIKit

class AppView: UIView, TouchAnimatable {
	var emitterLayer: CAEmitterLayer = CAEmitterLayer()
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let touch = touches.first else {
			return
		}
		startTouchAnimate(with: touch.location(in: self))
		self.layer.addSublayer(emitterLayer)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		stopTouchAnimate()
	}
}

class AppCircleView: UIView {
	
}

class AppTableViewCell: UITableViewCell, TouchAnimatable {
	var emitterLayer: CAEmitterLayer { CAEmitterLayer() }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		print("touch begin")
		guard let touch = touches.first else {
			return
		}
		startTouchAnimate(with: touch.location(in: self))
		self.layer.addSublayer(emitterLayer)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		stopTouchAnimate()
	}
}

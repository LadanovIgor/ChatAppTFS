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

class AppTableView: UITableView, TouchAnimatable {
	var emitterLayer = CAEmitterLayer()
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let touch = touches.first else {
			return
		}
		clipsToBounds = false
		startTouchAnimate(with: touch.location(in: self))
		layer.addSublayer(emitterLayer)
	}
	
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		clipsToBounds = true
		stopTouchAnimate()
	}
}

class AnimatableButton: UIButton, TouchAnimatable {
	var emitterLayer = CAEmitterLayer()
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let touch = touches.first else {
			return
		}
		clipsToBounds = false
		startTouchAnimate(with: touch.location(in: self))
		layer.addSublayer(emitterLayer)
	}
	
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		clipsToBounds = true
		stopTouchAnimate()
	}
}

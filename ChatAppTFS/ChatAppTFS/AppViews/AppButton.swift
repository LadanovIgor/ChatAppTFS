//
//  ClearButton.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 20.10.2021.
//

import UIKit

class AppButton: UIButton, TouchAnimatable {
	var emitterLayer = CAEmitterLayer()
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let touch = touches.first else { return }
		self.clipsToBounds = false
		startTouchAnimate(with: touch.location(in: self))
		self.layer.addSublayer(emitterLayer)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		guard let touch = touches.first else { return }
		moveTouchAnimate(with: touch.location(in: self))
	}
	
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		self.clipsToBounds = true
		stopTouchAnimate()
	}
}

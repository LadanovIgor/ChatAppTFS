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
		guard let touch = touches.first else {
			return
		}
		startTouchAnimate(with: touch.location(in: self))
		self.layer.addSublayer(emitterLayer)
	}
	
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		stopTouchAnimate()
	}
}

protocol TouchAnimatable where Self: UIView {
	func startTouchAnimate(with position: CGPoint)
	func stopTouchAnimate()
	var emitterLayer: CAEmitterLayer { get }
}

extension TouchAnimatable {

	func startTouchAnimate(with position: CGPoint) {
		let cell = CAEmitterCell()
		cell.contents = UIImage(named: "tinkoff")?.resize(width: 40, height: 40)?.cgImage
		cell.birthRate = 6
		cell.lifetime = 0.5
		cell.velocity = 50
		cell.scale = 0.3
		cell.emissionRange = CGFloat.pi * 2.0
		cell.spin = 0.5
		emitterLayer.emitterCells = [cell]
		emitterLayer.emitterPosition = position
	}
	
	func stopTouchAnimate() {
		emitterLayer.emitterCells = []
		emitterLayer.removeAllAnimations()
	}
}

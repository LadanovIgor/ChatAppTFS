//
//  TouchAnimatable.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 01.12.2021.
//

import Foundation

protocol TouchAnimatable: AnyObject {
	func startTouchAnimate(with position: CGPoint)
	func stopTouchAnimate()
	func moveTouchAnimate(with position: CGPoint)
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
	
	func moveTouchAnimate(with position: CGPoint) {
		emitterLayer.emitterPosition = position
	}
	
	func stopTouchAnimate() {
		emitterLayer.emitterCells = []
		emitterLayer.removeAllAnimations()
	}
}

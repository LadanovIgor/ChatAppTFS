//
//  MessageView.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 25.10.2021.
//

import UIKit

class TouchAnimateTableView: UITableView, TouchAnimatable {
	var emitterLayer = CAEmitterLayer()
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let touch = touches.first else { return }
		clipsToBounds = false
		startTouchAnimate(with: touch.location(in: self))
		layer.addSublayer(emitterLayer)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		guard let touch = touches.first else { return }
		isScrollEnabled = false
		moveTouchAnimate(with: touch.location(in: self))
	}
	
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		isScrollEnabled = true
		clipsToBounds = true
		stopTouchAnimate()
	}
}

class TouchAnimateCollectionView: UICollectionView, TouchAnimatable {
	var emitterLayer = CAEmitterLayer()
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let touch = touches.first else { return }
		clipsToBounds = false
		startTouchAnimate(with: touch.location(in: self))
		layer.addSublayer(emitterLayer)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		guard let touch = touches.first else { return }
		isScrollEnabled = false
		moveTouchAnimate(with: touch.location(in: self))
	}
	
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		clipsToBounds = true
		isScrollEnabled = true
		stopTouchAnimate()
	}
}

class TouchAnimateButton: UIButton, TouchAnimatable {
	var emitterLayer = CAEmitterLayer()
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let touch = touches.first else { return }
		clipsToBounds = false
		startTouchAnimate(with: touch.location(in: self))
		layer.addSublayer(emitterLayer)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		guard let touch = touches.first else { return }
		moveTouchAnimate(with: touch.location(in: self))
	}
	
	open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		clipsToBounds = true
		stopTouchAnimate()
	}
}

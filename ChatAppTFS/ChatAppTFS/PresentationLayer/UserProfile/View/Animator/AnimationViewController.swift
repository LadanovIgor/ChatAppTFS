//
//  AnimationViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 29.11.2021.
//

import UIKit

class AnimationController: NSObject {
	
	private var animationDuration: Double = 0
	private var animationType: AnimationType = .present
	
	var circle = AppCircleView()
	
	var startingPoint: CGPoint = .zero {
		didSet {
			circle.center = startingPoint
		}
	}
	
	enum AnimationType {
		case present, dismiss
	}
	
	func set(animationDuration: Double, animationType: AnimationType, startingPoint: CGPoint) {
		self.animationDuration = animationDuration
		self.animationType = animationType
		self.startingPoint = startingPoint
	}
	
	private func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
		let viewCenter = viewToAnimate.center
		let viewSize = viewToAnimate.frame.size
		circle.frame = frameForCircle(with: viewCenter, size: viewSize, startingPoint: startingPoint)
		circle.round()
		circle.center = startingPoint
		circle.transform = CGAffineTransform(scaleX: 0, y: 0)
		circle.layer.borderWidth = 5.0
		circle.layer.borderColor = UIColor.black.cgColor
		transitionContext.containerView.addSubview(circle)
		transitionContext.containerView.addSubview(viewToAnimate)
		viewToAnimate.center = startingPoint
		viewToAnimate.transform = CGAffineTransform(scaleX: 0, y: 0)
		
		let duration = transitionDuration(using: transitionContext)
		
		UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
			self.circle.transform = CGAffineTransform.identity
			viewToAnimate.transform = CGAffineTransform.identity
			viewToAnimate.center = viewCenter
		} completion: { success in
			transitionContext.completeTransition(success)
		}
	}
	
	private func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
		let viewCenter = viewToAnimate.center
		let viewSize = viewToAnimate.frame.size
		circle.frame = frameForCircle(with: viewCenter, size: viewSize, startingPoint: startingPoint)
		circle.round()
		circle.center = startingPoint
		transitionContext.containerView.addSubview(viewToAnimate)

		let duration = transitionDuration(using: transitionContext)
		
		UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
			self.circle.transform = CGAffineTransform(scaleX: 0, y: 0)
			viewToAnimate.transform = CGAffineTransform(scaleX: 0, y: 0)
			viewToAnimate.center = self.startingPoint
		} completion: { success in
			viewToAnimate.center = viewCenter
			viewToAnimate.removeFromSuperview()
			self.circle.removeFromSuperview()
			transitionContext.completeTransition(success)
		}
	}
	
	private func frameForCircle(with viewCenter: CGPoint, size: CGSize, startingPoint: CGPoint) -> CGRect {
		let xLength = max(startingPoint.x, size.width - startingPoint.x)
		let yLength = max(startingPoint.y, size.height - startingPoint.y)
		let offset = sqrt(xLength * xLength + yLength * yLength) * 2
		let size = CGSize(width: offset, height: offset)
		return CGRect(origin: .zero, size: size)
	}
	
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return TimeInterval(exactly: animationDuration) ?? 0
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let fromViewController = transitionContext.viewController(forKey: .from),
			  let toViewController = transitionContext.viewController(forKey: .to) else {
				  transitionContext.completeTransition(false)
				  return
			  }
		
		switch animationType {
		case .present:
			transitionContext.containerView.addSubview(toViewController.view)
				toViewController.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
				toViewController.view.frame = UIScreen.main.bounds
			presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
		case .dismiss:
				transitionContext.containerView.addSubview(toViewController.view)
				transitionContext.containerView.addSubview(fromViewController.view)
				dismissAnimation(with: transitionContext, viewToAnimate: toViewController.view)
				
		}
	}
}

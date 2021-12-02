//
//  AnimationViewController.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 29.11.2021.
//

import UIKit

class AnimationController: NSObject {
	
	// MARK: - Properties

	enum AnimationType {
		case present, dismiss
	}
	
	private var duration: TimeInterval
	private var animationType: AnimationType = .present
	private var circle = AppCircleView()
	
	private var startingPoint: CGPoint {
		didSet { circle.center = startingPoint }
	}
	
	// MARK: - Init
	
	init(duration: TimeInterval, startingPoint: CGPoint) {
		self.duration = duration
		self.startingPoint = startingPoint
	}
	
	func set(animationType: AnimationType) {
		self.animationType = animationType
	}
	
	// MARK: - Private
	
	private func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, view: UIView) {
		circle = AppCircleView()
		let viewCenter = view.center
		let viewSize = view.frame.size
		
		circle.frame = frameForCircle(with: viewCenter, size: viewSize, startingPoint: startingPoint)
		circle.round()
		circle.center = startingPoint
		circle.transform = CGAffineTransform(scaleX: 0, y: 0)
		circle.layer.borderWidth = 1.0
		circle.layer.borderColor = UIColor.black.cgColor
		
		transitionContext.containerView.addSubview(circle)
		transitionContext.containerView.addSubview(view)
		view.center = startingPoint
		view.transform = CGAffineTransform(scaleX: 0, y: 0)
		
		let duration = transitionDuration(using: transitionContext)
		
		UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
			self.circle.transform = CGAffineTransform.identity
			view.transform = CGAffineTransform.identity
			view.center = viewCenter
		} completion: { success in
			transitionContext.completeTransition(success)
		}
	}
		
	private func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning, view: UIView) {
		let viewCenter = view.center
		let viewSize = view.frame.size
		
		circle.frame = frameForCircle(with: viewCenter, size: viewSize, startingPoint: startingPoint)
		circle.round()
		circle.center = startingPoint
		
		transitionContext.containerView.addSubview(view)

		let duration = transitionDuration(using: transitionContext)
		
		UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
			self.circle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
			view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
			view.center = self.startingPoint
		} completion: { success in
			view.center = viewCenter
			view.removeFromSuperview()
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

	// MARK: - UIViewControllerAnimatedTransitioning

extension AnimationController: UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
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
			presentAnimation(with: transitionContext, view: toViewController.view)
		case .dismiss:
			transitionContext.containerView.addSubview(fromViewController.view)
			dismissAnimation(with: transitionContext, view: fromViewController.view)
		}
	}
}

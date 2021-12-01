//
//  UIImage+.swift
//  ChatAppTFS
//
//  Created by Ladanov Igor on 28.10.2021.
//

import UIKit

extension UIImage {
	func resize(width: CGFloat, height: CGFloat) -> UIImage? {
		let widthRatio  = width / size.width
		let heightRatio = height / size.height
		let ratio = widthRatio > heightRatio ? heightRatio : widthRatio
		let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		self.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
}

extension UIImage {
	static func textImage(text: String?) -> UIImage? {
		let size = CGSize(width: 100, height: 100)
		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
		let context = UIGraphicsGetCurrentContext()
		let color = Constants.ImageBackgroundColor.getColor(from: text?.first)
		context?.setFillColor(color.cgColor)
		context?.fillEllipse(in: CGRect(x: 1, y: 1, width: size.width - 2, height: size.height - 2))
		let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
						  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 41.0, weight: .medium)]
		if let text = text {
			let textSize = text.size(withAttributes: attributes)
			let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
			let rect = CGRect(x: bounds.size.width / 2 - textSize.width / 2,
							  y: bounds.size.height / 2 - textSize.height / 2,
							  width: textSize.width,
							  height: textSize.height)
			text.draw(in: rect, withAttributes: attributes)
		}
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}

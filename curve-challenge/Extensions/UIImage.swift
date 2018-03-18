//
//  UIImage.swift
//  curve-challenge
//
//  Created by Saul Liang on 17/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit

extension UIImage {
	
	func imageWithColor(_ tintColor: UIColor) -> UIImage? {

		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		guard let mask = self.cgImage else { return nil }

		context.translateBy(x: 0, y: self.size.height)
		context.scaleBy(x: 1.0, y: -1.0);
		context.setBlendMode(.normal)

		let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
		context.clip(to: rect, mask: mask)
		tintColor.setFill()
		context.fill(rect)

		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return newImage
	}
}

extension UIImage {
	
	fileprivate static func iconImage(_ name: String, _ color: UIColor) -> UIImage? {
		return UIImage(named: name)?.imageWithColor(color)?.withRenderingMode(.alwaysOriginal)
	}
	
	static let favouriteIcon = UIImage(named: "ic_favorite")?.withRenderingMode(.alwaysTemplate)
	static let favouriteBorderIcon = UIImage(named: "ic_favorite_border")?.withRenderingMode(.alwaysTemplate)
	
	static func favouriteBorderIcon(_ color: UIColor) -> UIImage? {
		return self.iconImage("ic_favorite_border", color)
	}
	static func favouriteIcon(_ color: UIColor) -> UIImage? {
		return self.iconImage("ic_favorite", color)
	}
}

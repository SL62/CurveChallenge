//
//  UIColor.swift
//  curve-challenge
//
//  Created by Saul Liang on 17/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit

extension UIColor {
	
	static let pink = rgb(255, 64, 129)
	static let purple50 = rgb(237, 231, 246)
	static let purple500 = rgb(103, 58, 183)
	
	fileprivate static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
		return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
	}
	
	fileprivate static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
		return self.rgba(r, g, b, 1.0)
	}
	
	static func voteAverageColor(forRating rating: Double) -> UIColor {
		if rating >= 7 {
			return rgb(76, 175, 80)
		} else if rating >= 4 {
			return rgb(255, 152, 0)
		} else {
			return rgb(255, 0, 0)
		}
	}
}

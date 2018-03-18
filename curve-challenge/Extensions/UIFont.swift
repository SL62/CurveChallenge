//
//  UIFont.swift
//  curve-challenge
//
//  Created by Saul Liang on 17/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit

extension UIFont {
	
	static func thin(_ size: CGFloat) -> UIFont {
		return systemFont(ofSize: size, weight: UIFont.Weight.thin)
	}
	static func regular(_ size: CGFloat) -> UIFont {
		return systemFont(ofSize: size, weight: UIFont.Weight.regular)
	}
	static func medium(_ size: CGFloat) -> UIFont {
		return systemFont(ofSize: size, weight: UIFont.Weight.medium)
	}
	static func semibold(_ size: CGFloat) -> UIFont {
		return systemFont(ofSize: size, weight: UIFont.Weight.semibold)
	}
	static func bold(_ size: CGFloat) -> UIFont {
		return systemFont(ofSize: size, weight: UIFont.Weight.bold)
	}
}

//
//  UIStoryboard.swift
//  curve-challenge
//
//  Created by Saul Liang on 17/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit

fileprivate extension UIStoryboard {
	
	static func load(from storyboard: String, identifier: String) -> UIViewController {
		let uiStoryboard = UIStoryboard(name: storyboard, bundle: nil)
		return uiStoryboard.instantiateViewController(withIdentifier: identifier)
	}
}

extension UIStoryboard {
	
	static func loadMovieDetailsVC() -> MovieDetailsVC {
		return self.load(from: "Main", identifier: "MovieDetailsVC") as! MovieDetailsVC
	}
}

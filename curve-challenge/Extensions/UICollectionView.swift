//
//  UICollectionView.swift
//  curve-challenge
//
//  Created by Saul Liang on 17/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit
import Lottie

extension UICollectionView {
	
	func loadingMoviesBackground() -> UIView {
		
		let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
		let animationView = LOTAnimationView(name: "simple_loader_purple")
		animationView.center = CGPoint(x: backgroundView.bounds.size.width/2, y: backgroundView.bounds.size.height/2)
		animationView.loopAnimation = true
		animationView.play()
		backgroundView.addSubview(animationView)
		return backgroundView
	}
}

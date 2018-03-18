//
//  UICollectionViewCell.swift
//  curve-challenge
//
//  Created by Saul Liang on 17/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
	
	func defaultSelectedBackgroundView() -> UIView {
		
		let cellView = UIView()
		cellView.backgroundColor = .purple50
		return cellView
	}
}

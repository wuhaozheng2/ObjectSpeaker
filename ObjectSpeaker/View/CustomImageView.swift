//
//  CustomImageView.swift
//  拍照识物
//
//  Created by wuhaozheng on 2018/9/27.
//  Copyright © 2018 vmengblog. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

    override func awakeFromNib() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 10
    }
}

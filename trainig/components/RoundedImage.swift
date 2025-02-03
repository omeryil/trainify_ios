//
//  CustomSegmented.swift
//  trainig
//
//  Created by omer yildirim on 27.01.2025.
//

import Foundation
import UIKit
class RoundedImage: UIImageView {
   
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = false
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true
    }
    
}

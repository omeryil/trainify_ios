//
//  CustomSegmented.swift
//  trainig
//
//  Created by omer yildirim on 27.01.2025.
//

import Foundation
import UIKit
class BorderedViewNoBack8White: UIView {
   
    override func layoutSubviews() {
        super.layoutSubviews()
        let height:CGFloat=self.frame.height;
        layer.cornerRadius = height/8
        clipsToBounds=true
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.5
    }
    
}

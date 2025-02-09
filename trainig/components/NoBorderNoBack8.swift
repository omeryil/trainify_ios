//
//  CustomSegmented.swift
//  trainig
//
//  Created by omer yildirim on 27.01.2025.
//

import Foundation
import UIKit
class NoBorderNoBack8: UIView {
   
    override func layoutSubviews() {
        super.layoutSubviews()
        let height:CGFloat=self.frame.height;
        layer.cornerRadius = height/8
        clipsToBounds=true
    }
    
}

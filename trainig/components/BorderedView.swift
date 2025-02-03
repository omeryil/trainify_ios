//
//  CustomSegmented.swift
//  trainig
//
//  Created by omer yildirim on 27.01.2025.
//

import Foundation
import UIKit
class BorderedView: UIView {
   
    override func layoutSubviews() {
        super.layoutSubviews()
        let height:CGFloat=self.frame.height;
        layer.cornerRadius = height/2
        clipsToBounds=true
        self.backgroundColor=UIColor(named: "DarkBack")
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
    }
    
}

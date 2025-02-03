//
//  CustomSegmented.swift
//  trainig
//
//  Created by omer yildirim on 27.01.2025.
//

import Foundation
import UIKit
class BorderedViewNoBack: UIView {
   
    override func layoutSubviews() {
        super.layoutSubviews()
        let height:CGFloat=self.frame.height;
        layer.cornerRadius = height/4
        clipsToBounds=true
        self.backgroundColor=UIColor.clear
        layer.borderColor = UIColor(named: "Seperator")?.cgColor
        layer.borderWidth = 0.5
    }
    
}

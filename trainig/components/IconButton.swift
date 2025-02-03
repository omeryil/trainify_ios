//
//  CustomButton.swift
//  trainig
//
//  Created by omer yildirim on 27.01.2025.
//

import Foundation
import UIKit
class IconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let height:CGFloat=self.frame.height;
        layer.cornerRadius = height/2
        layer.borderWidth=1
        layer.borderColor=UIColor(named: "MainColor")?.cgColor
        clipsToBounds=true
        backgroundColor=UIColor.clear
    }
    
}

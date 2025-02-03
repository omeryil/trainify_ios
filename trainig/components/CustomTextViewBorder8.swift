//
//  CustomSegmented.swift
//  trainig
//
//  Created by omer yildirim on 27.01.2025.
//

import Foundation
import UIKit
class CustomTextViewBorder8: UITextView {
   
    override func layoutSubviews() {
        super.layoutSubviews()
        let height:CGFloat=self.frame.height;
        layer.cornerRadius = height/8
        clipsToBounds=true
        self.backgroundColor=UIColor.black
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
    }
    struct Constants {
            static let sidePadding: CGFloat = 15
            static let topPadding: CGFloat = 8
    }


    
}

//
//  CustomButton.swift
//  trainig
//
//  Created by omer yildirim on 27.01.2025.
//

import Foundation
import UIKit
class CustomButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let height:CGFloat=self.frame.height;
        layer.cornerRadius = height/2
        clipsToBounds=true
        self.titleLabel?.font=UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? UIColor.red : UIColor.white
        }
     }

    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? UIColor.red : UIColor.white
        }
     }
    
}

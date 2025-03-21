//
//  CustomSegmented.swift
//  trainig
//
//  Created by omer yildirim on 27.01.2025.
//

import Foundation
import UIKit
class CustomTextFieldBorder8: UITextField {
    var applyDoneButton: Bool = true
    override func layoutSubviews() {
        super.layoutSubviews()
        let height:CGFloat=self.frame.height;
        layer.cornerRadius = height/8
        clipsToBounds=true
        self.placeHolderColor=UIColor.lightGray
        self.backgroundColor=UIColor.black
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        if applyDoneButton{
            self.addDoneButtonOnKeyboard()
        }
    }
    struct Constants {
            static let sidePadding: CGFloat = 15
            static let topPadding: CGFloat = 8
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + Constants.sidePadding,
            y: bounds.origin.y + Constants.topPadding,
            width: bounds.size.width - Constants.sidePadding * 2,
            height: bounds.size.height - Constants.topPadding * 2
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}

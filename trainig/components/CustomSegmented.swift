//
//  CustomSegmented.swift
//  trainig
//
//  Created by omer yildirim on 27.01.2025.
//

import Foundation
import UIKit
class CustomSegmented: UISegmentedControl {
    
    private var cornerRadius: CGFloat
            init(cornerRadius: CGFloat) {
                self.cornerRadius = cornerRadius
                super.init(frame: .zero)
            }

            required init?(coder: NSCoder) {
                self.cornerRadius = 20
                super.init(coder: coder)
            }

            override func layoutSubviews() {
                super.layoutSubviews()
                layer.cornerRadius = cornerRadius
                
                guard let selectedSegment = subviews[numberOfSegments] as? UIImageView else {
                    return
                }
                
                selectedSegment.image = nil
                selectedSegment.backgroundColor = selectedSegmentTintColor
                selectedSegment.layer.removeAnimation(forKey: "SelectionBounds")
                selectedSegment.layer.cornerRadius = cornerRadius - layer.borderWidth
                selectedSegment.bounds = CGRect(origin: .zero, size: CGSize(
                    width: selectedSegment.bounds.width,
                    height: bounds.height - layer.borderWidth * 2
                ))
            }
}

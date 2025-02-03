//
//  SemiCircle.swift
//  trainig
//
//  Created by omer yildirim on 28.01.2025.
//

import UIKit

class SemiCirleView: UIView {
    
    var semiCirleLayer: CAShapeLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bezierPath = UIBezierPath()
        bezierPath.move(to: .zero)
        bezierPath.addCurve(
                to: CGPoint(x: bounds.size.width , y: 0),
                controlPoint1: CGPoint(x: 0, y: 40),
                controlPoint2: CGPoint(x: bounds.size.width , y: 40))
        semiCirleLayer.path = bezierPath.cgPath
        semiCirleLayer.fillColor = UIColor.init(named: "DarkBack")?.cgColor
    
        self.layer.addSublayer(semiCirleLayer)
    }
}

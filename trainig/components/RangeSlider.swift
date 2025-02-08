//
//  RangeSlider.swift
//  trainig
//
//  Created by omer yildirim on 8.02.2025.
//

import UIKit
import MultiSlider

class RangeSlider: UIView {
    let horizontalMultiSlider = MultiSlider()
    public var delegate:sliderChangedDelegate?
    override func layoutSubviews() {
       
        horizontalMultiSlider.orientation = .horizontal
               //horizontalMultiSlider.minimumValue = 10 / 4
               //horizontalMultiSlider.maximumValue = 10 / 3
        horizontalMultiSlider.outerTrackColor = UIColor(named: "DarkCellBack")
        //horizontalMultiSlider.value = [2.718, 3.14]
        horizontalMultiSlider.valueLabelPosition = .top
        horizontalMultiSlider.tintColor = UIColor(named: "MainColor")
        horizontalMultiSlider.trackWidth = 32
        horizontalMultiSlider.showsThumbImageShadow = false
        horizontalMultiSlider.keepsDistanceBetweenThumbs = false
        horizontalMultiSlider.snapStepSize = 1
        //horizontalMultiSlider.valueLabelFormatter.positiveSuffix = " 𝞵s"
        horizontalMultiSlider.valueLabelColor = UIColor.white
        horizontalMultiSlider.valueLabelFont = UIFont.italicSystemFont(ofSize: 16)
        self.addConstrainedSubview(horizontalMultiSlider, constrain: .leftMargin, .rightMargin, .bottomMargin)
        self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        horizontalMultiSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
    }
    @objc func sliderChanged(_ slider: MultiSlider) {
            print("thumb \(slider.draggedThumbIndex) moved")
            print("now thumbs are at \(slider.value)")
        delegate?.sliderChanged(slider:self,values: slider.value)// e.g., [1.0, 4.5, 5.0]
    }
    @IBInspectable var positiveSuffix: String? {
        didSet {
            horizontalMultiSlider.valueLabelFormatter.positiveSuffix=positiveSuffix
        }
    }
    @IBInspectable var value: [CGFloat]? {
        didSet {
            updateValue()
        }
    }
    @IBInspectable var minValue: CGFloat = 0.0 {
        didSet {
            updateMinValue()
        }
    }
    @IBInspectable var maxValue: CGFloat = 0.0 {
        didSet {
            updateMaxValue()
        }
    }
    func updateValue() {
        horizontalMultiSlider.value=value!
    }
    func updateMinValue() {
        horizontalMultiSlider.minimumValue=minValue
    }
    func updateMaxValue() {
        horizontalMultiSlider.maximumValue=maxValue
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//
//  protocols.swift
//  trainig
//
//  Created by omer yildirim on 5.02.2025.
//

import CoreFoundation

protocol sign_in_up_delegate
{
    func sign_in()
    func sign_up()
}
protocol filterDelegate{
    func returnFilter(filter:FilterItem)
}
protocol sliderChangedDelegate{
    func sliderChanged(slider:RangeSlider,values:[CGFloat])
}

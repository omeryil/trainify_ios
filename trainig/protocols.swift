//
//  protocols.swift
//  trainig
//
//  Created by omer yildirim on 5.02.2025.
//

import CoreFoundation
import UIKit

protocol sign_in_up_delegate
{
    func sign_in()
    func sign_up()
}
protocol filterDelegate{
    func returnFilter(filter:FilterItem,isApply:Bool)
}
protocol sliderChangedDelegate{
    func sliderChanged(slider:RangeSlider,values:[CGFloat])
}
protocol indicatorDelegate
{
    func showIndicator()
    func hideIndicator()
}
protocol StepperDelegate{
    func personalInfo(data:Any)
    func interests(data:Any)
    func provideo(data:Any)
    func about(data:Any)
    func certificate(data:Any)
}
protocol PassDataDelegate
{
    func passData(data:Any)
}
protocol CallMainDelegate {
    func callMain(viewController:UIViewController)
}

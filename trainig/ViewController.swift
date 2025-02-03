//
//  ViewController.swift
//  trainig
//
//  Created by omer yildirim on 17.01.2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var sView: UIView!
    @IBOutlet weak var vc: UIView!
    @IBOutlet weak var segment: CustomSegmented!
    var views: [UIView] = [SignInView().view,SignUpView().view]
    var position: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        for v in views{
            vc.addSubview(v)
        }
        vc.bringSubviewToFront(views[0])
        views[1].alpha = 0
        
        self.segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        self.segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        self.segment.setTitle(String(localized: "sign_in"), forSegmentAt: 0)
        self.segment.setTitle(String(localized: "sign_up"), forSegmentAt: 1)
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        vc.addGestureRecognizer(leftSwipe)
        vc.addGestureRecognizer(rightSwipe)
        let font = UIFont.systemFont(ofSize: 16, weight: .bold)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer)
    {
        if sender.direction == .left
        {
           
            if position < views.count-1{
                position = position + 1
                segment.selectedSegmentIndex = position
                bringToFront(index: position)
                
            }
        }

        if sender.direction == .right
        {
            if position > 0{
                position = position - 1
                segment.selectedSegmentIndex = position
                bringToFront(index: position)
            }
            
        }
    }
    @IBAction func segment_changed(_ sender: Any) {
        bringToFront(index: segment.selectedSegmentIndex)
    }
    func bringToFront(index:Int){
        for v in views{
            v.alpha = 0
        }
        views[index].alpha = 1
        vc.bringSubviewToFront(views[index])
    }
    

}


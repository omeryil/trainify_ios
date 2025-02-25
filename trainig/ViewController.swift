//
//  ViewController.swift
//  trainig
//
//  Created by omer yildirim on 17.01.2025.
//

import UIKit

class ViewController: UIViewController,sign_in_up_delegate,indicatorDelegate {
    func showIndicator() {
        let ind = self.view.showLoader(nil) as? Indicator
        ind!.lbl.text=String(localized:"wait")
    }
    
    func hideIndicator() {
        self.view.dismissLoader()
    }
    
    func sign_up() {
        let n = storyboard?.instantiateViewController(withIdentifier: "vpager") as! ViewPager
        self.navigationController!.pushViewController(n, animated: true)
    }
    
    func sign_in() {
        let userData=CacheData.getUserData()!
        var n:UIViewController!
        let role=userData["role"] as! String
        if role=="user"{
            n = storyboard?.instantiateViewController(withIdentifier: "upage") as! UserTabViewController
        }else{
            n = storyboard?.instantiateViewController(withIdentifier: "tpage") as! TrainerTabViewController
        }
        //let n = storyboard?.instantiateViewController(withIdentifier: "upage") as! UserTabViewController
        self.navigationController!.pushViewController(n, animated: true)
    }
    

    @IBOutlet var sView: UIView!
    @IBOutlet weak var vc: UIView!
    @IBOutlet weak var segment: CustomSegmented!
    var views: [UIViewController] = [SignInView(),SignUpView()]
    var position: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        for v in views{
            if v is SignInView{
                (v as! SignInView).delegate = self
                (v as! SignInView).indicatorDelegate = self
            }
            if v is SignUpView{
                (v as! SignUpView).delegate = self
                (v as! SignUpView).indicatorDelegate = self
            }
            vc.addSubview(v.view)
        }
        vc.bringSubviewToFront(views[0].view)
        views[1].view.alpha = 0
        
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
            v.view.alpha = 0
        }
        views[index].view.alpha = 1
        vc.bringSubviewToFront(views[index].view)
    }
    

}


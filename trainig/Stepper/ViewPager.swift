//
//  ViewPager.swift
//  trainig
//
//  Created by omer yildirim on 28.01.2025.
//

import UIKit

class ViewPager: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var views: [UIViewController] = []
    var position:Int=0
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate=self
        scrollView.isPagingEnabled = true
        self.scrollView.frame.size.width = self.view.frame.width
        scrollView.clipsToBounds = true
        
        self.view.bringSubviewToFront(pageControl)
        //scrollView.addSubview(PersonalInfo().view)
        // Do any additional setup after loading the view.
        setViewControllers()
       
        for i in 0 ..< views.count {
            let v=views[i]
            self.addChild(v)
            self.scrollView.addSubview(v.view)
            v.willMove(toParent: self)
            v.view.frame = CGRect(x: self.view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: scrollView.frame.height)
        
        }
        pageControl.numberOfPages=views.count
        pageControl.currentPage=0
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        scrollView.addGestureRecognizer(leftSwipe)
        scrollView.addGestureRecognizer(rightSwipe)
        
    }
    func setViewControllers(){
        let pi=storyboard?.instantiateViewController(withIdentifier: "pi") as! PersonalInfo
        let interest=storyboard?.instantiateViewController(withIdentifier: "ints") as! Interests
        let experiences=storyboard?.instantiateViewController(withIdentifier: "exps") as! Experiences
        let certificates=storyboard?.instantiateViewController(withIdentifier: "certs") as! Certificates
        views.append(pi)
        views.append(interest)
        views.append(experiences)
        views.append(certificates)
    }
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer)
    {
        if sender.direction == .left
        {
           
            if position < views.count-1{
                position = position + 1
                scrollView.setContentOffset(CGPoint(x: CGFloat(position) * scrollView.frame.size.width, y: 0), animated: true)
                pageControl.currentPage=position
                
            }
        }

        if sender.direction == .right
        {
            if position > 0{
                position = position - 1
                
                scrollView.setContentOffset(CGPoint(x: CGFloat(position) * scrollView.frame.size.width, y: 0), animated: true)
                pageControl.currentPage=position
            }
            
        }
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        let current=((sender as AnyObject).currentPage)!
        position=current
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * scrollView.frame.size.width, y: 0), animated: true)
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

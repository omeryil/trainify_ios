//
//  UserTabViewController.swift
//  trainig
//
//  Created by omer yildirim on 5.02.2025.
//

import UIKit

class TrainerTabViewController: UITabBarController {
    var icons:[String]=["homekit","calendar","person"]
    var texts:[String]=[String(localized:"home"),String(localized:"calendar"),String(localized:"profile")]
    public var screen:UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0..<icons.count{
            self.tabBar.items![index].image = UIImage(systemName: icons[index])
            self.tabBar.items![index].title = texts[index]
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        if let vc = screen {
//            self.navigationController!.pushViewController(vc, animated: true)
//        }
        // Do any additional setup after loading the view.
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

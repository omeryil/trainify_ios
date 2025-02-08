//
//  UserTabViewController.swift
//  trainig
//
//  Created by omer yildirim on 5.02.2025.
//

import UIKit

class UserTabViewController: UITabBarController {
    var icons:[String]=["homekit","magnifyingglass","calendar","person"]
    var texts:[String]=["home","Search","Calendar","Profile"]
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0..<icons.count{
            self.tabBar.items![index].image = UIImage(systemName: icons[index])
            self.tabBar.items![index].title = texts[index]
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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

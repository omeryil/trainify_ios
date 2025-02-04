//
//  Testt.swift
//  trainig
//
//  Created by omer yildirim on 4.02.2025.
//

import UIKit

class Testt: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var btn: UIButton!
    @IBAction func clc(_ sender: Any) {
        
        let navigationController = storyboard?.instantiateViewController(withIdentifier: "settingNav") as! UINavigationController

        let viewController = storyboard?.instantiateViewController(withIdentifier: "sett") as! SettingsController
        navigationController.pushViewController(viewController, animated: true)
        //self.present(navigationController, animated: true, completion: nil)
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

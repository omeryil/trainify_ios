//
//  SignUpView.swift
//  trainig
//
//  Created by omer yildirim on 26.01.2025.
//

import UIKit

class SignUpView: UIViewController {

    @IBOutlet weak var sign_up: CustomButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        sign_up.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        sign_up.titleLabel?.text = String(localized: "sign_up")
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

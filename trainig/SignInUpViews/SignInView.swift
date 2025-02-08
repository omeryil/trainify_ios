//
//  SignInView.swift
//  trainig
//
//  Created by omer yildirim on 26.01.2025.
//

import UIKit

class SignInView: UIViewController {

    @IBOutlet weak var sign_in_button: CustomButton!
    @IBOutlet weak var google_btn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgot_btn: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    public var delegate: sign_in_up_delegate?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        forgot_btn.setTitle(String(localized: "forgot_pass"), for: .normal)
        //sign_in_button.setTitle(String(localized: "sign_in"), for: .normal)
        sign_in_button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        sign_in_button.titleLabel?.text = String(localized: "sign_in")
        orLabel.text = String(localized: "orStr")
        //email.layer.cornerRadius = 15.
        // Do any additional setup after loading the view.
    }

    @IBAction func sign_in_cl(_ sender: Any) {
        delegate?.sign_in()
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

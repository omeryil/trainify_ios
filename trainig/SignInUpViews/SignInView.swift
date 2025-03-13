//
//  SignInView.swift
//  trainig
//
//  Created by omer yildirim on 26.01.2025.
//

import UIKit

class SignInView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sign_in_button: CustomButton!
    @IBOutlet weak var google_btn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var forgot_btn: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    public var delegate: sign_in_up_delegate?
    public var indicatorDelegate: indicatorDelegate?
    let functions = Functions()
    var ld = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ld == 0 {
            email.text = "omer_yildirim@outlook.com.tr"
            password.text = "3299538"
        }else if ld == 1{
            email.text = "ali@a.com"
            password.text = "Aa123456"
        }else{
            email.text = ""
            password.text = ""
        }
        email.delegate = self
        password.delegate = self
        forgot_btn.setTitle(String(localized: "forgot_pass"), for: .normal)
        sign_in_button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        sign_in_button.titleLabel?.text = String(localized: "sign_in")
        orLabel.text = String(localized: "orStr")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        self.delegate?.upKeyboard(notification: notification)
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.delegate?.downKeyboard()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            password.becomeFirstResponder() // textField2'ye geç
        } else if textField == password {
            password.resignFirstResponder()// textField3'e geç
        }
        return true
    }
    @IBAction func sign_in_cl(_ sender: Any) {
        indicatorDelegate?.showIndicator()
        var data: [String: Any] = [:]
        data["usermail"] = email.text
        data["userpass"] = password.text
        functions.login(data: data, onCompleteBool: { (success,error) in
            if success!{
                DispatchQueue.main.sync {
                    print(CacheData.getUserData())
                    self.delegate?.sign_in()
                }
            }else{
                DispatchQueue.main.sync {
                    self.functions.createAlert(self: self, title: String(localized: "error"), message: error!, yesNo: false, alertReturn: { result in
                        
                    })
                }
                
                print(error!)
            }
            DispatchQueue.main.sync {
                self.indicatorDelegate?.hideIndicator()
            }
        })
        
        
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

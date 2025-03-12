//
//  SignUpView.swift
//  trainig
//
//  Created by omer yildirim on 26.01.2025.
//

import UIKit

class SignUpView: UIViewController {
    @IBOutlet weak var isTrainer: UISwitch!
    
    @IBOutlet weak var asTrainer: UILabel!
    @IBOutlet weak var nametxt: UILabel!
    @IBOutlet weak var emailtxt: UILabel!
    @IBOutlet weak var passtxt: UILabel!
    @IBOutlet weak var repastxt: UILabel!
    
    @IBOutlet weak var name: CustomTextField!
    @IBOutlet weak var mail: CustomTextField!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var repassword: CustomTextField!
    
    @IBOutlet weak var sign_up: CustomButton!
    public var delegate: sign_in_up_delegate?
    var tfs: [CustomTextField]=[]
    let functions = Functions()
    public var indicatorDelegate: indicatorDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfs.append(contentsOf: [name,mail,password,repassword])
        nametxt.text = String(localized: "full_name")
        emailtxt.text = String(localized: "e_mail")
        passtxt.text = String(localized: "pass")
        repastxt.text = String(localized: "re_pass")
        asTrainer.text = String(localized: "as_trainer")
        
        sign_up.setTitle(String(localized: "sign_up"), for: .normal)
        sign_up.setTitle(String(localized: "sign_up"), for: .selected)
        setEmpty()
    }
    func setEmpty() {
        name.text = ""
        mail.text = ""
        password.text = ""
        repassword.text = ""
    }
    @IBAction func sign_up_cl(_ sender: Any) {
        if false {
            self.delegate?.sign_up()
            return
        }
        
        if !check_text() {
            functions.createAlert(self: self, title: String(localized: "error"), message: String(localized: "fill_all"), yesNo: false, alertReturn: { result in
                
            })
            return
        }
        if !check_passes() {
            functions.createAlert(self: self, title: String(localized: "error"), message: String(localized: "not_same"), yesNo: false, alertReturn: { result in
                
            })
            return
        }
        if !isValidPassword() {
            let err = getMissingValidation(str: password.text!.trimmingCharacters(in: .whitespaces))
            functions.createAlert(self: self, title: String(localized: "error"), message: err, yesNo: false, alertReturn: { result in
                
            })
            return
        }
        //delegate?.sign_up()
        insertUser()
    }
    func insertUser(){
        indicatorDelegate?.showIndicator()
        let data : Any = [
            "collectionName": "users",
            "content": [
                "name": name.text!.trimmingCharacters(in: .whitespaces),
                "photo":"",
                "username": "",
                "userpass":password.text!.trimmingCharacters(in: .whitespaces),
                "usermail":mail.text!.trimmingCharacters(in: .whitespaces),
                "role": isTrainer.isOn ? "trainer" : "user",
                "createdDate": Statics.currentTimeInMilliSeconds(),
                "isActive":true,
                "uniqueFields":["usermail"]
            ]
        ]
        functions.getGuestToken(onCompleteBool: {(s,e) in
            if e == PostGet.no_connection {
                DispatchQueue.main.async {
                    PostGet.noInterneterror(v: self)
                }
                return
            }
                if s! == false {
                    self.functions.createAlert(self: self, title: String(localized: "error"), message: e!, yesNo: false, alertReturn: { result in
                        
                    })
                }else{
                    self.functions.addUniqueCollection(data: data, onCompleteBool: {(success,error) in
                        if success! {
                            self.sign_in()
                        }else {
                            self.functions.createAlert(self: self, title: String(localized: "error"), message: error!, yesNo: false, alertReturn: { result in
                                
                            })
                        }
                    })
                }
        })
        
    }
    func sign_in(){
        
        var data: [String: Any] = [:]
        data["usermail"] = mail.text!.trimmingCharacters(in: .whitespaces)
        data["userpass"] = password.text!.trimmingCharacters(in: .whitespaces)
        functions.login(data: data, onCompleteBool: { (success,error) in
            if success!{
                DispatchQueue.main.sync {
                    print(CacheData.getUserData())
                    self.delegate?.sign_up()
                }
            }else{
                DispatchQueue.main.sync {
                    self.functions.createAlert(self: self, title: String(localized: "error"), message: error!, yesNo: false, alertReturn: { result in
                        
                    })
                }
                
                print(error!)
            }

        })
    }
    func check_text() -> Bool {
        for i in tfs {
            if i.text!.isEmpty {
                return false
            }
        }
        return true
    }
    func check_passes() -> Bool {
        if password.text! != repassword.text! {
            return false
        }
        return true
    }
    func isValidPassword() -> Bool {
        let password = self.password.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

    }
    func getMissingValidation(str: String) -> String {
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: str)){
            return String(localized: "one_uppercase")
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: str)){
            return String(localized: "one_digit")
        }

        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: str)){
            return String(localized: "one_lowercase")
        }
        
        if(str.count < 8){
            return String(localized: "min_8")
        }
        return ""
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

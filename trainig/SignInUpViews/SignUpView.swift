//
//  SignUpView.swift
//  trainig
//
//  Created by omer yildirim on 26.01.2025.
//

import UIKit

class SignUpView: UIViewController {

    @IBOutlet weak var sign_up: CustomButton!
    public var delegate: sign_in_up_delegate?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        sign_up.setTitle(String(localized: "sign_up"), for: .normal)
        sign_up.setTitle(String(localized: "sign_up"), for: .selected)
       
        // Do any additional setup after loading the view.
    }

    @IBAction func sign_up_cl(_ sender: Any) {
        delegate?.sign_up()
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

//
//  UpdateAboutViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit

class UpdateAboutViewController: UIViewController {
    var placeholderLabel : UILabel!
    @IBOutlet weak var aboutTextView: CustomTextViewBorder8!
    @IBOutlet weak var countLabel: UILabel!
    let functions = Functions()
    var userData:NSMutableDictionary!
    var aboutId=""
    var isStepperOn:Bool = false
    var delegate:StepperDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = CacheData.getUserData()!
        self.title = String(localized: "about")
        aboutTextView.delegate = self
        aboutTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        placeholderLabel = UILabel()
        placeholderLabel.text = String(localized:"about_yourself")
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = .systemFont(ofSize: (aboutTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        aboutTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 16, y: 16)
        placeholderLabel.isHidden = !aboutTextView.text.isEmpty
        getAboutText()
        aboutTextView.addDoneButtonOnKeyboard()
        // Do any additional setup after loading the view.
    }
    
    func getAboutText(){
        let id=userData["id"]
        let data:Any=[
                "where": [
                    "collectionName": "users",
                    "and":[
                        "id":id
                    ]
                ],
                "related": [
                    "relationName": "trainerAboutRelation",
                    "where": [
                        "collectionName": "trainerAbout"
                    ]
                ]
        ]
        functions.getRelations(data: data,listItem:"trainerAbout", onCompleteWithData: { (contentData,error) in
            let resData=contentData as? NSArray ?? []
            if error!.isEmpty {
                for item in resData{
                    let itemDic = item as! NSDictionary
                    self.aboutId = itemDic["id"] as! String
                    let content = itemDic["content"] as! NSDictionary
                    DispatchQueue.main.async {
                        self.aboutTextView.text=content["about"] as? String
                        self.placeholderLabel.isHidden = !self.aboutTextView.text.isEmpty
                        self.updateCharacterCount()
                    }
                }
               
            }else{
                if error == PostGet.no_connection {
                    DispatchQueue.main.async {
                        PostGet.noInterneterror(v: self)
                    }
                }
                
            }
        })
        
    }
    func updateCharacterCount() {
        delegate?.about(data: self.aboutTextView.text ?? "")
        let cCount = self.aboutTextView.text.count

        self.countLabel.text = "\((0) + cCount)/1000"
     }
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        if !isStepperOn {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(update))
        }
       

    }
    @objc func update(_ button: UIBarButtonItem?) {
        self.view.showLoader(String(localized:"wait"))
        var data : Any = [
            "where": [
                "collectionName": "trainerAbout",
                "and": [
                    "id": self.aboutId
                ]
            ],
            "fields": [
                [
                    "field": "about",
                    "value": aboutTextView.text!
                ]
            ]
        ]
        functions.update(data: data, onCompleteBool: { (success,error) in
            if success! {
                print(success!)
            }else {
                if error == PostGet.no_connection {
                    DispatchQueue.main.async {
                        PostGet.noInterneterror(v: self)
                        self.view.dismissLoader()
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                self.view.dismissLoader()
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
extension UpdateAboutViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
        self.updateCharacterCount()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count +  (text.count - range.length) <= 1000
    }
}

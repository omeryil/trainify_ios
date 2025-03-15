//
//  UpdateAboutViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit

class Target: UIViewController {
    var placeholderLabel : UILabel!
    @IBOutlet weak var targetTxt: CustomTextViewBorder8!
    @IBOutlet weak var countLabel: UILabel!
    let functions = Functions()
    var userData:NSMutableDictionary!
    var targetId=""
    var isStepperOn:Bool = false
    var delegate:StepperDelegate?
    var isFirst=true
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = CacheData.getUserData()!
        self.title = String(localized: "target")
        targetTxt.delegate = self
        targetTxt.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        placeholderLabel = UILabel()
        placeholderLabel.text = String(localized:"target_ph")
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = UIFont.systemFont(ofSize: targetTxt.font?.pointSize ?? 17)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        targetTxt.addSubview(placeholderLabel)
        placeholderLabel.isHidden = !targetTxt.text.isEmpty
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: targetTxt.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: targetTxt.trailingAnchor, constant: -16),
            placeholderLabel.topAnchor.constraint(equalTo: targetTxt.topAnchor, constant: 16),
            placeholderLabel.widthAnchor.constraint(lessThanOrEqualTo: targetTxt.widthAnchor, constant: -32) // Genişlik sınırı ekle
        ])

        // Auto Layout'un tam olarak çalışmasını sağlamak için
        placeholderLabel.preferredMaxLayoutWidth = targetTxt.frame.width - 32
        getAboutText()
        targetTxt.addDoneButtonOnKeyboard()
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
                    "relationName": "userTargetRelation",
                    "where": [
                        "collectionName": "userTarget"
                    ]
                ]
        ]
        functions.getRelations(data: data,listItem:"userTarget", onCompleteWithData: { (contentData,error) in
            let resData=contentData as? NSArray ?? []
            if error!.isEmpty {
                for item in resData{
                    self.isFirst = false
                    let itemDic = item as! NSDictionary
                    self.targetId = itemDic["id"] as! String
                    let content = itemDic["content"] as! NSDictionary
                    DispatchQueue.main.async {
                        self.targetTxt.text=content["target"] as? String
                        self.placeholderLabel.isHidden = !self.targetTxt.text.isEmpty
                        self.updateCharacterCount()
                    }
                    break
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
        delegate?.about(data: self.targetTxt.text ?? "")
        let cCount = self.targetTxt.text.count

        self.countLabel.text = "\((0) + cCount)/500"
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
        if isFirst{
            insertData()
        }else{
            updateData()
        }
        
       
    }
    func insertData() {
        let id=userData["id"]
        var data : Any =
        [
            "relations": [
                [
                    "id": id,
                    "collectionName":"users",
                    "relationName": "userTargetRelation"
                ]
            ],
            "contents": [
                [
                    "collectionName": "userTarget",
                    "content": [
                        "target": targetTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                        "createdDate": Int64(Date().timeIntervalSince1970*1000)
                    ]
                ]
            ]
        ]
        functions.addRelations(data: data, onCompleteBool: { (success,error) in
            if success! {
               
                self.isFirst = false
            }else {

                if error == PostGet.no_connection {
                    DispatchQueue.main.async {
                        PostGet.noInterneterror(v: self)
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                self.view.dismissLoader()
            }
        })
    }
    func updateData() {
        var data : Any = [
            "where": [
                "collectionName": "userTarget",
                "and": [
                    "id": self.targetId
                ]
            ],
            "fields": [
                [
                    "field": "target",
                    "value": targetTxt.text!
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

}
extension Target : UITextViewDelegate {
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
        return textView.text.count +  (text.count - range.length) <= 500
    }
}

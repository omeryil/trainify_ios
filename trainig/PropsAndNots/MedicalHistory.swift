//
//  UpdateAboutViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit

class MedicalHistory: UIViewController {
    var placeholderLabel : UILabel!
    @IBOutlet weak var medialHistoryTxt: CustomTextViewBorder8!
    @IBOutlet weak var countLabel: UILabel!
    let functions = Functions()
    var userData:NSMutableDictionary!
    var medicalId=""
    var isStepperOn:Bool = false
    var delegate:StepperDelegate?
    var isFirst=true
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = CacheData.getUserData()!
        self.title = String(localized: "medical_history")
        medialHistoryTxt.delegate = self
        medialHistoryTxt.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        placeholderLabel = UILabel()
        placeholderLabel.text = String(localized:"medical_history_ph")
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = UIFont.systemFont(ofSize: medialHistoryTxt.font?.pointSize ?? 17)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        medialHistoryTxt.addSubview(placeholderLabel)
        placeholderLabel.isHidden = !medialHistoryTxt.text.isEmpty
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: medialHistoryTxt.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: medialHistoryTxt.trailingAnchor, constant: -16),
            placeholderLabel.topAnchor.constraint(equalTo: medialHistoryTxt.topAnchor, constant: 16),
            placeholderLabel.widthAnchor.constraint(lessThanOrEqualTo: medialHistoryTxt.widthAnchor, constant: -32) // Genişlik sınırı ekle
        ])

        // Auto Layout'un tam olarak çalışmasını sağlamak için
        placeholderLabel.preferredMaxLayoutWidth = medialHistoryTxt.frame.width - 32
        getAboutText()
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
                    "relationName": "userMediacalRelation",
                    "where": [
                        "collectionName": "userMedical"
                    ]
                ]
        ]
        functions.getRelations(data: data,listItem:"userMedical", onCompleteWithData: { (contentData,error) in
            let resData=contentData as? NSArray ?? []
            if error!.isEmpty {
                for item in resData{
                    self.isFirst = false
                    let itemDic = item as! NSDictionary
                    self.medicalId = itemDic["id"] as! String
                    let content = itemDic["content"] as! NSDictionary
                    DispatchQueue.main.async {
                        self.medialHistoryTxt.text=content["history"] as? String
                        self.placeholderLabel.isHidden = !self.medialHistoryTxt.text.isEmpty
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
        delegate?.about(data: self.medialHistoryTxt.text ?? "")
        let cCount = self.medialHistoryTxt.text.count

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
                    "relationName": "userMediacalRelation"
                ]
            ],
            "contents": [
                [
                    "collectionName": "userMedical",
                    "content": [
                        "history": medialHistoryTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines),
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
                "collectionName": "userMedical",
                "and": [
                    "id": self.medicalId
                ]
            ],
            "fields": [
                [
                    "field": "history",
                    "value": medialHistoryTxt.text!
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
extension MedicalHistory : UITextViewDelegate {
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

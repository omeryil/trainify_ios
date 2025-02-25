//
//  AboutViewController.swift
//  trainig
//
//  Created by omer yildirim on 2.02.2025.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutText: UITextView!
    var userData:NSDictionary!
    let functions=Functions()
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = CacheData.getUserData()!
        getAboutText()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        userData = CacheData.getUserData()!
        getAboutText()
        
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
        functions.getRelationsOneContent(data: data,listItem:"trainerAbout", onCompleteWithData: { (contentData,error) in
            if contentData != nil {
                let content=contentData as! NSDictionary
                DispatchQueue.main.async {
                    self.aboutText.text=content["about"] as? String
                }
            }else{
                print(error!)
            }
            DispatchQueue.main.async {
                //self.view.dismissLoader()
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

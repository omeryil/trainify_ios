//
//  AboutViewController.swift
//  trainig
//
//  Created by omer yildirim on 2.02.2025.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutText: UITextView!
    let functions=Functions()
    var id:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAboutText()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        getAboutText()
        
    }
    func getAboutText(){
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
                if error == PostGet.no_connection {
                    DispatchQueue.main.async {
                        PostGet.noInterneterror(v: self)
                    }
                }
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

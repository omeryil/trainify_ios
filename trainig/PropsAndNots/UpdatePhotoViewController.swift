//
//  UpdatePhotoViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit

class UpdatePhotoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    @IBOutlet weak var imgView: UIImageView!
    let imagePickerController = UIImagePickerController()
    @IBOutlet weak var pickBtn: UIButton!
    var imageURL: URL?
    let functions = Functions()
    var userData:NSMutableDictionary!
    var fileURL:URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate=self
        self.title=String(localized:"profile_photo")
        userData=CacheData.getUserData()!
    }
    @IBAction func pickImage(_ sender: Any) {
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.image"]

        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        let editedImage = info[.editedImage] as! UIImage
        fileURL = Statics.saveImageToTempDirectory(image: editedImage)
        
        
        let img=selectedImage.resize(Int(imgView.frame.width), Int(imgView.frame.height))
        imgView.image = img
        imgView.contentMode = .scaleToFill
        dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(update))
        
        
        let imageUrl:String? = userData["photo"] as? String ?? nil
        if let urlString = imageUrl, let url = URL(string: urlString) {
            imgView.kf.setImage(with: url, placeholder: UIImage(named: "person"))
        }

    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    @objc func update(_ button: UIBarButtonItem?) {
        self.view.showLoader(String(localized:"wait"))
        functions.upload(data: fileURL, onCompleteWithData: {(result,error) in
            if error == PostGet.no_connection {
                DispatchQueue.main.async {
                    PostGet.noInterneterror(v: self)
                    self.view.dismissLoader()
                }
                return
            }
            let r = result as! response
            if r.ResponseCode == 200 {
                let d = r.JsonObject as NSDictionary
                let data = d["data"] as! NSDictionary
                let url = data["url"] as! String
                self.updatePhoto(url)
            }else {
                DispatchQueue.main.async {
                    self.view.dismissLoader()
                }
               
            }
        })
    }
    func updatePhoto(_ url:String) {
        let data : Any = [
            "where": [
                "collectionName": "users",
                "and": [
                    "id": userData["id"]
                ]
            ],
            "fields": [
                [
                    "field": "photo",
                    "value": Statics.osService + url
                ]
            ]
        ]
        functions.update(data: data as! [String : Any], onCompleteBool: {(success,error) in
            if success! {
                self.userData["photo"] = Statics.osService + url
                CacheData.saveUserData(data: self.userData)
                self.updateSearchServicePhoto(Statics.osService + url)
            }else{
                if error == PostGet.no_connection {
                    DispatchQueue.main.async {
                        PostGet.noInterneterror(v: self)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.view.dismissLoader()
                }
            }
            
        })
    }
    func updateSearchServicePhoto(_ url : String) {
        let data : Any = [
            "fields": [
                "trainerPhoto":url
            ],
            "where":[
                "trainerid":userData["id"]
            ]
        ]
        functions.updateSearhPhoto(data: data, onCompleteBool: {(success,error) in
            if error == PostGet.no_connection {
                DispatchQueue.main.async {
                    PostGet.noInterneterror(v: self)
                }
                return
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

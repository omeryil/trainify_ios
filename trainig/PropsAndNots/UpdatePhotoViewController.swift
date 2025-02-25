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
    var userData:NSDictionary!
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
        functions.upload(data: fileURL, onCompleteWithData: {(result,error) in
            let r = result as! response
            if r.ResponseCode == 200 {
                print("OK")
            }else {
                print(error!)
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

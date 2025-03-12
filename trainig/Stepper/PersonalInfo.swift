//
//  PersonalInfo.swift
//  trainig
//
//  Created by omer yildirim on 28.01.2025.
//

import UIKit

class PersonalInfo:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {
    
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genders", for: indexPath) as? GenderCell else { return UICollectionViewCell() }
        let gen = genders[indexPath.row]
        
        cell.configure(with: gen)
        
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let cell = collectionView.cellForItem(at: indexPath) as! GenderCell
        genders=cell.configureSelect(index: indexPath.row, genders: genders, list: strGenders)
        genderCollection.reloadData()
        let gender=genders.filter { $0.selected }.first?.gender ?? ""
        stepperData["gender"]=gender
        stepperDelegate?.personalInfo(data: stepperData)
    }
    

    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var careerLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var birthDateTF: CustomTextField!
    @IBOutlet weak var heightTF: CustomTextFieldBorder!
    @IBOutlet weak var weightTF: CustomTextFieldBorder!
    @IBOutlet weak var expTF: CustomTextFieldBorder!
    @IBOutlet weak var titleTF: CustomTextFieldBorder!
    @IBOutlet weak var genderCollection: UICollectionView!
    var genders: [GenderItem] = []
    let strGenders=["man","woman","trans", "nonbin"]
    var pickerToolbar: UIToolbar?
    var datePicker: UIDatePicker!
    var eDatePicker: UIDatePicker!
    var wPicker = UIPickerView()
    var hPicker = UIPickerView()
    var heights: [String] = []
    var weights: [String] = []
    var isStepperOn:Bool=false
    var stepperDelegate:StepperDelegate?
    var userData:NSMutableDictionary!
    var stepperData:[String:Any]=[
        "gender":"",
        "height":"",
        "weight":"",
        "birthdate":0,
        "expstarted":0,
        "title":"",
        "rating":CGFloat(0)
    ]
    @IBOutlet weak var fullname: UILabel!
    let imagePickerController = UIImagePickerController()
    @IBOutlet weak var pickBtn: UIButton!
    var role:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        userData = CacheData.getUserData()!
        role = userData["role"] as? String
        titleTF.delegate=self
        if role == "user" {
            careerLbl.isHidden=true
            expTF.isHidden=true
            titleTF.isHidden=true
            titleLbl.isHidden=true
        }
        else{
            titleTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        }
        fullname.text=userData["name"] as? String ?? ""
        self.addData()
        genderCollection.dataSource=self
        genderCollection.delegate=self
        
        wPicker.delegate = self
        hPicker.delegate = self
        wPicker.dataSource = self
        hPicker.dataSource = self
        
       
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        genderCollection!.collectionViewLayout = layout
        createUIToolBar()
        createDatePicker()
        createExpDatePicker()
        createHeightPicker()
        createWeightPicker()
        bindPickers()

    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        stepperData["title"]=textField.text?.trimmingCharacters(in: .whitespaces)
        stepperDelegate?.personalInfo(data: stepperData)
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
        let img=selectedImage.resize(Int(imgView.frame.width), Int(imgView.frame.height))
        imgView.image = img
        let editedImage = info[.editedImage] as! UIImage
        let fileURL = Statics.saveImageToTempDirectory(image: editedImage)
        stepperData["photo"]=fileURL
        stepperDelegate?.personalInfo(data: stepperData)
        imgView.contentMode = .scaleToFill
        dismiss(animated: true, completion: nil)
    }
    var selectedTextField: UITextField?
    @IBAction func t_up(_ sender: Any) {
        selectedTextField = sender as? UITextField
    
    }
    func createWeightPicker(){
        let frameView = UIView()
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = UIColor(named: "DarkBack")
        frameView.frame.size = CGSize(width: 0, height: 200)
        frameView.addSubview(wPicker)
        wPicker.setValue(UIColor.white, forKeyPath: "textColor")
        wPicker.translatesAutoresizingMaskIntoConstraints = false
        wPicker.topAnchor.constraint(equalTo: frameView.topAnchor).isActive = true
        wPicker.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        wPicker.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        wPicker.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        weightTF.inputView = frameView
        weightTF?.inputAccessoryView = pickerToolbar
    }
    func createHeightPicker(){
        let frameView = UIView()
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = UIColor(named: "DarkBack")
        frameView.frame.size = CGSize(width: 0, height: 200)
        frameView.addSubview(hPicker)
        hPicker.setValue(UIColor.white, forKeyPath: "textColor")
        hPicker.translatesAutoresizingMaskIntoConstraints = false
        hPicker.topAnchor.constraint(equalTo: frameView.topAnchor).isActive = true
        hPicker.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        hPicker.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        hPicker.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        heightTF.inputView = frameView
        heightTF?.inputAccessoryView = pickerToolbar
    }
    func bindPickers(){
        for i in 50...280{
            heights.append(String(i) + " cm")
        }
        for i in 40...250{
            weights.append(String(i) + " kg")
        }
    }
    func createDatePicker() {
        let frameView = UIView()
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = UIColor(named: "DarkBack")
        frameView.frame.size = CGSize(width: 0, height: 300)
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        let max = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.maximumDate = max
        birthDateTF?.inputAccessoryView = pickerToolbar
        frameView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: frameView.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        birthDateTF.inputView = frameView
    }
    func createExpDatePicker() {
        let frameView = UIView()
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = UIColor(named: "DarkBack")
        frameView.frame.size = CGSize(width: 0, height: 300)
        eDatePicker = UIDatePicker()
        eDatePicker.datePickerMode = .date
        eDatePicker.preferredDatePickerStyle = .wheels
        eDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        let max = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        //datePicker.maximumDate = max
        expTF?.inputAccessoryView = pickerToolbar
        frameView.addSubview(eDatePicker)
        eDatePicker.translatesAutoresizingMaskIntoConstraints = false
        eDatePicker.topAnchor.constraint(equalTo: frameView.topAnchor).isActive = true
        eDatePicker.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        eDatePicker.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        eDatePicker.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        expTF.inputView = frameView
    }
    func formatDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    func createUIToolBar() {
            
        pickerToolbar = UIToolbar()
        pickerToolbar?.autoresizingMask = .flexibleHeight
        pickerToolbar?.layer.cornerRadius = 10

        pickerToolbar?.barStyle = .default
        pickerToolbar?.barTintColor = UIColor(named: "DarkBack")
        pickerToolbar?.backgroundColor = UIColor.white
        pickerToolbar?.isTranslucent = false

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:
                #selector(cancelBtnClicked(_:)))
        cancelButton.tintColor = UIColor.red
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
                #selector(doneBtnClicked(_:)))
        doneButton.tintColor = UIColor(named: "MainColor")
        
        pickerToolbar?.items = [cancelButton, flexSpace, doneButton]
            
    }
    @objc func cancelBtnClicked(_ button: UIBarButtonItem?) {
        birthDateTF?.resignFirstResponder()
        weightTF?.resignFirstResponder()
        heightTF?.resignFirstResponder()
        expTF?.resignFirstResponder()
    }
        
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        birthDateTF?.resignFirstResponder()
        weightTF?.resignFirstResponder()
        heightTF?.resignFirstResponder()
        expTF?.resignFirstResponder()
        if selectedTextField == birthDateTF {
            birthDateTF.text = formatDate(date: datePicker.date)
            let secondsStamp = Int(datePicker.date.timeIntervalSince1970*1000)
            stepperData["birthdate"]=secondsStamp
            stepperDelegate?.personalInfo(data: stepperData)
        }else if selectedTextField == expTF {
            expTF.text = formatDate(date: eDatePicker.date)
            let secondsStamp = Int(eDatePicker.date.timeIntervalSince1970*1000)
            stepperData["expstarted"]=secondsStamp
            stepperDelegate?.personalInfo(data: stepperData)
        }else if selectedTextField == weightTF{
            weightTF.text = weights[wPicker.selectedRow(inComponent: 0)]
            stepperData["weight"]=weights[wPicker.selectedRow(inComponent: 0)]
            stepperDelegate?.personalInfo(data: stepperData)
        }else if selectedTextField == heightTF{
            heightTF.text = heights[hPicker.selectedRow(inComponent: 0)]
            stepperData["height"]=heights[hPicker.selectedRow(inComponent: 0)]
            stepperDelegate?.personalInfo(data: stepperData)
        }
        
    }
    func addData(){
       for s in strGenders{
           var str=s
           if #available(iOS 16, *) {
               str = String(localized: LocalizedStringResource(stringLiteral: s))
           } else {
               // Fallback on earlier versions
           }
           genders.append(GenderItem(source: s, gender: str,selected: false))
        }
            
      
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
extension PersonalInfo:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == wPicker){
            return weights.count
        }else if(pickerView == hPicker){
            return heights.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == wPicker){
            return String(weights[row])
        }else if(pickerView == hPicker){
            return String(heights[row])
        }
        return nil
    }
    
}


//
//  UpdatePersonalViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit

class UpdatePersonalViewController: UIViewController {
    
    @IBOutlet weak var heightTF: CustomTextFieldBorder8!
    @IBOutlet weak var weightTF: CustomTextFieldBorder8!
    
    
    var pickerToolbar: UIToolbar?
    var datePicker: UIDatePicker!
    var wPicker = UIPickerView()
    var hPicker = UIPickerView()
    var heights: [String] = []
    var weights: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=String(localized:"personal_info")
        wPicker.delegate = self
        hPicker.delegate = self
        wPicker.dataSource = self
        hPicker.dataSource = self
        
        createUIToolBar()
        
        createHeightPicker()
        createWeightPicker()
        bindPickers()
        // Do any additional setup after loading the view.
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
        weightTF?.resignFirstResponder()
        heightTF?.resignFirstResponder()
    }
        
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        weightTF?.resignFirstResponder()
        heightTF?.resignFirstResponder()
        if selectedTextField == weightTF{
            weightTF.text = weights[wPicker.selectedRow(inComponent: 0)]
        }else if selectedTextField == heightTF{
            heightTF.text = heights[hPicker.selectedRow(inComponent: 0)]
        }
        
    }
    var selectedTextField: UITextField?
    @IBAction func t_up(_ sender: Any) {
        selectedTextField = sender as? UITextField
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(update))

    }
    @objc func update(_ button: UIBarButtonItem?) {
        
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
extension UpdatePersonalViewController:UIPickerViewDelegate,UIPickerViewDataSource{
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

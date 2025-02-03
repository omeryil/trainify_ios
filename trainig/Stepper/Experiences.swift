//
//  Experiences.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class Experiences: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pwList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pwList[row]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experiences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expCell") as? ExperiencesCell else {
            return UITableViewCell()
        }
        cell.configure(with: experiences[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = tableView.cellForRow(at: indexPath) as? ExperiencesCell
        dummy.becomeFirstResponder()
    }
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var experienceTable: UITableView!
    let dummy = UITextField(frame: .zero)
    
    var experiences:[ExperiencesItem] = []
    
    let nPicker=UIPickerView()
    var pickerToolbar: UIToolbar?
    var pwList:[String] = []
    
    var selectedCell:ExperiencesCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        nPicker.delegate = self
        nPicker.dataSource = self
        addPwList()
        
        view.addSubview(dummy)
                
        createUIToolBar()
        createPicker()
        
        experienceTable.delegate=self
        experienceTable.dataSource=self
        addData()
        
        experienceTable.separatorStyle = .singleLine
        experienceTable.separatorColor = UIColor(named: "Seperator")
        
        question.text=String(localized: "experiences")
        desc.text=String(localized: "experiences_desc")
    }
    func addData() {
        let strs: [Int] = [1,2,3,4,5,6,7,8,9,10]
        let experiencestr:[String] = ["aaaa","bbbb","cccc","dddd","eeee","ffff","gggg","hhhh","iiii","jjjj"]
        for i in 0..<strs.count {
            experiences.append(ExperiencesItem(experience: experiencestr[i], year: strs[i]))
        }
        
    }
    func addPwList() {
        for i in 0..<50 {
            pwList.append(String(i) + " " + String(localized: "yrs"))
        }
    }
    func createPicker(){
        let frameView = UIView()
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = UIColor(named: "DarkBack")
        frameView.frame.size = CGSize(width: 0, height: 200)
        frameView.addSubview(nPicker)
        nPicker.setValue(UIColor.white, forKeyPath: "textColor")
        nPicker.translatesAutoresizingMaskIntoConstraints = false
        nPicker.topAnchor.constraint(equalTo: frameView.topAnchor).isActive = true
        nPicker.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        nPicker.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        nPicker.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        dummy.inputView = frameView
        dummy.inputAccessoryView = pickerToolbar
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
        dummy.resignFirstResponder()
    }
        
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        dummy.resignFirstResponder()
        selectedCell?.configureYear(with: pwList[nPicker.selectedRow(inComponent: 0)])
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

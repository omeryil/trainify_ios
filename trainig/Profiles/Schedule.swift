//
//  Schedule.swift
//  trainig
//
//  Created by omer yildirim on 23.02.2025.
//

import UIKit

class Schedule: UIViewController {
    var placeholderLabel : UILabel!
    @IBOutlet weak var training_title_lbl: UILabel!
    @IBOutlet weak var choose_date_lbl: UILabel!
    @IBOutlet weak var repetition_interval_lbl: UILabel!
    @IBOutlet weak var duration_lbl: UILabel!
    @IBOutlet weak var equipments_lbl: UILabel!
    @IBOutlet weak var time_range_lbl: UILabel!
    @IBOutlet weak var price_lbl: UILabel!
    @IBOutlet weak var training_title_txt: CustomTextField!
    @IBOutlet weak var choose_date_txt: CustomTextField!
    @IBOutlet weak var repetition_interval_txt: CustomTextField!
    @IBOutlet weak var duration_txt: CustomTextField!
    @IBOutlet weak var equipments_txt: RoundedTextView!
    @IBOutlet weak var time_start_txt: CustomTextField!
    @IBOutlet weak var time_finish_txt: CustomTextField!
    @IBOutlet weak var price_txt: CustomTextField!
    @IBOutlet weak var titleLbl: UILabel!
    var userData:NSMutableDictionary!
    var datePicker:UIDatePicker!
    var timePickerStart:UIDatePicker!
    var timePickerEnd:UIDatePicker!
    var pickerToolBar:UIToolbar!
    var repetitionPicker:UIPickerView!
    var repetitions:[String]=["norep","daily","weekly","monthly"]
    let functions = Functions()
    var indicatorDelegate:indicatorDelegate!
    var passDataDelegate:PassDataDelegate!
    var selectedRepition:String!
    var duration:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData = CacheData.getUserData()!
        
        titleLbl.text = String(localized:"schedule_settings")
        
        training_title_lbl.text = String(localized:"training_title")
        choose_date_lbl.text = String(localized:"choose_date")
        repetition_interval_lbl.text = String(localized:"repetition_interval")
        
        equipments_lbl.text = String(localized:"equipments")
        time_range_lbl.text = String(localized:"time_range")
        price_lbl.text = String(localized:"price")
        
        training_title_txt.placeholder = String(localized:"training_title_ph")
        choose_date_txt.placeholder = String(localized:"choose_date_ph")
        repetition_interval_txt.placeholder = String(localized:"repetition_interval_ph")
        
        
        time_start_txt.placeholder = String(localized:"start_time")
        time_finish_txt.placeholder = String(localized:"end_time")
        price_txt.placeholder = String(localized:"price_ph")
        
        
        equipments_txt.delegate = self
        equipments_txt.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        placeholderLabel = UILabel()
        placeholderLabel.text = String(localized:"equipments_ph")
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = .systemFont(ofSize: (equipments_txt.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        equipments_txt.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 16, y: 16)
        placeholderLabel.isHidden = !equipments_txt.text.isEmpty
        pickerToolBar = Statics.createUIToolBar()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:
                #selector(cancelBtnClicked(_:)))
        cancelButton.tintColor = UIColor.red
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
                #selector(doneBtnClicked(_:)))
        doneButton.tintColor = UIColor(named: "MainColor")
        pickerToolBar.items = [cancelButton, flexSpace, doneButton]
        datePicker = Statics.createDatePicker(tf: choose_date_txt, pickerToolbar: pickerToolBar)
        repetitionPicker = Statics.createPickerView(tf: repetition_interval_txt,pickerToolbar: pickerToolBar)
        timePickerStart = Statics.createTimePicker(tf: time_start_txt, pickerToolbar: pickerToolBar)
        timePickerEnd = Statics.createTimePicker(tf: time_finish_txt, pickerToolbar: pickerToolBar)
        repetitionPicker.delegate = self
        repetitionPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    @objc func cancelBtnClicked(_ button: UIBarButtonItem?) {
        choose_date_txt?.resignFirstResponder()
        repetition_interval_txt?.resignFirstResponder()
        time_finish_txt?.resignFirstResponder()
        time_start_txt?.resignFirstResponder()
    }
        
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        choose_date_txt?.resignFirstResponder()
        repetition_interval_txt?.resignFirstResponder()
        time_finish_txt?.resignFirstResponder()
        time_start_txt?.resignFirstResponder()
        //weightTF?.resignFirstResponder()
        //heightTF?.resignFirstResponder()
        if selectedTextField == choose_date_txt {
            choose_date_txt.text = Statics.formatDate(date: datePicker.date)
            let secondsStamp = Int(datePicker.date.timeIntervalSince1970*1000)
        }else if selectedTextField == repetition_interval_txt {
            selectedRepition = repetitions[repetitionPicker.selectedRow(inComponent: 0)]
            repetition_interval_txt.text = String(localized:String.LocalizationValue(selectedRepition))
        }
        else if selectedTextField == time_start_txt {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            time_start_txt.text = formatter.string(from: timePickerStart.date)
        }
        else if selectedTextField == time_finish_txt {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            time_finish_txt.text = formatter.string(from: timePickerEnd.date)
        }
        
    }
    var selectedTextField: UITextField?
    @IBAction func t_up(_ sender: Any) {
        selectedTextField = sender as? UITextField
    
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true , completion: nil)
    }
    @IBAction func schedule_action(_ sender: Any) {
        var check : Any = checktxts()
        if let error_message = check as? String {
            functions.createAlert(self: self, title: String(localized:"error"), message: error_message, yesNo: false, alertReturn: { result in
                                  
                })
            return
        }
        check = checkTimes()
        if let error_message = check as? String {
            functions.createAlert(self: self, title: String(localized:"error"), message: error_message, yesNo: false, alertReturn: { result in
                                  
                })
            return
        }
        check = true
        if let error_message = check as? String {
            functions.createAlert(self: self, title: String(localized:"error"), message: error_message, yesNo: false, alertReturn: { result in
                                  
                })
            return
        }
        send()
    }
    func checktxts() -> Any {
        let check : [UITextField] = [training_title_txt,choose_date_txt,repetition_interval_txt,time_start_txt,time_finish_txt,price_txt]
        let minCount : [Int] = [3,-1,-1,-1,-1,2]
        let titles:[String] = [String(localized:"training_title"),"","","","",String(localized:"price")]
        let error_messages:[String] = [String(localized:"enter_training_title"),String(localized:"enter_date"),String(localized:"enter_repetition"),String(localized:"enter_start"),String(localized:"enter_end"),String(localized:"enter_price")]
        for c in 0..<check.count {
            let i : UITextField = check[c]
            if i.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return error_messages[c]
            }
            if minCount[c] > -1 && i.text!.count < minCount[c] {
                var str=String(localized:"text_count_error")
                let mCountStr:String = String(minCount[c])
                str = str.replacingOccurrences(of: "xxx", with: mCountStr)
                str = titles[c] + " " + str
                return str
            }
        }
        return true
    }
    func checkTimes() -> Any{
        let start=time_start_txt.text?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ":")
        let end = time_finish_txt.text?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ":")
        let starttime = Int(start![0])!*60+Int(start![1])!
        let endtime = Int(end![0])!*60+Int(end![1])!
        if starttime>=endtime{
            let error_message:String = String(localized:"start_time_greater_than_end_time")
            return error_message
        }else if endtime - starttime < 60{
            let error_message:String = String(localized:"start_time_60_errro")
            return error_message
        }
        duration = Statics.formatMinutesToHoursMinutes(endtime - starttime)
        return true
    }
    func checkHourDifference() -> Any {
        let d:String = "\(choose_date_txt.text!.trimmingCharacters(in: .whitespacesAndNewlines)) \(time_start_txt.text!.trimmingCharacters(in: .whitespacesAndNewlines))"
        if Statics.calculateHourDifference(dateString: d, hour: 48) {
            return true
        }else{
            return String(localized:"ad_publish_time_error")
        }
    }
    func send(){
        indicatorDelegate?.showIndicator()
        let data : Any = [
            "collectionName":"ads",
            "content":[
                "trainer_id":userData["id"]!,
                "training_title":training_title_txt.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                "date":choose_date_txt.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                "repetition":selectedRepition,
                "equipments":equipments_txt.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                "start_time":time_start_txt.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                "end_time":time_finish_txt.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                "price":price_txt.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                "duration":duration,
                "isActive":true
            ]
        ]
        passDataDelegate.passData(data: data)
        self.dismiss(animated: true)
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
extension Schedule : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
}
extension Schedule:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == repetitionPicker){
            return repetitions.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == repetitionPicker){
            return String(localized:String.LocalizationValue(repetitions[row]))
        }
        return nil
    }
    
}

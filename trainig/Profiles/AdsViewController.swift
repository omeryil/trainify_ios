//
//  AdsViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit
import FSCalendar
class AdsViewController: UIViewController,indicatorDelegate,PassDataDelegate,FSCalendarDelegate,FSCalendarDataSource, UITextFieldDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate=Statics.formatDate(date: date)
        let d =  Statics.createDate(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date))
        var seenIds: Set<String> = []
        let ads_id=self.adsCalendar.filter { $0.date == d && seenIds.insert($0.ads_id).inserted }.map { $0.ads_id }
        getAdsById(id: ads_id as! [String])
        
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        let year = Calendar.current.component(.year, from: currentPageDate)
        let mStr=month<10 ? "0"+String(month):String(month)
        dateString = "00-"+mStr+"-"+String(year)
        getTrainerDates(date: dateString)
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return eventDates.contains(date) ? 1 : 0
    }
    
    func passData(data: Any) {
        showIndicator()
        let ds = data as! NSDictionary
        let content = ds["content"] as! NSDictionary
        let date=content["date"] as! String
        let repetition=content["repetition"] as! String
        
        functions.addCollection(data: data as! [String : Any], onCompleteWithData: { data,error in
            if data != nil {
                let d = data as! NSDictionary
                let ddata = d["data"] as! NSDictionary
                let id = ddata["id"] as! String
                self.addTrainerAdsDate(sdata: ds,ads_id: id)
            }else{
                print(error!)
            }
            
            self.getAds(date: self.selectedDate)
            
        })
    }
    
    func showIndicator() {
        let ind = self.view.showLoader(nil) as? Indicator
        ind!.lbl.text=String(localized:"wait")
    }
    func getTrainerFeatures(){
        let id=userData["id"]
        let data:Any=[
                "where": [
                    "collectionName": "users",
                    "and":[
                        "id":id
                    ]
                ],
                "related": [
                    "relationName": "userFeatureRelation",
                    "where": [
                        "collectionName": "userFeature"
                    ]
                ]
        ]
        functions.getRelationsOneContent(data: data,listItem:"userFeature", onCompleteWithData: { (contentData,error) in
            if contentData != nil {
                let content=contentData as! NSDictionary
                DispatchQueue.main.async {
                    self.height=content["height"] as? String
                    self.gender=content["gender"] as? String
                    self.weight=content["weight"] as? String
                    self.birthdate=content["birthdate"] as? Int64
                    self.expStarted=content["expstarted"] as? Int64
                    self.trainerTitle=content["title"] as? String
                    self.rating=content["rating"] as? CGFloat
                }
            }else{
                print(error!)
            }
            DispatchQueue.main.async {
                self.view.dismissLoader()
            }
        })
    }
    func getSpecs(){
        specs.removeAll()
        let data:Any=[
            "where": [
                "collectionName": "users",
                "and":[
                    "id":userData["id"] as! String
                ]
            ],
            "related": [
                "relationName": "trainerSpecsRelation",
                "where": [
                    "collectionName": "trainerSpecs"
                ]
            ]
        ]
        functions.getRelations(data: data,listItem:"trainerSpecs", onCompleteWithData: { (contentData,error) in
            let resData=contentData as? NSArray ?? []
            if error!.isEmpty {
                for item in resData{
                    let itemDic = item as! NSDictionary
                    let content = itemDic["content"] as! NSDictionary
                    self.specs.append(content["spec"] as? String ?? "")
                }
            }else{
                print(error!)
                
            }
        })
    }
    func hideIndicator() {
        self.view.dismissLoader()
    }
    var sData:NSMutableDictionary!
    
    func addTrainerAdsDate(sdata:NSDictionary,ads_id:String){
        let dict = sdata["content"] as! NSDictionary
        sData = dict.mutableCopy() as? NSMutableDictionary
        let d = (sData["date"] as? String ?? "").components(separatedBy: "-")
        
        let startTimeStr = "\(sData["date"] as! String) \(sData["start_time"] as! String)"
        let endTimeStr = "\(sData["date"] as! String) \(sData["end_time"] as! String)"
        let startTime = Statics.convertToTimestamp(dateString:startTimeStr)
        let endTime = Statics.convertToTimestamp(dateString:endTimeStr)
        
        
        let data:Any = [
            "collectionName":"adsDates",
            "content":[
                "trainer_id":userData["id"]! as! String,
                "day":d[0],
                "month":d[1],
                "year":d[2],
                "fulldate":sData["date"] as! String,
                "repetition_period":sData["repetition"] as! String,
                "ads_id":ads_id,
                "startDate":sData["start_time"] as! String,
                "endDate":sData["end_time"] as! String,
                "startTime":startTime!,
                "endTime":endTime!,
                "isSold":false,
                "isReserved":false,
                "reservedUseerId":""
            ]
        ]
        let checkData:Any = [
            "where": [
                "collectionName":"adsDates",
                "and":[
                    "trainer_id":userData["id"]!,
                    "fulldate":sData["date"] as! String,
                    "repetition_period":sData["repetition"] as! String,
                    "startDate":sData["start_time"] as! String,
                    "endDate":sData["end_time"] as! String
                ]
            ]
        ]
        functions.getCollection(data: checkData, onCompleteWithData: { d,e in
            if d != nil {
                if (d as! NSArray).count<1 {
                    self.addTrainerAdsDate(data: data)
                }
            }else{
                self.addTrainerAdsDate(data: data)
            }
        })
    }
    func addTrainerAdsDate(data:Any){
        let d = data as! NSDictionary
        let content = d["content"] as! NSDictionary
        functions.addCollection(data: data, onCompleteBool: { success,error in
            print(success!)
            self.getTrainerDates(date: self.dateString)
            self.addTrainerAdsSearchService(content["ads_id"] as! String)
        })
    }
    func addTrainerAdsSearchService(_ ads_id:String){
        let startTimeStr = "\(sData["date"] as! String) \(sData["start_time"] as! String)"
        let endTimeStr = "\(sData["date"] as! String) \(sData["end_time"] as! String)"
        let startTime = Statics.convertToTimestamp(dateString:startTimeStr)
        let endTime = Statics.convertToTimestamp(dateString:endTimeStr)
        let data : Any = [
            "ads_id": ads_id,
            "trainerName": userData["name"],
            "trainerPhoto": userData["photo"],
            "trainerId": userData["id"],
            "trainerGender": gender,
            "trainerBirthDate": birthdate,
            "trainerRating": self.rating,
            "trainingPrice": Int(sData["price"] as! String),
            "trainerExpStarted": expStarted,
            "trainingEquipments": sData["equipments"] as! String,
            "trainerTitle": self.trainerTitle,
            "trainingTopic": sData["training_title"] as! String,
            "trainingStartDate": startTime,
            "trainingEndDate": endTime,
            "trainingDate": sData["date"] as! String,
            "trainerExps": specs
        ]
        functions.insertSearchData(data: data, onCompleteWithData: { d,e in
            if d as! Int == 200{
                print("OK")
            }else {
                print(e!)
            }
        })
    }
    var eventDates: [Date] = []
    @IBOutlet weak var adsTable: UITableView!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var calendar: FSCalendar!
    var ads: [AdsItem] = []
    let functions = Functions()
    var userData:NSDictionary!
    var dateString:String!
    var selectedDate:String!
    var height:String!
    var weight:String!
    var birthdate:Int64!
    var gender:String!
    var rating:CGFloat!
    var expStarted:Int64!
    var trainerTitle:String!
    var adsCalendar:[AdsICalendarItem] = []
    var specs:[String]=[]
    var startDatePicker:UIDatePicker!
    let tpicker=UIPickerView()
    var tPickerItems:[String] = []
    var pickerToolbar:UIToolbar!
    var selectedAd:Bool!
    var selectedAdId:String!
    let textField = UITextField()
    let textFieldTime = UITextField()
    var selectedIndexAd:Int!
    var mainAdsDate:NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.isHidden = true
        textFieldTime.isHidden = true
        view.addSubview(textField)
        view.addSubview(textFieldTime)
        createUIToolBar()
        createTPicker()
        createDatePicker()
        
        userData = CacheData.getUserData()!
        
        tpicker.delegate = self
        tpicker.dataSource = self
        
        textField.delegate = self
        textFieldTime.delegate = self
        
        getTrainerFeatures()
        getSpecs()
        
        calendar.delegate = self
        calendar.dataSource = self
        //calendar.scrollDirection = .vertical
        calendar.firstWeekday = 2
        dateString=Statics.formatDate(date: Date())
        selectedDate=Statics.formatDate(date: Date())
        getTrainerDates(date: dateString)
        
        adsTable.delegate = self
        adsTable.dataSource = self
        getAds(date: dateString)
        // Do any additional setup after loading the view.
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
    func createTPicker(){
        let frameView = UIView()
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = UIColor(named: "DarkBack")
        frameView.frame.size = CGSize(width: 0, height: 200)
        frameView.addSubview(tpicker)
        tpicker.setValue(UIColor.white, forKeyPath: "textColor")
        tpicker.translatesAutoresizingMaskIntoConstraints = false
        tpicker.topAnchor.constraint(equalTo: frameView.topAnchor).isActive = true
        tpicker.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        tpicker.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        tpicker.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        textField.inputView = frameView
        textField.inputAccessoryView = pickerToolbar
    }
    func createDatePicker() {
        let frameView = UIView()
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = UIColor(named: "DarkBack")
        frameView.frame.size = CGSize(width: 0, height: 300)
        startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .time
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        textFieldTime.inputAccessoryView = pickerToolbar
        frameView.addSubview(startDatePicker)
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        startDatePicker.topAnchor.constraint(equalTo: frameView.topAnchor).isActive = true
        startDatePicker.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        startDatePicker.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        startDatePicker.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        textFieldTime.inputView = frameView
    }
    @objc func cancelBtnClicked(_ button: UIBarButtonItem?) {
        textField.resignFirstResponder()
        textFieldTime.resignFirstResponder()
    }
    var selectedTextField: UITextField?
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        textField.resignFirstResponder()
        textFieldTime.resignFirstResponder()
        if selectedTextField == textField {
            let res = tpicker.selectedRow(inComponent: 0)
            if res == 0 {
                self.ads[selectedIndexAd].isActive = !selectedAd
                DispatchQueue.main.async {
                    self.adsTable.reloadData()
                }
                self.deactivate(id: selectedAdId!, activate: !selectedAd)
            }else{
                selectedTextField = textFieldTime
                textFieldTime.becomeFirstResponder()
            }
        }else if selectedTextField == textFieldTime{
            let selectedTime = startDatePicker.date
            
            // Add 1 hour to selected time
            let calendar = Calendar.current
            let newTime = calendar.date(byAdding: .hour, value: 1, to: selectedTime)!
            
            // Format new time
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            //duration al ve aradaki farkı öyle hesapla
            //adsDate'e ekle
            
            print(formatter.string(from: selectedTime))
            print(formatter.string(from: newTime))
            showIndicator()
            adsDates(startTimeStr: formatter.string(from: selectedTime),endTimeStr: formatter.string(from: newTime))
        }
        
    }
    func adsDates(startTimeStr:String,endTimeStr:String){
        
        let startDTimeStr = "\(mainAdsDate["fulldate"] as! String) \(startTimeStr)"
        let endDTimeStr = "\(mainAdsDate["fulldate"] as! String) \(endTimeStr)"
        let startTime = Statics.convertToTimestamp(dateString:startDTimeStr)
        let endTime = Statics.convertToTimestamp(dateString:endDTimeStr)
        sData["start_time"] = startTimeStr
        sData["end_time"] = endTimeStr
        let data : Any = [
            "collectionName":"adsDates",
            "content":[
                "trainer_id":userData["id"]! as! String,
                "day":mainAdsDate["day"],
                "month":mainAdsDate["month"],
                "year":mainAdsDate["year"],
                "fulldate":mainAdsDate["fulldate"] as! String,
                "repetition_period":mainAdsDate["repetition_period"] as! String,
                "ads_id":selectedAdId!,
                "startDate":startTimeStr,
                "endDate":endTimeStr,
                "startTime":startTime!,
                "endTime":endTime!,
                "isSold":false,
                "isReserved":false,
                "reservedUseerId":""
            ]
        ]
        let checkData:Any = [
            "where": [
                "collectionName":"adsDates",
                "and":[
                    "trainer_id":userData["id"]!,
                    "fulldate":mainAdsDate["fulldate"] as! String,
                    "repetition_period":mainAdsDate["repetition_period"] as! String,
                    "startDate":startTimeStr,
                    "endDate":endTimeStr
                ]
            ]
        ]
        functions.getCollection(data: checkData, onCompleteWithData: { d,e in
            if d != nil {
                if (d as! NSArray).count<1 {
                    self.addTrainerAdsDate(data: data)
                }
            }else{
                self.addTrainerAdsDate(data: data)
            }
        })
    }
    
    func getTrainerDates(date:String){
        let d = date.components(separatedBy: "-")
        let data:Any = [
            "where": [
                "collectionName":"adsDates",
                "and":[
                    "trainer_id":userData["id"]!,
                    "month":d[1],
                    "year":d[2],
                ]
            ]
        ]
        functions.getCollection(data: data, onCompleteWithData: { d,e in
            if d != nil {
                if (d as! NSArray).count>0 {
                   for i in d as! NSArray{
                       let collection = i as! NSDictionary
                       let content = collection["content"] as! NSDictionary
                       self.mainAdsDate = content
                       let ads_id = content["ads_id"] as! String
                       let repetition_period = content["repetition_period"] as! String
                       var date = Statics.createDate(year: Int(content["year"] as! String)!, month: Int(content["month"] as! String)!, day: Int(content["day"] as! String)!)
                       self.eventDates.append(date)
                       let aci = AdsICalendarItem(ads_id: ads_id, repetition: repetition_period,date: date)
                       self.adsCalendar.append(aci)
                       var period:Int = 0
                       var selected:Bool = false
                       var item:Calendar.Component!
                       var addItem:Int = 0
                       switch repetition_period {
                           case "daily":
                               period = 365
                               selected = true
                               item = .day
                               addItem = 1
                               break
                           case "weekly":
                               period = 52
                               selected = true
                               item = .weekday
                               addItem = 7
                               break
                           case "monthly":
                               period = 12
                               selected = true
                               item = .month
                               addItem = 1
                               break
                           default:
                               break
                       }
                       if selected {
                           for i in 0..<period{
                               date = Calendar.current.date(byAdding: item, value: addItem, to: date)!
                               let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
                               date = Statics.createDate(year: components.year!, month: components.month!, day: components.day!)
                               self.eventDates.append(date)
                               let aci = AdsICalendarItem(ads_id: ads_id, repetition: repetition_period,date: date)
                               self.adsCalendar.append(aci)
                           }
                       }
                       
                    }
                    DispatchQueue.main.async {
                        self.calendar.reloadData()
                    }
                }
            }else{
               
            }
            DispatchQueue.main.async {
                self.hideIndicator()
            }
        })
    }
    @IBAction func adAds_cl(_ sender: Any) {
        let fc=storyboard?.instantiateViewController(withIdentifier: "sch") as! Schedule
        fc.indicatorDelegate=self
        fc.passDataDelegate=self
        present(fc, animated: true)
    }
    func getAds(date:String) {
        self.ads.removeAll()
        
        let data:Any = [
            "where": [
                "collectionName":"ads",
                "and":[
                    "trainer_id":userData["id"]!,
                    "date":date
                ]
            ]
        ]
        functions.getCollection(data: data, onCompleteWithData: {d,e in
            if d != nil {
                
                for i in d as! [[String:Any]] {
                    let id = i["id"] as! String
                    let content = i["content"] as! [String:Any]
                    
                    self.ads.append(AdsItem(training_title: content["training_title"] as? String ?? "", repetition: content["repetition"] as? String ?? "", price: content["price"] as? String ?? "",start_time: content["start_time"] as? String ?? "",end_time: content["end_time"] as? String ?? "",record_id:id, isActive: content["isActive"] as? Bool ?? true,equipments: content["equipments"] as? String ?? "",
                                            date: content["date"] as? String ?? ""))
                }
                DispatchQueue.main.async {
                    self.adsTable.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.hideIndicator()
            }
        })
    }
    func getAdsById(id:[String]) {
        self.ads.removeAll()
        if id .count > 0 {
            let data:Any = [
                "where": [
                    "collectionName":"ads",
                    "or":[
                        "id":id
                    ]
                ]
            ]
            functions.getCollection(data: data, onCompleteWithData: {d,e in
                if d != nil {
                    
                    for i in d as! [[String:Any]] {
                        let id = i["id"] as! String
                        let content = i["content"] as! [String:Any]
                        
                        self.ads.append(AdsItem(training_title: content["training_title"] as? String ?? "", repetition: content["repetition"] as? String ?? "", price: content["price"] as? String ?? "",start_time: content["start_time"] as? String ?? "",end_time: content["end_time"] as? String ?? "",record_id:id, isActive: content["isActive"] as? Bool ?? true,equipments: content["equipments"] as? String ?? "",date: content["date"] as? String ?? ""))
                    }
                }
                DispatchQueue.main.async {
                    self.adsTable.reloadData()
                    self.hideIndicator()
                }
            })
        }else {
            DispatchQueue.main.async {
                self.adsTable.reloadData()
                self.hideIndicator()
            }
        }
    }
    func deleteRecord(id:String){
        let data : Any = [
            "where": [
                "collectionName": "ads",
                "or": [
                    "id": id
                ]
            ]
        ]
        functions.delete(data: data, onCompleteBool: {s,e in
            if s! {
                self.deleteAdsDateRecord(id: id)
            }
        })
    }
    func deleteAdsDateRecord(id:String){
        let data : Any = [
            "where": [
                "collectionName": "adsDates",
                "or": [
                    "ads_id": id
                ]
            ]
        ]
        functions.delete(data: data, onCompleteBool: {s,e in
            print(s!)
            self.eventDates.removeAll()
            self.getTrainerDates(date: self.dateString)
        })
    }
    func deactivate(id:String,activate:Bool){
        let data : Any = [
            "where": [
                "collectionName": "ads",
                "and": [
                    "id": id
                ]
            ],
            "fields":[
                [
                    "field": "isActive",
                    "value": activate
                ]
            ]
        ]
        functions.update(data: data, onCompleteBool: {s,e in
            print(s!)
        })
    }
    
    @IBAction func dateChangeds(_ sender: Any) {
        let picker = sender as! UIDatePicker
        print("Selected Date: \(Statics.formatDate(date: picker.date))")
    }
    var previousMonth: Int?
    @objc func dateChanged(_ sender: UIDatePicker) {
            let calendar = Calendar.current
            let selectedMonth = calendar.component(.month, from: sender.date)

            if selectedMonth != previousMonth {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM yyyy" // Example: "February 2025"
                let monthString = formatter.string(from: sender.date)
                
                print("📆 Month changed to: \(monthString)")
                
                previousMonth = selectedMonth // Update previous month
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
extension AdsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "adsCell") as? AdsCell else {
            return UITableViewCell()
        }
        cell.configure(with: ads[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let record_id=ads[indexPath.row].record_id
            functions.createAlert(self: self, title: String(localized:"delete"), message: String(localized:"delete_ask"), yesNo: true, alertReturn: { (yesNo) in
                if yesNo! {
                    self.deleteRecord(id: record_id!)
                    self.ads.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                }
            })
           
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AdsCell {
            cell.backgroundColor = UIColor(named: "DarkCellBack")
          }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AdsCell {
            cell.backgroundColor = UIColor.clear
          }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var adsItem = ads[indexPath.row]
        selectedAd = adsItem.isActive!
        selectedIndexAd = indexPath.row
        tPickerItems.removeAll()
        selectedAdId = adsItem.record_id!
        let t = selectedAd ? String(localized:"deactivate") : String(localized:"activate")
        tPickerItems.append(t)
        tPickerItems.append(String(localized:"add_new_time"))
        tpicker.reloadAllComponents()
        selectedTextField = textField
        
        sData = adsItem.toNSDictionary()
        textField.becomeFirstResponder()
//        let m = a ? String(localized:"deactivate_ads") : String(localized:"activate_ads")
//        functions.createAlert(self: self, title: t, message: m, yesNo: true, alertReturn: { (yesNo) in
//            if yesNo! {
//                ads.isActive = !a
//                self.ads[indexPath.row] = ads
//                DispatchQueue.main.async {
//                    self.adsTable.reloadData()
//                }
//                self.deactivate(id: ads.record_id!, activate: !a)
//            }
//        })
    }
}
extension AdsViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tPickerItems.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(tPickerItems[row])
    }
    
}

//
//  TrainingDetails.swift
//  trainig
//
//  Created by omer yildirim on 6.02.2025.
//

import UIKit
import FSCalendar
class TrainingDetails: UIViewController,FSCalendarDelegate,FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return eventDates.contains(date) ? 1 : 0
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let d =  Statics.createDate(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date))
        selectedDate = d
        
        for i in 0..<times.count{
            times[i].selected = false
        }
        var gotIn:Bool = false
        cds.enumerated().forEach { (i, c) in
            if selectedDate == c.date{
                gotIn = true
                if let index = times.firstIndex(where: { $0.item == c.time }) {
                    times[index].selected = c.selected
                    let contains:Bool = self.soldItems.contains(where: { $0.startDate == c.startDate && $0.endDate == c.endDate})
                    times[index].hide = contains
                }
                
            }
        }
        if !gotIn{
            tCount = 0
        }else{
            tCount = times.count
        }
        timeCollection.reloadData()
    }
    var tCount:Int=0
    var selectedDate:Date!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var timeCollection: UICollectionView!
    @IBOutlet weak var photo: RoundedImage!
    @IBOutlet weak var trainerNameTxt: UILabel!
    @IBOutlet weak var ratingTxt: UILabel!
    @IBOutlet weak var trainerTitleTxt: UILabel!
    @IBOutlet weak var priceTxt: UILabel!
    @IBOutlet weak var durationTxt: UILabel!
    @IBOutlet weak var equipmentsTxt: UILabel!
    var trainerId:String!
    var trainerName:String!
    var trainerTitle:String!
    var price:String!
    var duration:String!
    var rating:String!
    var equipments:String!
    var trainerPhoto:Any!
    var ads_id:String!
    var startDate:Int64!
    var endDate:Int64!
    var times: [AdsTimeItem] = []
    var cds:[CalendarTimeAndDate] = []
    let functions = Functions()
    var trainingTime:String!
    var userData:NSDictionary!
    var soldItems:[SoldItem]=[]
    var selectedTimeIndexPathRow:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData = CacheData.getUserData()!
        getSold()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.today = nil
        trainerNameTxt.text = trainerName
        trainerTitleTxt.text = trainerTitle
        let imageUrl:String? = trainerPhoto as? String ?? nil
        if let urlString = imageUrl, let url = URL(string: urlString) {
            photo.kf.setImage(with: url, placeholder: UIImage(named: "person"))
        } else {
            photo.image = UIImage(named: "person")
        }
        priceTxt.text = price
        durationTxt.text = duration
        ratingTxt.text = rating
        equipmentsTxt.text = equipments
        
        timeCollection.delegate = self
        timeCollection.dataSource = self
        self.timeCollection.register(UINib(nibName: "AdsTimeCell", bundle: nil), forCellWithReuseIdentifier: "timeCell")
        trainingTime = "\(Statics.formatTimeFromLong(timestamp: startDate)) - \(Statics.formatTimeFromLong(timestamp: endDate))"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Buy", style: .plain, target: self, action: #selector(buy))
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    @objc func buy(_ button: UIBarButtonItem?) {
        
        var contents:[Any] = []
        let selected = cds.filter { $0.selected }
        if selected.count == 0 {
            functions.createAlert(self: self, title: String(localized:"error"), message: String(localized: "select_time"), yesNo: false, alertReturn: { result in
                                  
                })
            return
        }
        let ind = self.view.showLoader(nil)
        ind!.lbl.text = String(localized: "wait")
        for i in selected {
            let d = Statics.formatDate(date: i.date)
            let t = i.time.components(separatedBy: "-")
            let sDate = Statics.convertToTimestamp(dateString: "\(d) \(t[0])")
            let eDate = Statics.convertToTimestamp(dateString: "\(d) \(t[1])")
            let cdata : Any = [
                "collectionName":"sold",
                "content":[
                    "userId":userData["id"] as! String,
                    "trainerId":trainerId!,
                    "training_title":self.trainerTitle!,
                    "trainer_name":self.trainerName!,
                    "token":"",
                    "isActive":true,
                    "startDate":sDate!,
                    "endDate":eDate!,
                    "ads_id":self.ads_id!
                ]
            ]
            contents.append(cdata)
        }
        let data : Any = ["contents":contents]
        functions.addMultipleCollection(data: data, onCompleteBool: {s,e in
            print(s!)
            DispatchQueue.main.async {
                self.view.dismissLoader()
                self.getSold()
            }
        })
       
    }
    func getReserved(_ reserveKey:String){
        let data : Any = [
            "where": [
                "collectionName": "reserved",
                "and": [
                    "reserveKey":reserveKey,
                ]
            ]
        ]
        functions.getCollection(data: data, onCompleteWithData: {d,e in
            if d != nil {
                if (d as! NSArray).count>0 {
                    for i in d as! NSArray{
                        let collection = i as! NSDictionary
                        let content = collection["content"] as! NSDictionary
                        let time = content["time"] as! Int64
                        let check:Bool = Statics.checkMinsDifference(from: TimeInterval(time))
                        if !check {
                            DispatchQueue.main.async {
                                self.functions.createAlert(self: self, title: String(localized:"error"), message: String(localized: "error_adding_reservation"), yesNo: false, alertReturn: { result in
                                })
                                self.times[self.selectedTimeIndexPathRow].hide = true
                                self.timeCollection.reloadData()
                            }
                            return
                        }
                    }
                }
            }
            self.addReserved(reserveKey)
        })
    }
    func removeReserved(_ reserveKey:String){
        let data : Any = [
            "where": [
                "collectionName": "reserved",
                "and": [
                    "reserveKey":reserveKey,
                ]
            ]
        ]
        functions.delete(data: data, onCompleteBool: {s,e in
            print(s!)
        })
    }
    func addReserved(_ reserveKey:String){
        let now = Statics.currentTimeInMilliSeconds()
        let data : Any = [
            "collectionName":"reserved",
            "content":[
                "time": now,
                "reserveKey":reserveKey,
                "uniqueFields":["reserveKey"]
            ]
        ]
        functions.addUniqueCollection(data: data, onCompleteBool: {s,e in
            if s! == false {
                DispatchQueue.main.async {
                    self.functions.createAlert(self: self, title: String(localized:"error"), message: String(localized: "error_adding_reservation"), yesNo: false, alertReturn: { result in
                    })
                    self.times[self.selectedTimeIndexPathRow].hide = true
                    self.timeCollection.reloadData()
                }
            }
        })
    }
    func startUpdates(contents:[Any]) {
        let group = DispatchGroup()
        for i in contents {
            let d = i as! NSDictionary
            let c = d["content"] as! NSDictionary
            group.enter()
            DispatchQueue.global().async {
                print("Started \(c["startDate"] as! Int64)")
                //self.updateSold(c["startDate"] as! Int64)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("All updates completed. Proceeding to the next step!")
        }
    }
    func getSold(){
        let data : Any = [
            "where": [
                "collectionName": "sold",
                "and": [
                    "ads_id": self.ads_id!,
                ]
            ]
        ]
        functions.getCollection(data: data, onCompleteWithData: {d,e in
            if d != nil {
                if (d as! NSArray).count>0 {
                    for i in d as! NSArray{
                        let collection = i as! NSDictionary
                        let content = collection["content"] as! NSDictionary
                        let startDate = content["startDate"] as? Int64 ?? 0
                        let endDate = content["endDate"] as? Int64 ?? 0
                        let id = collection["id"] as! String
                        self.soldItems.append(SoldItem(id: id, startDate: startDate, endDate: endDate))
                    }
                }
            }
            DispatchQueue.main.async {
                self.eventDates.removeAll()
                self.cds.removeAll()
                self.times.removeAll()
                self.adsCalendar.removeAll()
                self.getTrainerDates()
            }
        })
    }
    var eventDates: [Date] = []
    var adsCalendar:[AdsICalendarItem] = []
    func getTrainerDates(){
        //let d = date.components(separatedBy: "-")
        let data:Any = [
            "where": [
                "collectionName":"adsDates",
                "and":[
                    "trainer_id":trainerId!,
                    "ads_id":ads_id!,
                    "isSold":false,
                    "isReserved":false
                ]
            ]
        ]
        functions.getCollection(data: data, onCompleteWithData: { d,e in
            if d != nil {
                if (d as! NSArray).count>0 {
                   for i in d as! NSArray{
                       let collection = i as! NSDictionary
                       let content = collection["content"] as! NSDictionary
                       var startTime = content["startTime"] as! Int64
                       var endTime = content["endTime"] as! Int64
                       let ads_id = content["ads_id"] as! String
                       let sDate = content["startDate"] as! String
                       let eDate = content["endDate"] as! String
                       let strDate = "\(sDate) - \(eDate)"
                       let repetition_period = content["repetition_period"] as! String
                       let contains:Bool = self.soldItems.contains(where: { $0.startDate == startTime && $0.endDate == endTime})
                       var date = Statics.createDate(year: Int(content["year"] as! String)!, month: Int(content["month"] as! String)!, day: Int(content["day"] as! String)!)
                       let key:String = "\(ads_id)_\(startTime)_\(endTime)"
                       self.times.append(AdsTimeItem(item: strDate, selected: false, reserveKey: key,hide:false))
                       self.cds.append(CalendarTimeAndDate(date: date,time: strDate, selected: false,startDate: startTime,endDate: endTime))
                       if !contains{
                           self.eventDates.append(date)
                           let aci = AdsICalendarItem(ads_id: ads_id, repetition: repetition_period,date: date)
                           self.adsCalendar.append(aci)
                       }
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
                           for _ in 0..<period{
                               date = Calendar.current.date(byAdding: item, value: addItem, to: date)!
                               let dstr = Statics.formatDate(date: date)
                               let startDTimeStr = "\(dstr) \(content["startDate"] as! String)"
                               let endDTimeStr = "\(dstr) \(content["endDate"] as! String)"
                               let startTime2 = Statics.convertToTimestamp(dateString:startDTimeStr)
                               let endTime2 = Statics.convertToTimestamp(dateString:endDTimeStr)
                               let contains:Bool = self.soldItems.contains(where: { $0.startDate == startTime2 && $0.endDate == endTime2})
                               self.cds.append(CalendarTimeAndDate(date: date,time: strDate, selected: false,startDate: startTime2,endDate: endTime2))
                               if !contains {
                                   let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
                                   date = Statics.createDate(year: components.year!, month: components.month!, day: components.day!)
                                   self.eventDates.append(date)
                                   let aci = AdsICalendarItem(ads_id: ads_id, repetition: repetition_period,date: date)
                                   self.adsCalendar.append(aci)
                               }
                           }
                       }
                       
                    }
                    DispatchQueue.main.async {
                        self.calendar.reloadData()
                        DispatchQueue.main.async {
                            self.calendar.allowsSelection = true
                            let selectedDate = Date()
                            self.calendar.select(selectedDate)
                            self.calendar(self.calendar, didSelect: Date(), at: .current)
                        }
                    }
                }
            }else{
               
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
extension TrainingDetails: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return tCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as? AdsTimeCell else { return UICollectionViewCell() }
        let i = times[indexPath.row]
        cell.configure(with: i)
        cell.back.alpha =  i.hide ? 0.5 : 1.0
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! AdsTimeCell
        selectedTimeIndexPathRow = indexPath.row
        if times[indexPath.row].hide {return}
        let rk = times[indexPath.row].reserveKey
        times[indexPath.row].selected.toggle()
        if times[indexPath.row].selected{
            getReserved(rk!)
        }else{
            removeReserved(rk!)
        }
        cds.enumerated().forEach { (i, c) in
            if selectedDate == c.date{
                if c.time == times[indexPath.row].item{
                    cds[i].selected = times[indexPath.row].selected
                }
                
            }
        }
        
        cell.setBack(with: times[indexPath.row])
        //InterestCollection.reloadData()
    }
    
}

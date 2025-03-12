//
//  AdsViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit
import FSCalendar

class CalendarController: UIViewController,FSCalendarDelegate,FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate=Statics.formatDate(date: date)
//        let d =  Statics.createDate(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date))
//        var seenIds: Set<String> = []
//        let ads_id=self.adsCalendar.filter { $0.date == d && seenIds.insert($0.ads_id).inserted }.map { $0.ads_id }
        getSold(selectedDate)
        
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//        let currentPageDate = calendar.currentPage
//        let month = Calendar.current.component(.month, from: currentPageDate)
//        let year = Calendar.current.component(.year, from: currentPageDate)
//        let mStr=month<10 ? "0"+String(month):String(month)
//        dateString = "00-"+mStr+"-"+String(year)
//        getTrainerDates(date: dateString)
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return eventDates.contains(date) ? 1 : 0
    }
    
    
    
    @IBOutlet weak var calendarTable: UITableView!
    @IBOutlet weak var picker: UIDatePicker!
    
    @IBOutlet weak var calendar: FSCalendar!
    var items: [CalendarItem] = []
    var userData:NSMutableDictionary!
    let functions = Functions()
    var eventDates: [Date] = []
    var selectedDate:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarTable.delegate = self
        calendarTable.dataSource = self
        calendar.delegate = self
        calendar.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        userData = CacheData.getUserData()!
        getSoldDates()
    }
    func getSoldDates(){
        let now = Statics.currentTimeInMilliSeconds()
        let data : Any = [
            "usid":userData["id"],
            "start":now
        ]
        functions.executeUserSolDates(data: data, onCompleteWithData: {d,e in
            let resData=d as? NSArray ?? []
            if e!.isEmpty {
                for item in resData{
                    let itemTop = item as! NSDictionary
                    let fulldate = itemTop["fulldate"] as! String
                    let dateArray = fulldate.components(separatedBy: "-")
                    let year = Int(dateArray[2])!
                    let month = Int(dateArray[1])!
                    let day = Int(dateArray[0])!
                    let date = Statics.createDate(year: year, month: month, day: day)
                    self.eventDates.append(date)
                }
                DispatchQueue.main.async {
                    self.calendar.reloadData()
                }
            }else{
                if e == PostGet.no_connection {
                    DispatchQueue.main.async {
                        PostGet.noInterneterror(v: self)
                    }
                }
                
            }
        })
    }
    func getSold(_ dateString:String){
        items.removeAll()
        self.calendarTable.reloadData()
        let data : Any = [
            "usid":userData["id"],
            "selected_date":dateString
        ]
        functions.executeUserBought(data: data, onCompleteWithData: {d,e in
            let resData=d as? NSArray ?? []
            if e!.isEmpty {
                for item in resData{
                    let itemTop = item as! NSDictionary
                    let content = itemTop["content"] as! NSDictionary
                    let adscontent = itemTop["adscontent"] as! NSDictionary
                    let usercontent = itemTop["usercontent"] as! NSDictionary
                    let training_name = adscontent["training_title"] as? String ?? ""
                    let trainer_name = usercontent["name"] as? String ?? ""
                    let startD = content["startDate"] as! Int64
                    let endD = content["endDate"] as! Int64
                    let startHHmm = Statics.formatTimeFromLong(timestamp: startD)
                    let endHHmm = Statics.formatTimeFromLong(timestamp: endD)
                    let strdate = Statics.formatDateFromLong(timestamp: startD)
                    let time = "\(strdate) \(startHHmm) - \(endHHmm) "
                    let adsIsActive = adscontent["isActive"] as! Bool
                    //let photo = usercontent["photo"]
                    if !self.items.contains(where: { $0.time == time && $0.trainer_name == trainer_name }){
                        self.items.append(CalendarItem(trainer_name: trainer_name, training_name: training_name, time: time, isActive: adsIsActive))
                    }
                }
                DispatchQueue.main.async {
                    self.calendarTable.reloadData()
                }
            }else{
                if e == PostGet.no_connection {
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
extension CalendarController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cCell") as? CalendarCell else {
            return UITableViewCell()
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CalendarCell {
            cell.backgroundColor = UIColor(named: "DarkCellBack")
          }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CalendarCell {
            cell.backgroundColor = UIColor.clear
          }
    }
}

//
//  AdsViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit

class AdsViewController: UIViewController,indicatorDelegate,PassDataDelegate {
    func passData(data: Any) {
        let d = data as! NSDictionary
        let content = d["content"] as! NSDictionary
        let date=content["date"] as! String
        
        functions.addCollection(data: data as! [String : Any], onCompleteBool: { success,error in
            if success! {
                print(success!)
            }else{
                print(error!)
            }
            self.addTrainerAdsDate(date: date)
            self.getAds()
            
        })
    }
    
    func showIndicator() {
        let ind = self.view.showLoader(nil) as? Indicator
        ind!.lbl.text=String(localized:"wait")
    }
    
    func hideIndicator() {
        self.view.dismissLoader()
    }
    func addTrainerAdsDate(date: String){
        let d = date.components(separatedBy: "-")
        let data:Any = [
            "collectionName":"adsDates",
            "content":[
                "trainer_id":userData["id"]! as! String,
                "day":d[0],
                "month":d[1],
                "year":d[2],
                "fulldate":date
            ]
        ]
        let checkData:Any = [
            "where": [
                "collectionName":"adsDates",
                "and":[
                    "trainer_id":userData["id"]!,
                    "fulldate":date
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
        functions.addCollection(data: data, onCompleteBool: { success,error in
            print(success!)
        })
    }
    @IBOutlet weak var adsTable: UITableView!
    @IBOutlet weak var picker: UIDatePicker!
    
    var ads: [AdsItem] = []
    let functions = Functions()
    var userData:NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = CacheData.getUserData()!
        //addData()
        picker.overrideUserInterfaceStyle = .dark
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        previousMonth = Calendar.current.component(.month, from: picker.date)

        adsTable.delegate = self
        adsTable.dataSource = self
        getAds()
        // Do any additional setup after loading the view.
    }
    @IBAction func adAds_cl(_ sender: Any) {
        let fc=storyboard?.instantiateViewController(withIdentifier: "sch") as! Schedule
        fc.indicatorDelegate=self
        fc.passDataDelegate=self
        present(fc, animated: true)
    }
    func getAds() {
        self.ads.removeAll()
        var date=Statics.formatDate(date: Date())
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
                    
                    self.ads.append(AdsItem(training_name: content["training_title"] as? String ?? "", _repeat: content["repetition"] as? String ?? "", price: content["price"] as? String ?? "", isActive: content["isActive"] as? Bool ?? true,record_id:id))
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
            print(s!)
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
            deleteRecord(id: record_id!)
            ads.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        var ads = ads[indexPath.row]
        let a = ads.isActive!
        let t = a ? String(localized:"deactivate") : String(localized:"activate")
        let m = a ? String(localized:"deactivate_ads") : String(localized:"activate_ads")
        functions.createAlert(self: self, title: t, message: m, yesNo: true, alertReturn: { (yesNo) in
            if yesNo! {
                ads.isActive = !a
                self.ads[indexPath.row] = ads
                DispatchQueue.main.async {
                    self.adsTable.reloadData()
                }
                self.deactivate(id: ads.record_id!, activate: !a)
            }
        })
    }
}

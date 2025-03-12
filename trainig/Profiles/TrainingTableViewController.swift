//
//  TrainingTableViewController.swift
//  trainig
//
//  Created by omer yildirim on 2.02.2025.
//

import UIKit

class TrainingTableViewController: UITableViewController {
    var trainings: [RecommendedItem] = []
    var userData : NSMutableDictionary!
    let functions = Functions()
    let refreshControler = UIRefreshControl()
    var forTrainer: Bool = true
    var ads: [AdsItem] = []
    var searchList: [RecommendedItem] = []
    var id: String!
    var delegate:CallMainDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
            ]
        refreshControler.attributedTitle = NSAttributedString(string:String(localized:"wait"), attributes: attributes)
        refreshControler.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControler
        userData = CacheData.getUserData()!
        if forTrainer{
            getSoldTrainings()
        }else {
            getAds()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @objc func refreshData() {
        self.trainings.removeAll()
        getSoldTrainings()
    }
    override func viewWillAppear(_ animated: Bool) {
       
        if forTrainer{
            getSoldTrainings()
        }else {
            getAds()
        }
        //trainings.removeAll()
        //loadtrainings()
    }
    func getAds(){
        self.searchList.removeAll()
        self.ads.removeAll()
        functions.getAdsFromSearcService(text: self.id, onCompleteWithData: { (data,error) in
            if error == PostGet.no_connection {
                DispatchQueue.main.async {
                    PostGet.noInterneterror(v: self)
                    self.view.dismissLoader()
                }
                return
            }
            DispatchQueue.main.async {
                self.loadsearchList(data as! [NSDictionary])
                self.view.dismissLoader()
            }
            
        })
    }
    func loadsearchList(_ data:[NSDictionary]){
        searchList.removeAll()
        if data.count==0{
            self.tableView.reloadData()
            return
        }
        for item in data{
            let time = Statics.formatDateWithTimeFromLong(timestamp: item["trainingstartdate"] as! Int64)
            let duration = Statics.getTimeDifference(start: item["trainingstartdate"] as! Int64,end:item["trainingenddate"] as! Int64)
            let startD = item["trainingstartdate"] as! Int64
            let endD = item["trainingenddate"] as! Int64
            let startHHmm = Statics.formatTimeFromLong(timestamp: startD)
            let endHHmm = Statics.formatTimeFromLong(timestamp: endD)
            let strdate = Statics.formatDateFromLong(timestamp: startD)
            searchList.append(RecommendedItem(training_name: item["trainingtopic"] as? String, trainer_name: item["trainername"] as? String, duration: duration, time: time, photo: item["trainerphoto"], rating: item["trainerrating"] as? Float,trainerId: item["trainerid"] as? String,trainer_title:item["trainertitle"] as? String,price:"₺ \(String((item["trainingprice"] as? Int)!))",equipments: item["trainingequipments"] as? String,ads_id: item["ads_id"] as? String,startDate: item["trainingstartdate"] as? Int64 ?? 0,endDate: item["trainingenddate"] as? Int64 ?? 0))
            self.ads.append(AdsItem(training_title: item["trainertitle"] as? String ?? "", repetition: item["trainingreps"] as? String ?? "", price: "₺ \(String((item["trainingprice"] as? Int)!))",start_time: startHHmm,end_time: endHHmm,record_id:"", isActive: true,equipments: item["trainingequipments"] as? String,date: strdate))
        }
        self.tableView.reloadData()
    }
    
    func getSoldTrainings(){
        self.trainings.removeAll()
        let now = Statics.currentTimeInMilliSeconds()
        let data : Any = [
            "tid":userData["id"],
            "start":now
        ]
        functions.executeTrainerSold(data: data, onCompleteWithData: { d,e in
            let resData=d as? NSArray ?? []
            if e!.isEmpty {
                for item in resData{
                    let itemTop = item as! NSDictionary
                    let content = itemTop["content"] as! NSDictionary
                    let startD = content["startDate"] as! Int64
                    let endD = content["endDate"] as! Int64
                    let startHHmm = Statics.formatTimeFromLong(timestamp: startD)
                    let endHHmm = Statics.formatTimeFromLong(timestamp: endD)
                    let strdate = Statics.formatDateFromLong(timestamp: startD)
                    
//                    let adscontent = itemTop["adscontent"] as! NSDictionary
//                    let usercontent = itemTop["usercontent"] as! NSDictionary
                    let training_name = content["training_title"] as? String ?? ""
                    let name = itemTop["name"] as? String ?? ""
                    let time = "\(strdate) \(startHHmm) - \(endHHmm) "
                    let photo = itemTop["photo"]
                    if !self.trainings.contains(where: { $0.time == time }){
                        self.trainings.append(RecommendedItem( training_name:training_name,trainer_name: name, duration: "", time: time,photo: photo,rating:0))
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControler.endRefreshing()
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
    func loadtrainings(){
        trainings.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "35 min(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        trainings.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "30 min(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        trainings.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "1 hour(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        trainings.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "1,5 hour(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        trainings.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "40 min(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forTrainer {
            return trainings.count
        }
        return ads.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if forTrainer {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recCell", for: indexPath) as! RecommendedCell

            cell.configureNoDuration(with: trainings[indexPath.row])

            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "adsCell") as? AdsCell else {
                return UITableViewCell()
            }
            cell.configure(with: ads[indexPath.row])
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor =  UIColor(named: "DarkCellBack")
        }
//        if let cell = tableView.cellForRow(at: indexPath) as? AdsCell {
//            cell.backgroundColor = UIColor(named: "DarkCellBack")
//          }
//        if let cell = tableView.cellForRow(at: indexPath) as? RecommendedCell {
//            cell.backgroundColor = UIColor(named: "DarkCellBack")
//          }
    }
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.black
        }
//        if let cell = tableView.cellForRow(at: indexPath) as? AdsCell {
//            cell.backgroundColor = UIColor.black
//          }
//        if let cell = tableView.cellForRow(at: indexPath) as? RecommendedCell {
//            cell.backgroundColor = UIColor.black
//          }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if forTrainer { return }
        let item = searchList[indexPath.row]
        let n = storyboard?.instantiateViewController(withIdentifier: "tDetails") as! TrainingDetails
        n.trainerId = item.trainerId
        n.trainerName = item.trainer_name
        n.trainerTitle = item.trainer_title
        n.trainerPhoto = item.photo
        n.rating = String(format: "%.1f", item.rating)
        n.price = item.price
        n.duration = item.duration
        n.equipments = item.equipments
        n.ads_id = item.ads_id
        n.startDate = item.startDate
        n.endDate = item.endDate
        n.title = item.training_name
        delegate.callMain(viewController: n)
        
       
        

    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

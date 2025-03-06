//
//  UpcomingTrainer.swift
//  trainig
//
//  Created by omer yildirim on 13.02.2025.
//

import UIKit
import Kingfisher
class UpcomingTrainer: UIViewController {

    @IBOutlet weak var profile_photo: RoundedImage!
    @IBOutlet weak var tableView: UITableView!
    var userData:NSMutableDictionary!
    var upcomingList:[UpcomingTrainerItem] = []
    let functions = Functions()
    @IBOutlet weak var fullname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        userData=CacheData.getUserData()!
        tableView.dataSource = self
        tableView.delegate = self
        getUpcomingData(ind:true)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        userData=CacheData.getUserData()!
        
        let imageUrl:String? = userData["photo"] as? String ?? nil
        if let urlString = imageUrl, let url = URL(string: urlString) {
            profile_photo.kf.setImage(with: url, placeholder: UIImage(named: "person"))
        } else {
            profile_photo.image = UIImage(named: "person")
        }
        fullname.text=String(localized:"hi") + "! " + (userData["name"] as! String)
    }
    func getUpcomingData(ind:Bool){
        if ind{
            self.view.showLoader(String(localized:"wait"))
        }
        let now = Statics.currentTimeInMilliSeconds()
        let d = Date()
        let afterThreeDaysDate = Calendar.current.date(byAdding: .day, value: 3, to: d)
        let afterThreeDaysDateInMilliSeconds = Statics.currentTimeInMilliSeconds(date: afterThreeDaysDate!)
        let dta:Any=[
            "tid":userData["id"],
            "start":now,
            "finish":afterThreeDaysDateInMilliSeconds
        ]
        functions.executeTrainerUpcoming(data: dta, onCompleteWithData: { (contentData,error) in
            let resData=contentData as? NSArray ?? []
            if error!.isEmpty {
                for item in resData{
                    let itemTop = item as! NSDictionary
                    let content = itemTop["content"] as! NSDictionary
                    let adscontent = itemTop["adscontent"] as! NSDictionary
                    let usercontent = itemTop["usercontent"] as! NSDictionary
                    let training_name = adscontent["training_title"] as? String ?? ""
                    let username = usercontent["name"] as? String ?? ""
                    let photo = usercontent["photo"]
                    let startD = content["startDate"] as! Int64
                    let endD = content["endDate"] as! Int64
                    let startHHmm = Statics.formatTimeFromLong(timestamp: startD)
                    let endHHmm = Statics.formatTimeFromLong(timestamp: endD)
                    let strdate = Statics.formatDateFromLong(timestamp: startD)
                    
                    let time = "\(strdate) \(startHHmm) - \(endHHmm) "
                    
                    if !self.upcomingList.contains(where: { $0.time == time && $0.username == username }){
                        self.upcomingList.append(UpcomingTrainerItem( training_name:training_name,username: username, duration: "", time: time,photo: photo))
                    }
                   
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.dismissLoader()
                }
            }else{
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
extension UpcomingTrainer: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "upCell") as? UpcomingTableCell else {
            return UITableViewCell()
        }
        cell.configure(with: upcomingList[indexPath.row])
        return cell
    }
}

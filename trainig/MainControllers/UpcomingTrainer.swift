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
    var userData:NSDictionary!
    var list:[UpcomingTrainerItem] = []
    @IBOutlet weak var fullname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
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
    func addData(){
        
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
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "upCell") as? UpcomingTableCell else {
            return UITableViewCell()
        }
        cell.configure(with: list[indexPath.row])
        return cell
    }
}

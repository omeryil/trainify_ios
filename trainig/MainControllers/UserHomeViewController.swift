//
//  UserHomeViewController.swift
//  trainig
//
//  Created by omer yildirim on 1.02.2025.
//

import UIKit
import Kingfisher

class UserHomeViewController: UIViewController {

    @IBOutlet weak var recommendedTable: UITableView!
    @IBOutlet weak var upcomingCollection: UICollectionView!
    
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var profile_image: RoundedImage!
    var upcomingList: [UpcomingItem] = []
    var recommendedList: [RecommendedItem] = []
    var userData:NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        upcomingCollection.delegate = self
        upcomingCollection.dataSource = self
        
        recommendedTable.delegate = self
        recommendedTable.dataSource = self
        
        loadUpcomingList()
        loadrecommendedList()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: self.view.frame.width*0.8, height: 122)
        upcomingCollection.collectionViewLayout=layout
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        userData=CacheData.getUserData()!
        let imageUrl:String? = userData["photo"] as? String ?? nil
        if let urlString = imageUrl, let url = URL(string: urlString) {
            profile_image.kf.setImage(with: url, placeholder: UIImage(named: "person"))
        } else {
            profile_image.image = UIImage(named: "person")
        }
        fullname.text=String(localized:"hi") + "! " + (userData["name"] as! String)
    }
    func loadUpcomingList(){
        upcomingList.append(UpcomingItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "", time: "22/01 10:30 - 11:00",photo: "acb"))
        upcomingList.append(UpcomingItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "", time: "22/01 10:30 - 11:00",photo: "acb"))
        upcomingList.append(UpcomingItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "", time: "22/01 10:30 - 11:00",photo: "acb"))
        upcomingList.append(UpcomingItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "", time: "22/01 10:30 - 11:00",photo: "acb"))
        upcomingList.append(UpcomingItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "", time: "22/01 10:30 - 11:00",photo: "acb"))
    }
    func loadrecommendedList(){
        recommendedList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "35 min(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        recommendedList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "30 min(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        recommendedList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "1 hour(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        recommendedList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "1,5 hour(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        recommendedList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "40 min(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
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
extension UserHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upCell", for: indexPath) as? UpcomingCell else {
            return UICollectionViewCell()
            
        }
        cell.configure(with: upcomingList[indexPath.row])
        return cell
        
    }
    
    
}
extension UserHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recCell", for: indexPath) as? RecommendedCell else {
            return UITableViewCell()
        }
        cell.configure(with: recommendedList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RecommendedCell {
            cell.backgroundColor = UIColor(named: "DarkCellBack")
          }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RecommendedCell {
            cell.backgroundColor = UIColor.clear
          }
    }
          
    
}

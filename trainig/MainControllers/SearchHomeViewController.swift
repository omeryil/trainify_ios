//
//  SearchHomeViewController.swift
//  trainig
//
//  Created by omer yildirim on 1.02.2025.
//

import UIKit

class SearchHomeViewController: UIViewController {
    @IBOutlet weak var InterestCollection: UICollectionView!
    @IBOutlet weak var recommendedTable: UITableView!
    
    var recommendedList: [RecommendedItem] = []
    var interestsList:[InterestItem]=[]
    var ints:[String]=["Hiking","Swimming","Reading","CookingCooking","Traveling","Hiking","Swimming","Reading"]
    override func viewDidLoad() {
        super.viewDidLoad()
        addData()
        loadrecommendedList()
        
        
        InterestCollection.dataSource=self
        InterestCollection.delegate=self
        
        recommendedTable.delegate = self
        recommendedTable.dataSource = self
        
        self.InterestCollection.register(UINib(nibName: "InterestsCell", bundle: nil), forCellWithReuseIdentifier: "intCell")
    }
    func addData(){
        for i in ints{
            interestsList.append(InterestItem(interest: i,selected: false ))
        }
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
extension SearchHomeViewController:UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return interestsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "intCell", for: indexPath) as? InterestsCell else { return UICollectionViewCell() }
        let i = interestsList[indexPath.row]
        
        cell.configure(with: i)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let attributedString = NSAttributedString(string: interestsList[indexPath.row].interest)
        let size = CGSizeMake(attributedString.size().width, 40)
        return size
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let cell = collectionView.cellForItem(at: indexPath) as! InterestsCell
        interestsList[indexPath.row].selected.toggle()
        cell.setBack(with: interestsList[indexPath.row])
        //InterestCollection.reloadData()
    }
    
    
}
extension SearchHomeViewController: UITableViewDelegate, UITableViewDataSource {
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

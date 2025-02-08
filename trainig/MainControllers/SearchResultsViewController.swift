//
//  SearchHomeViewController.swift
//  trainig
//
//  Created by omer yildirim on 1.02.2025.
//

import UIKit

class SearchResultsViewController: UIViewController,filterDelegate {
    func returnFilter(filter: FilterItem) {
        self.filterItem=filter
        print(filter)
    }
    var filterItem = FilterItem()
    @IBOutlet weak var recommendedCollection: UICollectionView!
    @IBOutlet weak var searchResultTable: UITableView!
    
    var searchList: [RecommendedItem] = []
    var recommendedList:[RecommendedItem]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        addData()
        loadsearchList()
        
        
        recommendedCollection.dataSource=self
        recommendedCollection.delegate=self
        
        searchResultTable.delegate = self
        searchResultTable.dataSource = self
        
        self.recommendedCollection.register(UINib(nibName: "recHorCell", bundle: nil), forCellWithReuseIdentifier: "intCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: self.view.frame.width*0.8, height: 152)
        recommendedCollection.collectionViewLayout=layout
    }
    func addData(){
        recommendedList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "35 min(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        recommendedList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "30 min(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        recommendedList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "1 hour(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        recommendedList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "1,5 hour(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        recommendedList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "40 min(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
    }
    func loadsearchList(){
        searchList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "35 min(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        searchList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "30 min(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        searchList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "1 hour(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        searchList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "1,5 hour(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
        searchList.append(RecommendedItem( training_name:"Stretching",trainer_name: "Clara Schmidt", duration: "40 min(s)", time: "22/01 10:30 - 11:00",photo: "acb",rating:4.5))
    }
    @IBAction func filter_cl(_ sender: Any) {
        let fc=storyboard?.instantiateViewController(withIdentifier: "fltr") as! Filter
        fc.delegate=self
        fc.filterItem=self.filterItem
        present(fc, animated: true)
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
extension SearchResultsViewController:UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return recommendedList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recHorCell", for: indexPath) as? RecommendedHorizontalCell else { return UICollectionViewCell() }
        let i = recommendedList[indexPath.row]
        
        cell.configure(with: i)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        //let cell = collectionView.cellForItem(at: indexPath) as! RecommendedCell
        
        //recommendedCollection.reloadData()
    }
    
    
}
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recCell", for: indexPath) as? RecommendedCell else {
            return UITableViewCell()
        }
        cell.configure(with: searchList[indexPath.row])
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

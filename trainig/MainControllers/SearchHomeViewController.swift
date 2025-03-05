//
//  SearchHomeViewController.swift
//  trainig
//
//  Created by omer yildirim on 1.02.2025.
//

import UIKit

class SearchHomeViewController: UIViewController {
    @IBOutlet weak var InterestCollection: UICollectionView!
    @IBOutlet weak var searchbar: DesignableUITextField!
    @IBOutlet weak var recommendedTable: UITableView!
    
    var recommendedList: [RecommendedTrainerItem] = []
    var interestsList:[InterestItem]=[]
    var ints:[String]=["Hiking","Swimming","Reading","CookingCooking","Traveling","Hiking","Swimming","Reading"]
    let functions = Functions()
    var interests:[String]=[]
    var userData:NSDictionary!
    @IBOutlet weak var noResult: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        noResult.text = String(localized: "no_result")
        userData = CacheData.getUserData()!
        searchbar.delegate = self
        searchbar.returnKeyType = .search
        
        getInterestData()
        
        
        
        InterestCollection.dataSource=self
        InterestCollection.delegate=self
        
        recommendedTable.delegate = self
        recommendedTable.dataSource = self
        
        self.InterestCollection.register(UINib(nibName: "InterestsCell", bundle: nil), forCellWithReuseIdentifier: "intCell")
    }
    func getFeatured(){
        let data : Any = [
            "interests":interests
        ]
        recommendedList.removeAll()
        functions.featured(data: data, onCompleteWithData: { (data,error) in
            DispatchQueue.main.async {
                self.loadsearchList(data as! [NSDictionary])
                self.view.dismissLoader()
            }
            
        })
    }
    var indicator:Indicator!
    func getInterestData(){
        indicator = self.view.showLoader(nil)
        indicator?.lbl.text = String(localized:"wait")
        let id=userData["id"]
        let data:Any=[
            "where": [
                "collectionName": "users",
                "and":[
                    "id":id
                ]
            ],
            "related": [
                "relationName": "userInterestRelation",
                "where": [
                    "collectionName": "userInterest"
                ]
            ]
        ]
        functions.getRelations(data: data,listItem:"userInterest", onCompleteWithData: { (contentData,error) in
            let resData=contentData as? NSArray ?? []
            if error!.isEmpty {
                
                for item in resData{
                    let itemDic = item as! NSDictionary
                    let content = itemDic["content"] as! NSDictionary
                    let i=content["interest"] as? String ?? ""
                    self.interests.append(i)
                    if !self.interestsList.contains(where: { $0.interest == i }){
                        self.interestsList.append(InterestItem(interest: i ,selected: false ))
                    }
                }
                
            }else{
                print(error!)
                
            }
            DispatchQueue.main.async {
                self.addData()
                self.getFeatured()
            }
        })
        
    }
    func addData(){
        
    }
    func loadsearchList(_ data:[NSDictionary]){
        
        if data.count==0{
            noResult.isHidden=false
        }else {
            noResult.isHidden=true
        }
        for item in data{
            recommendedList.append(RecommendedTrainerItem(trainer_title: item["trainertitle"] as? String, trainer_name: item["trainername"] as? String, exps: item["trainerExps"] as? [String], photo: item["trainerphoto"], rating: item["trainerrating"] as? Float,trainerId: item["trainerid"] as? String))
        }
        InterestCollection.reloadData()
        recommendedTable.reloadData()
    }
    @IBAction func searchbar_changed(_ sender: Any) {
        
    }
    func performSearch() {
        guard let searchText = searchbar.text, !searchText.isEmpty else { return }
        let str=searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if str.count>2{
            let n = storyboard?.instantiateViewController(withIdentifier: "sResult") as! SearchResultsViewController
            n.searchStr=str
            n.interests=interests
            n.recommendedList=recommendedList
            self.navigationController!.pushViewController(n, animated: true)
        }
    }
    func search(_ str:String){
        functions.search(start: "0", text: str, onCompleteWithData: { (data,error) in
            print(data);
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
extension SearchHomeViewController:UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout,UITextFieldDelegate{
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
        searchbar.text = interestsList[indexPath.row].interest
        performSearch()
        //InterestCollection.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchbar {
                performSearch()
            }
            return true
    }
    
}
extension SearchHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recTCell", for: indexPath) as? RecommendedTrainerCell else {
            return UITableViewCell()
        }
        cell.configure(with: recommendedList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RecommendedTrainerCell {
            cell.backgroundColor = UIColor(named: "DarkCellBack")
          }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RecommendedTrainerCell {
            cell.backgroundColor = UIColor.clear
          }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = recommendedList[indexPath.row]
        let n = storyboard?.instantiateViewController(withIdentifier: "t_ownprofile") as! TrainerProfileOwn
        n.trainerId = item.trainerId
        n.trainerName = item.trainer_name
        n.trainerTitle = item.trainer_title
        n.trainerPhoto = item.photo
        self.navigationController!.pushViewController(n, animated: true)
    }
    
}

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
        self.searchFilter()
        print(filter)
    }
    var filterItem = FilterItem()
    @IBOutlet weak var recommendedCollection: UICollectionView!
    @IBOutlet weak var searchResultTable: UITableView!
    
    @IBOutlet weak var noResult: UILabel!
    @IBOutlet weak var searchbar: DesignableUITextField!
    
    var searchList: [RecommendedItem] = []
    var recommendedList:[RecommendedTrainerItem]=[]
    var searchStr:String!
    let functions=Functions()
    var interests:[String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        noResult.text=String(localized:"no_result")
        self.title=String(localized:"search_results")
        searchbar.delegate=self
        searchbar.returnKeyType = .search
        searchbar.text!=searchStr
        search()
        
        if recommendedList.count==0{
            getFeatured()
        }
        getFilters()
        
        //loadsearchList()
        
        
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
    func performSearch() {
        guard let searchText = searchbar.text, !searchText.isEmpty else { return }
        let str=searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if str.count>2{
            searchStr=str
            search()
        }
    }
    func search(){
        self.view.showLoader(String(localized:"wait"))
        searchList.removeAll()
        functions.search(start: "0", text: searchStr, onCompleteWithData: { (data,error) in
            DispatchQueue.main.async {
                self.loadsearchList(data as! [NSDictionary])
                self.view.dismissLoader()
            }
            
        })
    }
    func searchFilter(){
        let oneDay:Int64 = 86400000;
        var data : [String:Any] = [:]
        if filterItem.gender.count>0{
            data["gender"] = filterItem.gender
        }
        if filterItem.priceRange.count>0{
            var prices : [String] = []
            for i in filterItem.priceRange{
                let priceInt = Int(i)
                prices.append(String(priceInt))
            }
            data["price"] = prices
        }
        if filterItem.ageRange.count>0{
            
            var ages : [String] = []
            for e in (0..<filterItem.ageRange.count).reversed() {
                let i = filterItem.ageRange[e]
                let ageInt = Int(i)
                var longAge = Statics.longDateTimestamp(fromAge: ageInt)
                longAge = longAge - oneDay
                ages.append(String(longAge))
            }
            data["age"] = ages
        }
        if filterItem.experience.count>0 {
            var expData : [Any] = []
            for i in filterItem.experience {
                var d:Any!
                if i.count>1{
                    var cs:[String]=[]
                    for c in i{
                        let longC = Statics.longDateTimestamp(fromAge: Int(c))
                        cs.append(String(longC))
                    }
                    d = [
                        "type":"between",
                        "exp":cs
                    ]
                }else {
                    d = [
                        "type":"gt",
                        "exp":String(i[0])
                    ]
                }
                expData.append(d!)
                
            }
            data["exps"] = expData
        }
        print(data)
        self.view.showLoader(String(localized:"wait"))
        searchList.removeAll()
        functions.searchFilter(data: data,start: "0", text: searchStr, onCompleteWithData: { (data,error) in
            DispatchQueue.main.async {
                self.loadsearchList(data as! [NSDictionary])
                self.view.dismissLoader()
            }
            
        })
    }
    var ages : [CGFloat] = []
    var prices : [CGFloat] = []
    func getFilters(){
        functions.getFilters(onCompleteWithData: { (data,error) in
            if let data = data as? NSDictionary{
                let minPrice = data["min_price"] as! Int
                let maxPrice = data["max_price"] as! Int
                self.prices.append(CGFloat(minPrice))
                self.prices.append(CGFloat(maxPrice))
                let maxAge = data["max_age"] as! Int64
                let minAge = data["min_age"] as! Int64
                let intMinAge = Statics.yearsDifferenceInt(from: TimeInterval(minAge))
                let intMaxAge = Statics.yearsDifferenceInt(from: TimeInterval(maxAge))
                self.ages.append(CGFloat(intMinAge!))
                self.ages.append(CGFloat(intMaxAge!))
                
            }
        })
    }
    func getFeatured(){
        let data : Any = [
            "interests":interests
        ]
        recommendedList.removeAll()
        functions.featured(data: data, onCompleteWithData: { (data,error) in
            DispatchQueue.main.async {
                self.addData(data as! [NSDictionary])
            }
            
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    func addData(_ data:[NSDictionary]){
        for item in data{
            recommendedList.append(RecommendedTrainerItem(trainer_title: item["trainertitle"] as? String, trainer_name: item["trainername"] as? String, exps: item["trainerexps"] as? [String], photo: item["trainerphoto"], rating: item["trainerrating"] as? Float,trainerId: item["trainerid"] as? String))
        }
        recommendedCollection.reloadData()
    }
    func loadsearchList(_ data:[NSDictionary]){
        if data.count==0{
            noResult.isHidden=false
            searchResultTable.reloadData()
            return
        }else {
            noResult.isHidden=true
        }
        for item in data{
            let time = Statics.formatDateWithTimeFromLong(timestamp: item["trainingstartdate"] as! Int64)
            let duration = Statics.getTimeDifference(start: item["trainingstartdate"] as! Int64,end:item["trainingenddate"] as! Int64)
            searchList.append(RecommendedItem(training_name: item["trainingtopic"] as? String, trainer_name: item["trainername"] as? String, duration: duration, time: time, photo: item["trainerphoto"], rating: item["trainerrating"] as? Float,trainerId: item["trainerid"] as? String,trainer_title:item["trainertitle"] as? String,price:"₺ \(String((item["trainingprice"] as? Int)!))",equipments: item["trainingequipments"] as? String,ads_id: item["ads_id"] as? String,startDate: item["trainingstartdate"] as? Int64 ?? 0,endDate: item["trainingenddate"] as? Int64 ?? 0))
        }
        searchResultTable.reloadData()
    }
    @IBAction func filter_cl(_ sender: Any) {
        let fc=storyboard?.instantiateViewController(withIdentifier: "fltr") as! Filter
        fc.delegate=self
        fc.filterItem=self.filterItem
        fc.ages=ages
        fc.prices=prices
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recHorTCell", for: indexPath) as? RecommendedTrainerHorizontalCell else { return UICollectionViewCell() }
        let i = recommendedList[indexPath.row]
        
        cell.configure(with: i)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = recommendedList[indexPath.row]
        let n = storyboard?.instantiateViewController(withIdentifier: "t_ownprofile") as! TrainerProfileOwn
        n.trainerId = item.trainerId
        n.trainerName = item.trainer_name
        n.trainerTitle = item.trainer_title
        n.trainerPhoto = item.photo
        self.navigationController!.pushViewController(n, animated: true)
        //let cell = collectionView.cellForItem(at: indexPath) as! RecommendedCell
        
        //recommendedCollection.reloadData()
    }
    
    
}
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchCell else {
            return UITableViewCell()
        }
        cell.configure(with: searchList[indexPath.row])
        return cell
    }
  
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchCell {
            cell.backgroundColor = UIColor(named: "DarkCellBack")
          }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchCell {
            cell.backgroundColor = UIColor.clear
          }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchbar {
                performSearch()
            }
            return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        self.navigationController!.pushViewController(n, animated: true)
    }
    
}

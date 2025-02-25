//
//  UpdateInterestCollectionViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit

private let reuseIdentifier = "intCell"

class UpdateInterestCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var interestsList:[InterestItem]=[]
    var ints:[String]=["Hiking","Swimming","Reading","CookingCooking","Traveling","Hiking","Swimming","Reading","Aerial Yoga","Pilates","Cycling","Dancing","Boxing","Martial Arts","Jogging","Running","Yoga","Meditation","Stretching"]
    let functions=Functions()
    var userData:NSDictionary!
    var forTrainer:Bool=false
    var existingIds:[String]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData = CacheData.getUserData()!
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "InterestsCell", bundle: nil), forCellWithReuseIdentifier: "intCell")
        
        
        collectionView.centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0))
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        //layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
    }
    
    func addData(){
        for i in ints{
            if !interestsList.contains(where: { $0.interest == i }){
                interestsList.append(InterestItem(interest: i,selected: false ))
            }
            
        }
        collectionView.reloadData()
    }
    func getTrainerData(){
        let id=userData["id"]
        let data:Any=[
            "where": [
                "collectionName": "users",
                "and":[
                    "id":id
                ]
            ],
            "related": [
                "relationName": "trainerSpecsRelation",
                "where": [
                    "collectionName": "trainerSpecs"
                ]
            ]
        ]
        functions.getRelations(data: data,listItem:"trainerSpecs", onCompleteWithData: { (contentData,error) in
            let resData=contentData as? NSArray ?? []
            if error!.isEmpty {
                
                for item in resData{
                    let itemDic = item as! NSDictionary
                    self.existingIds.append(itemDic["id"] as! String)
                    let content = itemDic["content"] as! NSDictionary
                    let i=content["spec"] as? String ?? ""
                    if !self.interestsList.contains(where: { $0.interest == i }){
                        self.interestsList.append(InterestItem(interest: i ,selected: true ))
                    }
                }
                
            }else{
                print(error!)
                
            }
            DispatchQueue.main.async {
                self.addData()
            }
        })
        
    }
    func getUserData(){
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
                    self.existingIds.append(itemDic["id"] as! String)
                    let content = itemDic["content"] as! NSDictionary
                    let i=content["interest"] as? String ?? ""
                    if !self.interestsList.contains(where: { $0.interest == i }){
                        self.interestsList.append(InterestItem(interest: i ,selected: true ))
                    }
                }
                
            }else{
                print(error!)
                
            }
            DispatchQueue.main.async {
                self.addData()
            }
        })
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return interestsList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! InterestsCell
        interestsList[indexPath.row].selected.toggle()
        cell.setBack(with: interestsList[indexPath.row])
        //InterestCollection.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(update))
        interestsList = []
        forTrainer = userData["role"] as! String == "user" ? false : true
        if forTrainer {
            getTrainerData()
        }else{
            getUserData()
        }
        
    }
    @objc func update(_ button: UIBarButtonItem?) {
        deleteExsistingInterests(oNCompleteBool:{ (success,error) in
            if(success!){
                self.insertDatas(oNCompleteBool: { (success2,error2) in
                    if(success2!){
                        print(success2!)
                    }else {
                        print(error2!)
                    }
                })
            }else {
                print(error!)
            }
        })
    }
    func deleteExsistingInterests(oNCompleteBool:@escaping Functions.OnCompleteBool){
        let data : Any = [
            "where": [
                "collectionName": forTrainer ?"trainerSpecs":"userInterest",
                "or": [
                    "id": self.existingIds
                ]
            ]
        ]
        print(data)
        functions.delete(data: data, onCompleteBool: { (success,error) in
            oNCompleteBool(success,error)
        })
    }
    func insertDatas(oNCompleteBool:@escaping Functions.OnCompleteBool){
        let id=userData["id"]
        var contents:[Any] = []
        for i in interestsList{
            if i.selected{
                var c : Any = []
                if forTrainer {
                    c = [
                        "spec": i.interest!,
                        "year":0,
                        "createdDate": 0
                    ]
                }else {
                    c = [
                        "interest": i.interest!,
                        "createdDate": 0
                    ]
                }
                let d : Any = [
                    "collectionName": forTrainer ? "trainerSpecs":"userInterest",
                    "content": c
                ]
                contents.append(d)
            }
        }
        let data : Any =
        [
            "relations": [
                [
                    "id": id,
                    "collectionName":"users",
                    "relationName": forTrainer ? "trainerSpecsRelation" : "userInterestRelation"
                ]
            ],
            "contents": contents
        ]
        functions.addRelations(data: data, onCompleteBool: { (success,error) in
            oNCompleteBool(success,error)
        })
        print(data)
    }
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

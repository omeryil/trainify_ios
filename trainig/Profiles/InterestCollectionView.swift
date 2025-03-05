//
//  InterestCollectionView.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

private let reuseIdentifier = "Cell"

class InterestCollectionView: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    
    var interestsList:[InterestItem]=[]
    let functions=Functions()
    var id:String!
    var ints:[String]=["Hiking","Swimming","Reading","CookingCooking","Traveling","Hiking","Swimming","Reading"]
    var forTrainer:Bool=false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "InterestsCell", bundle: nil), forCellWithReuseIdentifier: "intCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        //layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        self.collectionView!.collectionViewLayout = layout
       
        
        if forTrainer{
            addTrainerData()
        }
        else{
            addData()
        }
        // Do any additional setup after loading the view.
    }
   
    func addData(){
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
                    self.interestsList.append(InterestItem(interest: content["interest"] as? String ?? "" ,selected: false ))
                }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }else{
                print(error!)
                
            }
        })
        
    }
    func addTrainerData(){
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
                    let content = itemDic["content"] as! NSDictionary
                    self.interestsList.append(InterestItem(interest: content["spec"] as? String ?? "" ,selected: false ))
                }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }else{
                print(error!)
                
            }
        })
        
    }
    override func viewWillAppear(_ animated: Bool) {
        interestsList.removeAll()
        if forTrainer{
            addTrainerData()
        }
        else{
            addData()
        }
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

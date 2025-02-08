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
    var ints:[String]=["Hiking","Swimming","Reading","CookingCooking","Traveling","Hiking","Swimming","Reading"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=String(localized:"interests")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "InterestsCell", bundle: nil), forCellWithReuseIdentifier: "intCell")

        addData()
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
            interestsList.append(InterestItem(interest: i,selected: false ))
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
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(update))

    }
    @objc func update(_ button: UIBarButtonItem?) {
        
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

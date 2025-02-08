//
//  Interests.swift
//  trainig
//
//  Created by omer yildirim on 28.01.2025.
//

import UIKit

class Interests: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

    @IBOutlet weak var InterestCollection: UICollectionView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var desc: UITextView!
    var interestsList:[InterestItem]=[]
    var ints:[String]=["Hiking","Swimming","Reading","CookingCooking","Traveling","Hiking","Swimming","Reading"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Interests"
        
        question.text=String(localized: "what_are_u_interested")
        desc.text=String(localized: "select_int_desc")
        addData()
        InterestCollection.dataSource=self
        InterestCollection.delegate=self
        InterestCollection.centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0))
        self.InterestCollection.register(UINib(nibName: "InterestsCell", bundle: nil), forCellWithReuseIdentifier: "intCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        //layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        InterestCollection.collectionViewLayout = layout
       
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

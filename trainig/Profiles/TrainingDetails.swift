//
//  TrainingDetails.swift
//  trainig
//
//  Created by omer yildirim on 6.02.2025.
//

import UIKit

class TrainingDetails: UIViewController {

    @IBOutlet weak var timeCollection: UICollectionView!
    @IBOutlet weak var picker: UIDatePicker!
    var times: [InterestItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeCollection.delegate = self
        timeCollection.dataSource = self
        self.timeCollection.register(UINib(nibName: "InterestsCell", bundle: nil), forCellWithReuseIdentifier: "intCell")
        picker.overrideUserInterfaceStyle = .dark
        addTimes()
        // Do any additional setup after loading the view.
    }
    func addTimes() {
        for i in 8..<20 {
            times.append(InterestItem(interest: (i<10 ? "0\(i)" : "\(i)") + ":00", selected: false))
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
extension TrainingDetails: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return times.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "intCell", for: indexPath) as? InterestsCell else { return UICollectionViewCell() }
        let i = times[indexPath.row]
        
        cell.configure(with: i)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let cell = collectionView.cellForItem(at: indexPath) as! InterestsCell
        times[indexPath.row].selected.toggle()
        cell.setBack(with: times[indexPath.row])
        //InterestCollection.reloadData()
    }
    
}

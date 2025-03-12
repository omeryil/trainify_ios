//
//  Filter.swift
//  trainig
//
//  Created by omer yildirim on 7.02.2025.
//

import UIKit
import MultiSlider

class Filter: UIViewController, sliderChangedDelegate {
    func sliderChanged(slider: RangeSlider, values: [CGFloat]) {
        if slider == ageRange {
            filterItem.ageRange=values
        }else if slider==priceRange {
            filterItem.priceRange=values
        }
    }
    
    
    

    @IBOutlet weak var training_types: UICollectionView!
    @IBOutlet weak var genders: UICollectionView!
    @IBOutlet weak var experiences: UICollectionView!
    public var delegate:filterDelegate?
    public var filterItem = FilterItem()
    public var checkFilterItem = FilterItem()
    @IBOutlet weak var ageRange: RangeSlider!
    @IBOutlet weak var priceRange: RangeSlider!
    var trainingTypes:[InterestItem]=[]
    var gender:[InterestItem]=[]
    var experience:[InterestItem]=[]
    var expItems:[[Int]]=[[1,5],[5,10],[10]]
    var ages : [CGFloat]!
    var prices : [CGFloat]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        ageRange.delegate=self
        priceRange.delegate=self
        if prices != nil && prices.count > 0 {
            priceRange.minValue=prices[0]
            priceRange.maxValue=prices[1]
        }
        
        if filterItem.priceRange.count > 0 {
            priceRange.value=filterItem.priceRange
        }else {
            let firstPrice:CGFloat=prices[0]+((prices[1] - prices[0])/4)
            let secondPrice:CGFloat=prices[0]+((prices[1] - prices[0])/4*3)
            if prices.count > 0 {
                priceRange.value=[firstPrice, secondPrice]
            }
            
        }
        
        if ages != nil && ages.count > 0 {
            ageRange.minValue = ages[0]
            ageRange.maxValue = ages[1]
        }
       
        if filterItem.ageRange.count > 0 {
            ageRange.value=filterItem.ageRange
        }else {
            let firstAge:CGFloat=ages[0]+((ages[1] - ages[0])/4)
            let secondAge:CGFloat=ages[0]+((ages[1] - ages[0])/4*3)
            if ages.count > 0 {
                ageRange.value=[firstAge, secondAge]
            }
        }
        
        training_types.delegate=self
        training_types.dataSource=self
        genders.delegate=self
        genders.dataSource=self
        experiences.delegate=self
        experiences.dataSource=self
        self.training_types.register(UINib(nibName: "OneItem", bundle: nil), forCellWithReuseIdentifier: "oneCell")
        self.genders.register(UINib(nibName: "OneItem", bundle: nil), forCellWithReuseIdentifier: "oneCell")
        self.experiences.register(UINib(nibName: "OneItem", bundle: nil), forCellWithReuseIdentifier: "oneCell")
        addTType()
        addGenders()
        addExp()
        checkFilterItem = filterItem
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let isApply:Bool = checkFilterItem == filterItem
        if isBeingDismissed {
            delegate?.returnFilter(filter: filterItem,isApply:!isApply)
        }
    }
    @IBAction func close_cl(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    func addTType() {
        let items:[String]=["Group","Workshop","Private"]
        for i in items {
            trainingTypes.append(InterestItem(interest: i, selected: filterItem.training_type.firstIndex(of:i) ?? -1 >= 0 ? true : false))
        }
        
    }
    func addGenders() {
        let items: [String] = ["Man", "Woman", "Trans Gender", "Non-Binary"]
        for i in items {
            gender.append(InterestItem(interest: i, selected: filterItem.gender.firstIndex(of:i) ?? -1 >= 0 ? true : false))
        }
    }
    func addExp() {
        let items: [String] = ["1-5 Years", "5-10 Years", "+10 Years"]
        for i in 0..<items.count {
            let e = items[i]
            experience.append(InterestItem(interest: e, selected: filterItem.experience.firstIndex(of:expItems[i]) ?? -1 >= 0 ? true : false))
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
extension Filter: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == training_types{
            return trainingTypes.count
        }else if collectionView == genders{
            return gender.count
        }else if collectionView == experiences{
            return experience.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == training_types{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "oneCell", for: indexPath) as? OneItem else { return UICollectionViewCell() }
            let i = trainingTypes[indexPath.row]
            
            cell.configure(with: i)
            
            
            return cell
        }else if collectionView == genders{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "oneCell", for: indexPath) as? OneItem else { return UICollectionViewCell() }
            let i = gender[indexPath.row]
            
            cell.configure(with: i)
            
            return cell
        }else if collectionView == experiences{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "oneCell", for: indexPath) as? OneItem else { return UICollectionViewCell() }
            let i = experience[indexPath.row]
            
            cell.configure(with: i)
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == training_types{
            let cell = collectionView.cellForItem(at: indexPath) as! OneItem
            
            if !trainingTypes[indexPath.row].selected{
                filterItem.training_type.append(trainingTypes[indexPath.row].interest)
            }else{
                if let index = filterItem.training_type.firstIndex(of:trainingTypes[indexPath.row].interest) {
                    filterItem.training_type.remove(at: index)
                }
            }
            trainingTypes[indexPath.row].selected.toggle()
            cell.setBack(with: trainingTypes[indexPath.row])
        }else if collectionView == genders{
            let cell = collectionView.cellForItem(at: indexPath) as! OneItem
            if !gender[indexPath.row].selected{
                filterItem.gender.append(gender[indexPath.row].interest)
            }else{
                if let index = filterItem.gender.firstIndex(of:gender[indexPath.row].interest) {
                    filterItem.gender.remove(at: index)
                }
            }
            gender[indexPath.row].selected.toggle()
            cell.setBack(with: gender[indexPath.row])
        }else if collectionView == experiences{
            let cell = collectionView.cellForItem(at: indexPath) as! OneItem
            if !experience[indexPath.row].selected{
                filterItem.experience.append(expItems[indexPath.row])
            }else{
                if let index = filterItem.experience.firstIndex(of:expItems[indexPath.row]) {
                    filterItem.experience.remove(at: index)
                }
            }
            experience[indexPath.row].selected.toggle()
            cell.setBack(with: experience[indexPath.row])
        }
       
        //InterestCollection.reloadData()
    }
    
}

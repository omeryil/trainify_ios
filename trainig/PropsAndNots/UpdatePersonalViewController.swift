//
//  UpdatePersonalViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit

class UpdatePersonalViewController: UIViewController {
    
    @IBOutlet weak var heightTF: CustomTextFieldBorder8!
    @IBOutlet weak var weightTF: CustomTextFieldBorder8!
    @IBOutlet weak var fullname: CustomTextFieldBorder8!
    
    @IBOutlet weak var tableview: UITableView!
    let functions = Functions()
    var userData:NSMutableDictionary!
    var pickerToolbar: UIToolbar?
    var datePicker: UIDatePicker!
    var wPicker = UIPickerView()
    var hPicker = UIPickerView()
    var heights: [String] = []
    var weights: [String] = []
    var oldWeights:[OldWeightItem] = []
    var weightChanged:Bool = false
    var lastWeight:String!
    var newWeight:String!
    var lastDate:Int64!
    var headers:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=String(localized:"personal_info")
        userData = CacheData.getUserData()!
        getUserFeatures()
        
        wPicker.delegate = self
        hPicker.delegate = self
        wPicker.dataSource = self
        hPicker.dataSource = self
        
        createUIToolBar()
        
        createHeightPicker()
        createWeightPicker()
        bindPickers()
        if userData.object(forKey: "weightChangedDate") != nil {
            lastDate = userData["weightChangedDate"] as? Int64 ?? 0
        } else {
            lastDate = userData["createdDate"] as? Int64 ?? 0
        }
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 95
        tableview.separatorStyle = .singleLine
        tableview.separatorColor = .gray
        headers = [String(localized:"weight_change_list")]
        // Do any additional setup after loading the view.
    }
    func createWeightPicker(){
        let frameView = UIView()
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = UIColor(named: "DarkBack")
        frameView.frame.size = CGSize(width: 0, height: 200)
        frameView.addSubview(wPicker)
        wPicker.setValue(UIColor.white, forKeyPath: "textColor")
        wPicker.translatesAutoresizingMaskIntoConstraints = false
        wPicker.topAnchor.constraint(equalTo: frameView.topAnchor).isActive = true
        wPicker.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        wPicker.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        wPicker.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        weightTF.inputView = frameView
        weightTF?.inputAccessoryView = pickerToolbar
    }
    func createHeightPicker(){
        let frameView = UIView()
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = UIColor(named: "DarkBack")
        frameView.frame.size = CGSize(width: 0, height: 200)
        frameView.addSubview(hPicker)
        hPicker.setValue(UIColor.white, forKeyPath: "textColor")
        hPicker.translatesAutoresizingMaskIntoConstraints = false
        hPicker.topAnchor.constraint(equalTo: frameView.topAnchor).isActive = true
        hPicker.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        hPicker.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        hPicker.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        heightTF.inputView = frameView
        heightTF?.inputAccessoryView = pickerToolbar
        
    }
    func bindPickers(){
        for i in 50...280{
            heights.append(String(i) + " cm")
        }
        for i in 40...250{
            weights.append(String(i) + " kg")
        }
    }
    func createUIToolBar() {
            
        pickerToolbar = UIToolbar()
        pickerToolbar?.autoresizingMask = .flexibleHeight
        pickerToolbar?.layer.cornerRadius = 10

        pickerToolbar?.barStyle = .default
        pickerToolbar?.barTintColor = UIColor(named: "DarkBack")
        pickerToolbar?.backgroundColor = UIColor.white
        pickerToolbar?.isTranslucent = false

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:
                #selector(cancelBtnClicked(_:)))
        cancelButton.tintColor = UIColor.red
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
                #selector(doneBtnClicked(_:)))
        doneButton.tintColor = UIColor(named: "MainColor")
        
        pickerToolbar?.items = [cancelButton, flexSpace, doneButton]
            
        }
    @objc func cancelBtnClicked(_ button: UIBarButtonItem?) {
        weightTF?.resignFirstResponder()
        heightTF?.resignFirstResponder()
    }
        
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        weightTF?.resignFirstResponder()
        heightTF?.resignFirstResponder()
        if selectedTextField == weightTF{
            weightTF.text = weights[wPicker.selectedRow(inComponent: 0)]
        }else if selectedTextField == heightTF{
            heightTF.text = heights[hPicker.selectedRow(inComponent: 0)]
        }
        
    }
    var selectedTextField: UITextField?
    @IBAction func t_up(_ sender: Any) {
        selectedTextField = sender as? UITextField
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(update))
        getOldWeights()
        

    }
    @objc func update(_ button: UIBarButtonItem?) {
        if fullname.text!.isEmpty {
            
        }
        if weightTF.text!.isEmpty {
            
        }
        if heightTF.text!.isEmpty {
            
        }
        let id = userData["id"] as! String
        updateName(id: id)
        
    }
    func getUserFeatures(){
        self.heightTF.text=userData["height"] as? String
        self.weightTF.text=userData["weight"] as? String
        self.fullname.text=self.userData["name"] as? String
       
    }
    func updateName(id:String){
        self.view.showLoader(String(localized:"wait"))
        let name = fullname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let height = heightTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let weight = weightTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        var fields:[Any] = [
            [
                "field": "name",
                "value": name
            ],
            [
                "field": "height",
                "value": height
            ]
        ]
        let w = userData["weight"] as! String
        let cd = Statics.currentTimeInMilliSeconds()
        if w != weight{
            weightChanged=true
            lastWeight = userData["weight"] as? String
            newWeight = weight
            fields.append([
                "field": "weight",
                "value": weight
            ])
            fields.append([
                "field": "weightChangedDate",
                "value": cd
            ])
        }
        let data:Any = [
            "where": [
                "collectionName": "users",
                "and": [
                    "id": id
                ]
            ],
            "fields": fields
        ]
        functions.update(data: data, onCompleteBool: { (success,error) in
            if success!{
                self.userData["name"]=name
                self.userData["height"]=height
                self.userData["weight"]=weight
                self.userData["weightChangedDate"] = cd
                self.lastDate = cd
                CacheData.saveUserData(data: self.userData)
                if w != weight{
                    DispatchQueue.main.async {
                        self.addNewWeight()
                    }
                }
            }else {
                if error == PostGet.no_connection {
                    DispatchQueue.main.async {
                        PostGet.noInterneterror(v: self)
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                self.view.dismissLoader()
            }
        })
    }
    func addNewWeight(){
        let data : Any = [
            "collectionName":"oldWeights",
            "content":[
                "userid":userData["id"],
                "oldWeight": lastWeight,
                "newWeight": newWeight,
                "time":lastDate
            ]
        ]
        functions.addCollection(data: data, onCompleteBool: {s,e in
            if s! {
                self.getOldWeights()
            }
            if e == PostGet.no_connection {
                DispatchQueue.main.async {
                    PostGet.noInterneterror(v: self)
                }
                return
            }
        })
    }
    func getOldWeights(){
        oldWeights.removeAll()
        let checkData:Any = [
            "where": [
                "collectionName":"oldWeights",
                "and":[
                    "userid":userData["id"]!
                ]
            ],
            "sort":[
                "time":"desc"
            ],
        ]
        functions.getCollection(data: checkData, onCompleteWithData: { d,e in
            if e == PostGet.no_connection {
                DispatchQueue.main.async {
                    //PostGet.noInterneterror(v: self)
                }
                return
            }
            if d != nil {
                for i in d as! [[String:Any]] {
                    let id = i["id"] as! String
                    let content = i["content"] as! [String:Any]
                    self.oldWeights.append(OldWeightItem(oldWeight: content["oldWeight"] as! String, lastWeight:content["newWeight"] as! String, time: content["time"] as! Int64,lastTime: self.lastDate))
                    print(content["time"] as! Int64)
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        })
    }
//    func updatFeatures(){
//        let data:Any = [
//            "where": [
//                "collectionName": "users",
//                "and": [
//                    "id": userData["id"]
//                ]
//            ],
//            "fields": [
//                [
//                    "field": "height",
//                    "value": heightTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//                ],
//                [
//                    "field": "weight",
//                    "value": weightTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//                ]
//            ]
//        ]
//        functions.update(data: data, onCompleteBool: { (success,error) in
//            if success!{
//                print(success!)
//            }else {
//                print(error!)
//            }
//        })
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UpdatePersonalViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == wPicker){
            return weights.count
        }else if(pickerView == hPicker){
            return heights.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == wPicker){
            return String(weights[row])
        }else if(pickerView == hPicker){
            return String(heights[row])
        }
        return nil
    }
    
}
extension UpdatePersonalViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oldWeights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oldWeight", for: indexPath) as! OldWeightsCell
        let i = indexPath.row + 1
        if i <= oldWeights.count - 1  {
            cell.configure2(newItem:oldWeights[i], oldItem: oldWeights[indexPath.row])
        }else{
            cell.configure(with: oldWeights[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65 
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.black // Header arka plan rengi
        
        let label = UILabel(frame: CGRect(x: 8, y: 5, width: tableView.frame.width - 16, height: 40))
        label.text = headers[0]
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        headerView.addSubview(label)
        let bottomSpace = UIView(frame: CGRect(x: 0, y: 50, width: tableView.frame.width, height: 30))
        bottomSpace.backgroundColor = .clear
        headerView.addSubview(bottomSpace)
        
        return oldWeights.isEmpty ? nil : headerView
    }
    
}

//
//  Certificates.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class Certificates: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return certificates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "certCell") as? CertificateCell else {
            return UITableViewCell()
        }
        cell.configure(with: certificates[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CertificateCell {
            cell.backgroundColor = UIColor(named: "DarkCellBack")
          }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CertificateCell {
            cell.backgroundColor = UIColor.clear
          }
    }

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var certificatesTable: UITableView!
    
    var certificates:[CertificateItem]=[]
    
    var isStepperOn:Bool=false
    var stepperDelegate:StepperDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        certificatesTable.delegate=self
        certificatesTable.dataSource=self
        addData()
        
        question.text=String(localized: "certificates")
        desc.text=String(localized: "certificates_desc")
        // Do any additional setup after loading the view.
    }
    func addData() {
        let descStrs:[String] = ["About Yoga","About Meditation","About Mindfulness","About Mindfulness","About Mindfulness"]
        for i in descStrs {
            certificates.append(CertificateItem(icon: "cert_512", description: i))
        }
    }

    @IBAction func clicked(_ sender: Any) {
        let nots = self.storyboard!.instantiateViewController(withIdentifier: "nots") as! Notifications
        self.present(nots, animated:true)
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

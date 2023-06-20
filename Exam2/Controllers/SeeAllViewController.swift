//
//  SeeAllViewController.swift
//  Exam2
//
//  Created by Shubhamsinh Rahevar on 02/03/23.
//

import UIKit

class SeeAllViewController: UIViewController {
    
    var selectedArr: [Score] = []
    var selectedArrForDetail: [Score] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
}

extension SeeAllViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeeAllTableViewCell", for: indexPath) as! SeeAllTableViewCell
//        DispatchQueue.main.async { [self] in
            cell.team1Name.text = selectedArr[indexPath.row].t1
            cell.team2Name.text = selectedArr[indexPath.row].t2
        cell.team1Score.text = selectedArr[indexPath.row].t1s
        cell.team2Score.text = selectedArr[indexPath.row].t2s
        cell.matchSituationLabel.text = selectedArr[indexPath.row].status
        let url1 = URL(string: selectedArr[indexPath.row].t1img ?? "https://g.cricapi.com/img/teams/31-637877061080567215.webp")
        cell.team1Image.downloadImage(from: url1!)
        cell.team1Image.layer.cornerRadius = 32.5
        
        let url2 = URL(string: selectedArr[indexPath.row].t2img ?? "https://g.cricapi.com/img/teams/31-637877061080567215.webp")
        cell.team2Image.downloadImage(from: url1!)
        cell.team2Image.layer.cornerRadius = 32.5
        
        cell.btnSave.tag = indexPath.row
        cell.btnSave.addTarget(self, action: #selector(btnSaveClicked(sender:)), for: .touchUpInside)
//            cell.team2Name.text = selectedArr[indexPath.row].t2
//        }
        
        return cell
    }
    
    @objc func btnSaveClicked(sender: UIButton){
        let index = sender.tag
        sender.tag += 1
        if sender.tag > 2 { sender.tag = 0 }

            switch sender.tag {
            case 1:
                print("Save")
            case 2:
                print("Unsave")
            default:
                print("default")
            }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        destinationVC.selectedArr = [selectedArr[indexPath.row]]
        navigationController?.pushViewController(destinationVC, animated: true)
    }


}

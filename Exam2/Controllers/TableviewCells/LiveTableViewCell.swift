//
//  LiveTableViewCell.swift
//  Exam2
//
//  Created by Shubhamsinh Rahevar on 22/02/23.
//

import UIKit
import CoreData

class LiveTableViewCell: UITableViewCell {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var score: ScoreModel?
    var recentArr = [Score]()
    var liveArr = [Score]()
    var upcomingArr = [Score]()
    var ResultArr = [Score]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func saveDataTODatabase(index: Int, team1Name: String, team2Name: String, team1Score: String, team2Score: String, team1Img: String, team2Img: String){
        print(index)
        print(team1Name)
        print(team2Name)
        let context = delegate.persistentContainer.viewContext
        let matchEntity = NSEntityDescription.entity(forEntityName: "Match", in: context)!
        let newMatch = NSManagedObject(entity: matchEntity, insertInto: context)
        newMatch.setValue(team1Name, forKey: "team1Name")
        newMatch.setValue(team2Name, forKey: "team2Name")
        newMatch.setValue(team1Score, forKey: "team1Score")
        newMatch.setValue(team2Score, forKey: "team2Score")
        newMatch.setValue(team1Img, forKey: "team1Img")
        newMatch.setValue(team2Img, forKey: "team2Img")
        do {
            try context.save()
            print("Saved successfully")
            let alert = UIAlertController(title: "Saved successfully!", message: "", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { action in
                
            })
            alert.addAction(okay)
//            self.present(alert, animated: true)
//            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//            let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "tableViewController") as! tableViewController
//            navigationController?.pushViewController(destinationVC, animated: true)
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    
    @objc func btnSaveClicked(sender : UIButton){
        if self.collectionView.tag == 1{
            saveDataTODatabase(index: 1,
                               team1Name: liveArr[sender.tag].t1,
                               team2Name: liveArr[sender.tag].t2,
                               team1Score: liveArr[sender.tag].t1s,
                               team2Score: liveArr[sender.tag].t2s,
                               team1Img: liveArr[sender.tag].t1img!,
                               team2Img: liveArr[sender.tag].t2img!
            )
            print(liveArr[sender.tag].t1)
        }else if self.collectionView.tag == 2{
            saveDataTODatabase(index: 2,
                               team1Name: upcomingArr[sender.tag].t1,
                               team2Name: upcomingArr[sender.tag].t2,
                               team1Score: upcomingArr[sender.tag].t1s,
                               team2Score: upcomingArr[sender.tag].t2s,
                               team1Img: upcomingArr[sender.tag].t1img!,
                               team2Img: upcomingArr[sender.tag].t2img!
            )
            print(upcomingArr[sender.tag].t1)
        }else{
            saveDataTODatabase(index: 3,
                               team1Name: ResultArr[sender.tag].t1,
                               team2Name: ResultArr[sender.tag].t2,
                               team1Score: ResultArr[sender.tag].t1s,
                               team2Score: ResultArr[sender.tag].t2s,
                               team1Img: ResultArr[sender.tag].t1img!,
                               team2Img: ResultArr[sender.tag].t2img!
            )
            print(ResultArr[sender.tag].t1)

        }
    }

}

extension LiveTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1{
            return liveArr.count
        }else if collectionView.tag == 2{
            return upcomingArr.count
        }else{
            return ResultArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if self.collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCollectionViewCell", for: indexPath) as! LiveCollectionViewCell
            cell.team1Name.text = liveArr[indexPath.row].t1
            cell.team2Name.text = liveArr[indexPath.row].t2
            cell.saveButton.tag = indexPath.row
            cell.saveButton.addTarget(self, action: #selector(btnSaveClicked(sender:)), for: .touchUpInside)

            cell.team1Score.text = liveArr[indexPath.row].t1s
            cell.team2Score.text = liveArr[indexPath.row].t2s
            
            cell.team1Image.layer.cornerRadius = 32.5
            cell.team2Image.layer.cornerRadius = 32.5
            
            cell.matchSituationLabel.text = liveArr[indexPath.row].status
            
            let url1 = URL(string: liveArr[indexPath.row].t1img ?? "https://g.cricapi.com/img/teams/6-637877070670541994.webp")
            cell.team1Image.downloadImage(from: url1!)
            let url2 = URL(string: liveArr[indexPath.row].t2img ?? "https://g.cricapi.com/img/teams/6-637877070670541994.webp")
            cell.team2Image.downloadImage(from: url2!)
            return cell
        }
        else if self.collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCollectionViewCell", for: indexPath) as! LiveCollectionViewCell
            cell.team1Name.text = upcomingArr[indexPath.row].t1
            cell.team2Name.text = upcomingArr[indexPath.row].t2
            cell.saveButton.tag = indexPath.row
            cell.saveButton.addTarget(self, action: #selector(btnSaveClicked(sender:)), for: .touchUpInside)

            cell.team1Score.text = upcomingArr[indexPath.row].t1s
            cell.team2Score.text = upcomingArr[indexPath.row].t2s
            
            cell.team1Image.layer.cornerRadius = 32.5
            cell.team2Image.layer.cornerRadius = 32.5
            
            cell.matchSituationLabel.text = upcomingArr[indexPath.row].status
            
            let url1 = URL(string: upcomingArr[indexPath.row].t1img ?? "https://g.cricapi.com/img/teams/6-637877070670541994.webp")
            cell.team1Image.downloadImage(from: url1!)
            let url2 = URL(string: upcomingArr[indexPath.row].t2img ?? "https://g.cricapi.com/img/teams/6-637877070670541994.webp")
            cell.team2Image.downloadImage(from: url2!)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCollectionViewCell", for: indexPath) as! LiveCollectionViewCell
            cell.team1Name.text = ResultArr[indexPath.row].t1
            cell.team2Name.text = ResultArr[indexPath.row].t2
            cell.saveButton.tag = indexPath.row
            cell.saveButton.addTarget(self, action: #selector(btnSaveClicked(sender:)), for: .touchUpInside)

            cell.team1Score.text = ResultArr[indexPath.row].t1s
            cell.team2Score.text = ResultArr[indexPath.row].t2s
            
            cell.team1Image.layer.cornerRadius = 32.5
            cell.team2Image.layer.cornerRadius = 32.5
            
            cell.matchSituationLabel.text = ResultArr[indexPath.row].status
            
            let url1 = URL(string: ResultArr[indexPath.row].t1img ?? "https://g.cricapi.com/img/teams/6-637877070670541994.webp")
            cell.team1Image.downloadImage(from: url1!)
            let url2 = URL(string: ResultArr[indexPath.row].t2img ?? "https://g.cricapi.com/img/teams/6-637877070670541994.webp")
            cell.team2Image.downloadImage(from: url2!)
            return cell
        }
    }
    
    
}

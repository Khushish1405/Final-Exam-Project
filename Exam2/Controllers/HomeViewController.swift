//
//  HomeViewController.swift
//  Exam2
//
//  Created by Shubhamsinh Rahevar on 22/02/23.
//

import UIKit
import FirebaseAuth
import CoreData
import Alamofire

class HomeViewController: UIViewController {
    
    
    var apiManager = APIManager()
    
    
    var recentArr = [Score]()
    var liveArr = [Score]()
    var upcomingArr = [Score]()
    var ResultArr = [Score]()
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var tableView: UITableView!
    var scoreData: ScoreModel?
    var scoreDataAF: ScoreModel?
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        UserDefaults.standard.removeObject(forKey: "email")
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJson()
//        scoreDataAF = apiManager.getData()
//        getData()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        self.navigationItem.hidesBackButton = true
        liveArr = arrSorted(arr: liveArr)
        for data in liveArr {
            print(data.dateTimeGMT)
        }
        
//        liveArr.sorted(by: liveArr)
    }
    
    func arrSorted(arr:[Score]) -> [Score] {
        
        var dataArr:[Score] = []
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        for data in arr{
            let sorted = dateFormatter.date(from: data.dateTimeGMT)
            
            if sorted != nil {
                dataArr.append(data)
            }
        }
        
        var testDecendingArr = dataArr.sorted(by: {  $0.dateTimeGMT.compare($1.dateTimeGMT) == .orderedDescending })
        return testDecendingArr
    }
    
    
    func getData(){
        let url = "https://run.mocky.io/v3/12e20d2c-ddcb-4bbb-b0f7-98ae3c5cce2f"
        
        AF.request(url, method: .get, encoding: URLEncoding.default)
            .response(){ response in
                switch response.result{
                case .success(let data):
                    do{
                        print("Success")
                        let jsonData = try JSONDecoder().decode(ScoreModel.self, from: data!)
                        self.scoreData = jsonData
                        print("Shubham alamofire thi data aai gayo che")
                        print(self.scoreDataAF)
                        
                        
                        
                        
                        let singleData = self.scoreData?.data ?? []
                        for i in 0..<singleData.count{
                            if singleData[i].ms == "live"{
                                self.liveArr.append(singleData[i])
                                self.recentArr.append((singleData[i]))
                            }
                            else if singleData[i].ms == "fixture"{
                                self.upcomingArr.append(singleData[i])
                            }
                            else if singleData[i].ms == "result"{
                                self.ResultArr.append(singleData[i])
                            }
                            else{
                                self.recentArr.append(singleData[i])
                            }
                        }
                                        
                      }
                        
                        
                        
                        
                        
                        
                    catch{
                        print("error")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    
    
    func loadJson() {
        if let path = Bundle.main.path(forResource: "CricketScore", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let jsonData = try JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
                print("Shubham")
                print(jsonData)
                let jsonDecoder = JSONDecoder()
                
//                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                scoreData = try jsonDecoder.decode(ScoreModel?.self, from: jsonData)
                
                
                let singleData = scoreData?.data ?? []
                for i in 0..<singleData.count{
                    if singleData[i].ms == "live"{
                        liveArr.append(singleData[i])
                        recentArr.append((singleData[i]))
                    }
                    else if singleData[i].ms == "fixture"{
                        upcomingArr.append(singleData[i])
                    }
                    else if singleData[i].ms == "result"{
                        ResultArr.append(singleData[i])
                    }
                    else{
                        recentArr.append(singleData[i])
                    }
                }
                                
              } catch {
                  print(error)
                   // handle error
              }
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 6
        }
        else if section == 1{
            return 1
        }
        else if section == 2{
            return 1
        }
        else{
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = UIFont.systemFont(ofSize: 24)
        header?.textLabel?.textColor = .blue
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Recent matches"
        }
        else if section == 1{
            return "Live Matches"
        }
        else if section == 2{
            return "Upcoming matches"
        }
        else{
            return "Result Matches"
        }

    }

    
    //MARK: - Custom Footer button
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40.0))
        footerView.backgroundColor = .orange
        
        let button = UIButton(frame: footerView.bounds)
        
        if section == 0 {
            button.tag = 1
            button.setTitle("View All Recent Matches", for: .normal)
        } else if section == 1 {
            button.tag = 2
            button.setTitle("View All Live Matches", for: .normal)
        } else if section == 2 {
            button.tag = 3
            button.setTitle("View All Upcoming Matches", for: .normal)
        } else {
            button.setTitle("View All Result Matches", for: .normal)
        }
        
        button.backgroundColor = .red
        
        button.addTarget(self, action: #selector(btnViewClicked(sender:)), for: .touchUpInside)
        
        footerView.addSubview(button)
        
        return footerView
    }
    
    @objc func btnViewClicked(sender: UIButton) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "SeeAllViewController") as! SeeAllViewController
        
        
        if sender.tag == 1{
            destinationVC.selectedArr = liveArr
            
        }
        else if sender.tag == 2{
            destinationVC.selectedArr = liveArr
        }
        else if sender.tag == 3{
            destinationVC.selectedArr = upcomingArr
        }
        else{
            destinationVC.selectedArr = ResultArr
        }
        navigationController?.pushViewController(destinationVC, animated: true)
        print("Button Pressed..!!")
        
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    //MARK: - Save to database
    
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
            self.present(alert, animated: true, completion: nil)
//            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//            let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "tableViewController") as! tableViewController
//            navigationController?.pushViewController(destinationVC, animated: true)
        } catch let error as NSError {
            print(error)
        }
    }

    
    //MARK: - TableView
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if indexPath.row < 6 && self.liveArr.count > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreTableViewCell", for: indexPath) as! ScoreTableViewCell
                
                let url1 = URL(string: liveArr[indexPath.row].t1img ?? "https://g.cricapi.com/img/teams/31-637877061080567215.webp")
                cell.team1Image.downloadImage(from: url1!)
                cell.team1Image.layer.cornerRadius = 32.5
                
                let url2 = URL(string: liveArr[indexPath.row].t2img ?? "https://g.cricapi.com/img/teams/6-637877070670541994.webp")
                cell.team2Image.downloadImage(from: url2!)
                cell.team2Image.layer.cornerRadius = 32.5
                
                cell.team1Name.text = liveArr[indexPath.row].t1
                cell.team2Name.text = liveArr[indexPath.row].t2
                
                cell.team1Score.text = liveArr[indexPath.row].t1s
                cell.team2Score.text = liveArr[indexPath.row].t2s
                
                cell.matchSituationLabel.text = liveArr[indexPath.row].status
                cell.tourLabel.text = "\(liveArr[indexPath.row].t2) tour of \(liveArr[indexPath.row].t1)"
                
                cell.index = indexPath.row
                cell.onClickClosure = {index in
                    if let indexp = index{
                        self.saveDataTODatabase(index: indexp, team1Name: (self.liveArr[indexPath.row].t1), team2Name: (self.liveArr[indexPath.row].t2), team1Score: (self.liveArr[indexPath.row].t1s), team2Score: (self.liveArr[indexPath.row].t2s), team1Img: (self.liveArr[indexPath.row].t1img ?? "https://g.cricapi.com/img/teams/6-637877070670541994.webp"), team2Img: (self.liveArr[indexPath.row].t2img ?? "https://g.cricapi.com/img/teams/6-637877070670541994.webp"))
                    }
                }
                
                return cell
            }
        }
        
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveTableViewCell", for: indexPath) as! LiveTableViewCell
            cell.liveArr = liveArr
            cell.score = scoreData
            cell.collectionView.tag = indexPath.section
            cell.collectionView.reloadData()
            return cell
            
        }
        if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveTableViewCell", for: indexPath) as! LiveTableViewCell
            cell.upcomingArr = upcomingArr
            cell.score = scoreData
            cell.collectionView.tag = indexPath.section

            cell.collectionView.reloadData()
            return cell
        }
        if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveTableViewCell", for: indexPath) as! LiveTableViewCell
            cell.ResultArr = ResultArr
            cell.score = scoreData
            cell.collectionView.tag = indexPath.section

            cell.collectionView.reloadData()
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        destinationVC.selectedArr = [liveArr[indexPath.row]]
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}


//MARK: - Download image from url

extension UIImageView{
    func downloadImage(from url: URL){
        contentMode = .scaleToFill
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil{
                let image = UIImage(data: data)
                DispatchQueue.main.async{
                    self.image = image
                }
            }else{
                return
            }
        }
        task.resume()
    }
}


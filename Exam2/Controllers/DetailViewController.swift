//
//  DetailViewController.swift
//  Exam2
//
//  Created by Shubhamsinh Rahevar on 02/03/23.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedArr: [Score] = []
    
    
    @IBOutlet weak var team1Image: UIImageView!
    @IBOutlet weak var team2Image: UIImageView!
    @IBOutlet weak var team1Name: UILabel!
    @IBOutlet weak var team2Name: UILabel!
    @IBOutlet weak var team1Score: UILabel!
    @IBOutlet weak var team2Score: UILabel!
    @IBOutlet weak var matchStatus: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        team1Name.text = selectedArr[0].t1
        team2Name.text = selectedArr[0].t2
        team1Score.text = selectedArr[0].t1s
        team2Score.text = selectedArr[0].t2s
        matchStatus.text = selectedArr[0].status
        let url1 = URL(string: selectedArr[0].t1img ?? "https://g.cricapi.com/img/teams/31-637877061080567215.webp")
        team1Image.downloadImage(from: url1!)
        
        let url2 = URL(string: selectedArr[0].t2img ?? "https://g.cricapi.com/img/teams/31-637877061080567215.webp")
        team2Image.downloadImage(from: url2!)
        
    }
    

}

//
//  SavedDataTableViewCell.swift
//  Exam2
//
//  Created by Shubhamsinh Rahevar on 23/02/23.
//

import UIKit

class SavedDataTableViewCell: UITableViewCell {

    @IBOutlet weak var team1Name: UILabel!
    @IBOutlet weak var team2name: UILabel!
    
    @IBOutlet weak var team1Score: UILabel!
    @IBOutlet weak var team2Score: UILabel!
    
    @IBOutlet weak var team1Image: UIImageView!
    @IBOutlet weak var team2Image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    

}

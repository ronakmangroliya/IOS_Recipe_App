//
//  FavListTableViewCell.swift
//  IOS_API_Project
//
//  Created by user235740 on 12/10/23.
//

import UIKit

class FavListTableViewCell: UITableViewCell {

    @IBOutlet weak var RecipeName: UILabel!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

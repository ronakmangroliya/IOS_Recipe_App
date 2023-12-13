//
//  RecipeCell.swift
//  IOS_API_Project
//
//  Created by user235740 on 11/30/23.
//

import UIKit

class RecipeCell: UITableViewCell {

  //  @IBOutlet weak var RecipeLabel: UILabel!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    
    @IBOutlet weak var details: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

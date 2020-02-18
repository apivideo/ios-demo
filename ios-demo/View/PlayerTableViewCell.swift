//
//  PlayerTableViewCell.swift
//  sdkApiVideoExempleApp
//
//  Created by romain PETIT on 04/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var nbCellLabel: UILabel!
    @IBOutlet weak var logoPlayerImageView: UIImageView!
    @IBOutlet weak var playerIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(player: Player, nb: String){
        nbCellLabel.text = "\(nb)."
        logoPlayerImageView.image = try? UIImage(data: Data(contentsOf: URL(fileURLWithPath: player.assets?.logo ?? "https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwi55rOa6ZvmAhVixoUKHU5cDhQQjRx6BAgBEAQ&url=https%3A%2F%2Fhelpx.adobe.com%2Ffr%2Fstock%2Fhow-to%2Fvisual-reverse-image-search.html&psig=AOvVaw3glP91Fnwhma_CF87bVnOO&ust=1575543003775099")))
        playerIdLabel.text = player.playerId
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

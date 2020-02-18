//
//  LiveStreamTableViewCell.swift
//  sdkApiVideoExempleApp
//
//  Created by romain PETIT on 26/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo

class LiveStreamTableViewCell: UITableViewCell {

    @IBOutlet weak var nbCellLabel: UILabel!
    @IBOutlet weak var liveStreamIdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(live: LiveStream, nb: String){
        nbCellLabel.text = "\(nb)."
        liveStreamIdLabel.text = live.liveStreamId
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

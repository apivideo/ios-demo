//
//  LiveStreamTableViewCell.swift
//  ios-demo
//
//  Created by romain PETIT on 02/03/2020.
//  Copyright © 2020 romain PETIT. All rights reserved.
//

import UIKit
import sdkApiVideo

class LiveStreamTableViewCell: UITableViewCell {

    @IBOutlet weak var liveStreamIdLabel: UILabel!
    @IBOutlet weak var nbCellLabel: UILabel!
    
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

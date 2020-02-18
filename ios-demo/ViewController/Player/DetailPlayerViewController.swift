//
//  DetailPlayerViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by romain PETIT on 04/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo

class DetailPlayerViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var playerId: String?
    var player: Player!
    var playerApi: PlayerApi!
    
    @IBOutlet weak var playerIdLabel: UILabel!
    @IBOutlet weak var shapeMarginLabel: UILabel!
    @IBOutlet weak var shapeRadiusLabel: UILabel!
    @IBOutlet weak var shapeAspectLabel: UILabel!
    @IBOutlet weak var shapeBackgroundTopLabel: UILabel!
    @IBOutlet weak var shapeBackgroundBottomLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var linkHoverLabel: UILabel!
    @IBOutlet weak var linkActiveLabel: UILabel!
    @IBOutlet weak var trackPlayedLabel: UILabel!
    @IBOutlet weak var trackUnplayedLabel: UILabel!
    @IBOutlet weak var trackBackgroundLabel: UILabel!
    @IBOutlet weak var backgroundTopLabel: UILabel!
    @IBOutlet weak var backgroundBottomLabel: UILabel!
    @IBOutlet weak var backgroundTextLabel: UILabel!
    @IBOutlet weak var enableApiLabel: UILabel!
    @IBOutlet weak var enableControlsLabel: UILabel!
    @IBOutlet weak var forceAutoplayLabel: UILabel!
    @IBOutlet weak var hideTitleLabel: UILabel!
    @IBOutlet weak var forceLoopLabel: UILabel!
    @IBOutlet weak var logoAssetsLabel: UILabel!
    @IBOutlet weak var linkAssetsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerApi = appDelegate.authClient.playerApi
        self.playerApi.getPlayerById(playerId: self.playerId!){(player, resp) in
            if(resp != nil){
                print("getPlayerById error : \(String(describing: resp?.statusCode)) -> \(String(describing: resp?.message))")
            }else{
                self.player = player
            }
        }
        playerIdLabel.text = "Player: \(self.player.playerId)"
        shapeMarginLabel.text = self.player.shapeMargin.description
        shapeRadiusLabel.text = self.player.shapeRadius.description
        shapeAspectLabel.text = self.player.shapeAspect
        shapeBackgroundTopLabel.text = self.player.shapeBackgroundTop
        shapeBackgroundBottomLabel.text = self.player.shapeBackgroundBottom
        textLabel.text = self.player.text
        linkLabel.text = self.player.link
        linkHoverLabel.text = self.player.linkHover
        linkActiveLabel.text = self.player.linkActive
        trackPlayedLabel.text = self.player.trackPlayed
        trackUnplayedLabel.text = self.player.trackUnplayed
        trackBackgroundLabel.text = self.player.trackBackground
        backgroundTopLabel.text = self.player.backgroundTop
        backgroundBottomLabel.text = self.player.backgroundBottom
        backgroundTextLabel.text = self.player.backgroundText
        enableApiLabel.text = self.player.enableApi.description
        enableControlsLabel.text = self.player.enableControls.description
        forceAutoplayLabel.text = self.player.forceAutoplay.description
        hideTitleLabel.text = self.player.hideTitle.description
        forceLoopLabel.text = self.player.forceLoop.description
        logoAssetsLabel.text = self.player.assets?.logo
        linkAssetsLabel.text = self.player.assets?.link
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "editPlayerSegue"){
            let destination = segue.destination as? EditPlayerViewController
            destination?.player = self.player
        }
    }
    

}

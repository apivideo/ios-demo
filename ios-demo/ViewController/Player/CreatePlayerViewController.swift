//
//  CreatePlayerViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by romain PETIT on 03/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo

class CreatePlayerViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var playerApi: PlayerApi!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerApi = appDelegate.authClient.playerApi
    }
    
    @IBAction func createPlayer(_ sender: Any) {
        let player = Player(playerId: "1", shapeMargin: Int64(10), shapeRadius: Int64(3), shapeAspect: "flat", shapeBackgroundTop: "rgba(50, 50, 50, .7)", shapeBackgroundBottom: "rgba(50, 50, 50, .8)", text: "rgba(255, 255, 255, .95)", link: "rgba(255, 0, 0, .95)", linkHover: "rgba(255, 255, 255, .75)", linkActive: "rgba(255, 0, 0, .75)", trackPlayed: "rgba(255, 255, 255, .95)", trackUnplayed: "rgba(255, 255, 255, .1)", trackBackground: "rgba(0, 0, 0, 0)", backgroundTop: "rgba(72, 4, 45, 1)", backgroundBottom: "rgba(94, 95, 89, 1)", backgroundText: "rgba(255, 255, 255, .95)", enableApi: false, enableControls: true, forceAutoplay: true, hideTitle: true, forceLoop: false, assets: nil, language: "en", createdAt : "", updatedAt: "")
        
        
        self.playerApi.createPlayer(player: player){(created, resp) in
            if(resp != nil){
                print("response create player: \(String(describing: resp?.statusCode)) -> \(String(describing: resp?.message))")
            }
            if created{
                print("the new player has been correctly created !")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
}

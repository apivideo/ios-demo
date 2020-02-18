//
//  PlayerViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by romain PETIT on 03/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo
class PlayersViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var players: [Player]?
    var playerApi: PlayerApi!

    @IBOutlet weak var playersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerApi = appDelegate.authClient.playerApi
        self.playersTableView.delegate = self
        self.playersTableView.dataSource = self
        self.playerApi.getAllPlayers(){ (players, resp) in
            if(resp?.statusCode == nil){
                self.players = players
            }else{
                print("OH OH OH \(String(describing: resp?.message))")
            }
            
        }
        playersTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.players?.removeAll()
        self.playerApi.getAllPlayers(){ (players, resp) in
            if(resp?.statusCode == nil){
                self.players = players
            }else{
                print("OH OH OH \(String(describing: resp?.message))")
            }
        }
        playersTableView.reloadData()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "detailPlayerSegue"){
            let destination = segue.destination as? DetailPlayerViewController
            let playerIndex = playersTableView.indexPathForSelectedRow?.row
            destination?.playerId = self.players?[playerIndex!].playerId
        }
    }
}

extension PlayersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.players?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell") as? PlayerTableViewCell else { fatalError("wrong cell type")}
        cell.configure(player: self.players![indexPath.row], nb: (indexPath.row + 1).description)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //let playerApi = PlayerApi(tokenType: self.type, key: self.accessToken)
            // Delete the row from the data source
            self.playerApi.deletePlayer(playerId: (self.players?[indexPath.row].playerId)!){ (deleted, resp) in
                if(resp != nil){
                    print("error: \((resp?.statusCode)!) -> \((resp?.message)!)")
                }else{
                    if deleted{
                        DispatchQueue.main.async {
                            self.players?.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            }
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

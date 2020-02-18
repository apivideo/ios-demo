//
//  LiveStreamsViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by romain PETIT on 26/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo
class LiveStreamsViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var livesStream : [LiveStream]?
    var liveStreamApi: LiveStreamApi!

    @IBOutlet weak var livesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.liveStreamApi = appDelegate.authClient.liveStreamApi
        self.livesTableView.delegate = self
        self.livesTableView.dataSource = self
        
        self.liveStreamApi.getAllLiveStreams(){ (lives, resp) in
            if(resp?.statusCode == nil){
                self.livesStream = lives
            }else{
                print("error \(String(describing: resp?.message))")
            }
        }
        livesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.livesStream?.removeAll()
        self.liveStreamApi.getAllLiveStreams(){ (lives, resp) in
            if(resp?.statusCode == nil){
                self.livesStream = lives
            }else{
                print("error \(String(describing: resp?.message))")
            }
        }
        livesTableView.reloadData()
    }

    
    @IBAction func createLive(_ sender: Any) {
        self.liveStreamApi.create(name: "stream de qualité", record: true, playerId: "pt1AqN3FPhLW6JcVfblzQEI2"){ (created, resp) in
            if(resp != nil){
                print("response create live stream: \(String(describing: resp?.statusCode)) -> \(String(describing: resp?.message))")
            }
            if created{
                DispatchQueue.main.async {
                    self.liveStreamApi.getAllLiveStreams(){ (lives, resp) in
                        if(resp?.statusCode == nil){
                            self.livesStream = lives
                        }else{
                            print("error \(String(describing: resp?.message))")
                        }
                    }
                    self.livesTableView.reloadData()
                }
            }
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailLiveStreamSegue"){
            let destination = segue.destination as? DetailLiveStreamViewController
            let liveIndex = livesTableView.indexPathForSelectedRow?.row
            destination?.liveStreamId = self.livesStream?[liveIndex!].liveStreamId
        }
    }
}

extension LiveStreamsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.livesStream?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LiveStreamCell") as? LiveStreamTableViewCell else { fatalError("wrong cell type")}
        cell.configure(live: self.livesStream![indexPath.row], nb: (indexPath.row + 1).description)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.liveStreamApi.deleteLiveStream(liveStreamId: (self.livesStream?[indexPath.row].liveStreamId)!){ (deleted, resp) in
                if(resp != nil){
                    print("error: \((resp?.statusCode)!) -> \((resp?.message)!)")
                }else{
                    if deleted{
                        DispatchQueue.main.async {
                            self.livesStream?.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            }
            tableView.reloadData()
        } else if editingStyle == .insert {
        }
    }
}

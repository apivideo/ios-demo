//
//  VideosTableViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by Romain on 07/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo

class VideosTableViewController: UITableViewController {
    var videos: [Video] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var videoApi: VideoApi!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoApi = appDelegate.authClient.videoApi
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        self.videos.removeAll()
        videoApi.getAllVideos(){ (vids, resp) in
            if(resp != nil && resp?.statusCode != "200"){
                print("Error => \((resp?.statusCode)!) : \((resp?.message)!)")
            }else{
                self.videos = vids
            }
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = "\(videos[indexPath.row].title)"
        cell.detailTextLabel?.text = "\(videos[indexPath.row].sourceVideo.uri)"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var isDeleted = false
        if editingStyle == .delete {
            // Delete the row from the data source
            self.videoApi.deleteVideo(videoId: self.videos[indexPath.row].videoId){ (deleted, resp) in
                isDeleted = deleted
            }
            if isDeleted{
                self.videos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "detailVideoSegue"){
            let destination = segue.destination as? DetailVideoViewController
            let videoIndex = tableView.indexPathForSelectedRow?.row            
            destination?.videoId = videos[videoIndex!].videoId
        }
    }
    

}

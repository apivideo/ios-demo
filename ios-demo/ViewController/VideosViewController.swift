//
//  VideosViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by Romain on 02/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "videoCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VideoTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! VideoTableViewCell
        
        cell.titreVideoLabel.text = "test"
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  DetailVideoViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by Romain on 14/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import WebKit
import sdkApiVideo

class DetailVideoViewController: UIViewController {
    @IBOutlet weak var playerWebView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playableLabel: UILabel!
    @IBOutlet weak var firstEncodingStatusLabel: UILabel!
    @IBOutlet weak var secondEncodingStatusLabel: UILabel!
    @IBOutlet weak var thirdEncodingStatusLabel: UILabel!
    @IBOutlet weak var fourthEncodingStatusLabel: UILabel!
    @IBOutlet weak var fifthEncodingStatusLabel: UILabel!
    @IBOutlet weak var widthVideoLabel: UILabel!
    @IBOutlet weak var heightVideoLabel: UILabel!
    @IBOutlet weak var bitrateVideoLabel: UILabel!
    @IBOutlet weak var durationVideoLabel: UILabel!
    @IBOutlet weak var framerateVideoLabel: UILabel!
    @IBOutlet weak var samplerateVideoLabel: UILabel!
    @IBOutlet weak var videoCodecLabel: UILabel!
    @IBOutlet weak var audioCodecLabel: UILabel!
    @IBOutlet weak var aspectRatioVideoLabel: UILabel!
    @IBOutlet weak var statusUploadVideoLabel: UILabel!
    @IBOutlet weak var fileSizeVideoLabel: UILabel!
    @IBOutlet weak var videoChunkTableView: UITableView!
    @IBOutlet weak var heightVideoChunkTableViewConstraint: NSLayoutConstraint!
    
    var videoId: String?
    var video: Video?
    var status: Status?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var videoApi: VideoApi!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoApi = appDelegate.authClient.videoApi
        self.videoApi.getVideoByID(videoId: self.videoId!){ (vid, resp) in
            if(vid != nil){
                self.video = vid
            }
            if(resp != nil){
                print("\((resp?.statusCode)!): \((resp?.message)!)")
            }
        }
        
        let url = URL(string: ("\(video!.assets.player)"))!
        playerWebView.load(URLRequest(url: url))

        self.videoApi.getStatus(videoId: videoId!){ (stat, resp) in
            if(resp != nil && resp?.statusCode != "200"){
                DispatchQueue.main.async {
                    self.firstEncodingStatusLabel.text = "null"
                    self.secondEncodingStatusLabel.text = "null"
                    self.thirdEncodingStatusLabel.text = "null"
                    self.fourthEncodingStatusLabel.text = "null"
                    self.fifthEncodingStatusLabel.text = "null"
                }
            }else{
                if(stat != nil){
                    self.status = stat
                    DispatchQueue.main.async {
                        self.videoChunkTableView.delegate = self
                        self.videoChunkTableView.dataSource = self
                        self.videoChunkTableView.bounces = false
                        self.heightVideoChunkTableViewConstraint.constant = CGFloat((self.status?.ingest.receivedBytes.count ?? 0) * 100)
                        self.statusUploadVideoLabel.text = self.status?.ingest.status
                        self.fileSizeVideoLabel.text = self.status?.ingest.filesize.description
                        if (self.status?.encodingVideo.playable ?? false == true){
                            self.playableLabel.text = "true"
                        }else{
                            self.playableLabel.text = "false"
                        }
                        let count = (self.status?.encodingVideo.qualities.count)!
                        if((self.status?.encodingVideo.qualities.count)! > 0){
                            switch count {
                            case 6:
                                self.firstEncodingStatusLabel.text = self.status?.encodingVideo.qualities[0].status ?? "null"
                                self.secondEncodingStatusLabel.text = self.status?.encodingVideo.qualities[1].status ?? "null"
                                self.thirdEncodingStatusLabel.text = self.status?.encodingVideo.qualities[2].status ?? "null"
                                self.fourthEncodingStatusLabel.text = self.status?.encodingVideo.qualities[3].status ?? "null"
                                self.fifthEncodingStatusLabel.text = self.status?.encodingVideo.qualities[4].status ?? "null"
                            case 5:
                                self.firstEncodingStatusLabel.text = self.status?.encodingVideo.qualities[0].status ?? "null"
                                self.secondEncodingStatusLabel.text = self.status?.encodingVideo.qualities[1].status ?? "null"
                                self.thirdEncodingStatusLabel.text = self.status?.encodingVideo.qualities[2].status ?? "null"
                                self.fourthEncodingStatusLabel.text = self.status?.encodingVideo.qualities[3].status ?? "null"
                                self.fifthEncodingStatusLabel.text = self.status?.encodingVideo.qualities[4].status ?? "null"
                            case 4:
                                self.firstEncodingStatusLabel.text = self.status?.encodingVideo.qualities[0].status ?? "null"
                                self.secondEncodingStatusLabel.text = self.status?.encodingVideo.qualities[1].status ?? "null"
                                self.thirdEncodingStatusLabel.text = self.status?.encodingVideo.qualities[2].status ?? "null"
                                self.fourthEncodingStatusLabel.text = self.status?.encodingVideo.qualities[3].status ?? "null"
                                self.fifthEncodingStatusLabel.text = "null"
                            case 3:
                                self.firstEncodingStatusLabel.text = self.status?.encodingVideo.qualities[0].status ?? "null"
                                self.secondEncodingStatusLabel.text = self.status?.encodingVideo.qualities[1].status ?? "null"
                                self.thirdEncodingStatusLabel.text = self.status?.encodingVideo.qualities[2].status ?? "null"
                                self.fourthEncodingStatusLabel.text = "null"
                                self.fifthEncodingStatusLabel.text = "null"
                            case 2:
                                self.firstEncodingStatusLabel.text = self.status?.encodingVideo.qualities[0].status ?? "null"
                                self.secondEncodingStatusLabel.text = self.status?.encodingVideo.qualities[1].status ?? "null"
                                self.thirdEncodingStatusLabel.text = "null"
                                self.fourthEncodingStatusLabel.text = "null"
                                self.fifthEncodingStatusLabel.text = "null"
                            case 1:
                                self.firstEncodingStatusLabel.text = self.status?.encodingVideo.qualities[0].status ?? "null"
                                self.secondEncodingStatusLabel.text = "null"
                                self.thirdEncodingStatusLabel.text = "null"
                                self.fourthEncodingStatusLabel.text = "null"
                                self.fifthEncodingStatusLabel.text = "null"
                            default:
                                self.firstEncodingStatusLabel.text = "null"
                                self.secondEncodingStatusLabel.text = "null"
                                self.thirdEncodingStatusLabel.text = "null"
                                self.fourthEncodingStatusLabel.text = "null"
                                self.fifthEncodingStatusLabel.text = "null"
                            }
                        }else{
                            self.firstEncodingStatusLabel.text = "null"
                            self.secondEncodingStatusLabel.text = "null"
                            self.thirdEncodingStatusLabel.text = "null"
                            self.fourthEncodingStatusLabel.text = "null"
                            self.fifthEncodingStatusLabel.text = "null"
                        }
                        self.widthVideoLabel.text = self.status?.encodingVideo.metaData.width?.description ?? "null"
                        self.heightVideoLabel.text = self.status?.encodingVideo.metaData.height?.description ?? "null"
                        self.bitrateVideoLabel.text = self.status?.encodingVideo.metaData.bitrate?.description ?? "null"
                        self.durationVideoLabel.text = self.status?.encodingVideo.metaData.duration?.description ?? "null"
                        self.framerateVideoLabel.text = self.status?.encodingVideo.metaData.framerate?.description ?? "null"
                        self.samplerateVideoLabel.text = self.status?.encodingVideo.metaData.samplerate?.description ?? "null"
                        self.videoCodecLabel.text = self.status?.encodingVideo.metaData.videoCodec ?? "null"
                        self.audioCodecLabel.text = self.status?.encodingVideo.metaData.audioCodec ?? "null"
                        if(self.status?.encodingVideo.metaData.aspectRatio == nil){
                            self.aspectRatioVideoLabel.text = "null"
                        }else{
                            self.aspectRatioVideoLabel.text = self.status?.encodingVideo.metaData.aspectRatio
                        }
                    }
                }
            }
        }
        titleLabel.text = video?.title
        descriptionLabel.text = video?.description
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoApi.getVideoByID(videoId: self.videoId!){ (vid, resp) in
            if(vid != nil){
                self.video = vid
            }
        }
        titleLabel.text = video?.title
        descriptionLabel.text = video?.description
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "editVideoSegue"){
            let destination = segue.destination as? EditVideoViewController
            destination?.video = self.video
        }
    }
}

extension DetailVideoViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.status?.ingest.receivedBytes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoChunkCell") as? VideoChunkTableViewCell else { fatalError("wrong cell type")}
        let currentChunk = (self.status?.ingest.receivedBytes[indexPath.row])!
        cell.configure(receivedBytes: currentChunk, nb: (indexPath.row + 1).description)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

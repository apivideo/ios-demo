//
//  LiveStreamControlViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by romain PETIT on 07/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo
import AVFoundation

class LiveStreamControlViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var liveStream : LiveStream?
    var liveStreamApi: LiveStreamApi!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var captureQualitySelected = ""
    var streamQualitySelected = ""

    @IBOutlet weak var StartingLiveStreamLabel: UILabel!
    @IBOutlet weak var StartingLiveStreamSwitch: UISwitch!
    @IBOutlet weak var CaptureQualitiesPickerView: UIPickerView!
    @IBOutlet weak var StreamQualitiesPickerView: UIPickerView!
    @IBOutlet weak var CameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //API\\
        self.liveStreamApi = appDelegate.authClient.liveStreamApi
        
        //CAMERA\\
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1280x720
        
        StartingLiveStreamLabel.text = StartingLiveStreamSwitch.isOn == true ? "Stop Stream" : "Start Stream"
        self.CaptureQualitiesPickerView.delegate = self
        self.CaptureQualitiesPickerView.dataSource = self
        self.StreamQualitiesPickerView.delegate = self
        self.StreamQualitiesPickerView.dataSource = self
        
        if let index: Int = self.liveStreamApi.qualities.firstIndex(of: "720p"){
            self.CaptureQualitiesPickerView.selectRow(index, inComponent: 0, animated: true)
            self.captureQualitySelected = self.liveStreamApi.qualities[self.CaptureQualitiesPickerView.selectedRow(inComponent: 0)]
            self.StreamQualitiesPickerView.selectRow(index, inComponent: 0, animated: true)
            self.streamQualitySelected = self.liveStreamApi.qualities[self.StreamQualitiesPickerView.selectedRow(inComponent: 0)]
        }
    }
    
    
    @IBAction func StartLive(_ sender: Any) {
        StartingLiveStreamLabel.text = StartingLiveStreamSwitch.isOn == true ? "Stop Stream" : "Start Stream"
        if StartingLiveStreamSwitch.isOn {
            self.liveStreamApi.StartLiveStreamFlux(liveStream: liveStream!, captureQuality: captureQualitySelected, streamQuality: streamQualitySelected, fps: 24.0)
        }else{
            self.liveStreamApi.StopLiveStreamFlux()
        }
        
    }
    
    @IBAction func ChangeCamera(_ sender: Any) {
        self.liveStreamApi.rotateCamera()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.liveStreamApi.qualities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.liveStreamApi.qualities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == CaptureQualitiesPickerView){
            self.captureQualitySelected = self.liveStreamApi.qualities[row]
        }
        if(pickerView == StreamQualitiesPickerView){
            self.streamQualitySelected = self.liveStreamApi.qualities[row]
        }
    }
}

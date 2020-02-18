//
//  EditLiveViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by romain PETIT on 26/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo
class EditLiveViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var liveStream: LiveStream!
    var players: [Player] = []
    var playersIdPicker = ["none"]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var playerApi: PlayerApi!
    var liveStreamApi: LiveStreamApi!
    var selectedPlayerId = ""
    var newName: String?
    var newRecord: Bool?
    var newPlayerId : String?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var isRecordingSwitch: UISwitch!
    @IBOutlet weak var playerIdPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerIdPickerView.delegate = self
        self.playerIdPickerView.dataSource = self
        self.playerApi = appDelegate.authClient.playerApi
        self.liveStreamApi = appDelegate.authClient.liveStreamApi

        getAllPlayers(){(completed, resp) in
            if completed{
                for player in self.players{
                    self.playersIdPicker.append(player.playerId)
                }
            }
        }
        nameTextField.text = liveStream.name
        isRecordingSwitch.isOn = liveStream.record
    }
    
    private func getAllPlayers(completion: @escaping(Bool, Response?)->()){
        self.playerApi.getAllPlayers(){(players, resp) in
            if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                completion(false, resp)
            }else{
                self.players = players
                completion(true, resp)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.playersIdPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.playersIdPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedPlayerId = self.playersIdPicker[row]
    }
    
    @IBAction func updateLive(_ sender: Any) {
        if(nameTextField.text != liveStream.name){
            self.newName = nameTextField.text
        }
        if(isRecordingSwitch.isOn.description != liveStream.record.description){
            self.newRecord = isRecordingSwitch.isOn
        }
        if(self.selectedPlayerId != liveStream.playerId){
            if(self.selectedPlayerId == ""){
                self.newPlayerId = nil
            }
            self.newPlayerId = self.selectedPlayerId
        }
        self.liveStreamApi.updateLiveStream(liveId: liveStream.liveStreamId, name: newName, record: newRecord, playerId: newPlayerId){(updated, resp) in
            if updated{
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                print("\((resp?.statusCode)!) : \((resp?.message)!)")
            }
        }
        
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

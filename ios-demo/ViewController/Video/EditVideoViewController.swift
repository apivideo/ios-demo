//
//  EditVideoViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by romain PETIT on 16/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo

class EditVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var videoApi: VideoApi!
    var filePath = ""
    var fileName = ""
    var url: URL!
    var image: UIImage!
    let imagePickerController = UIImagePickerController()
    var video: Video?
    var videoUpdated: Video?
    var resp: Response?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var thumbnailSegmentedControl: UISegmentedControl!
    @IBOutlet weak var thumbnailSwitch: UISwitch!
    @IBOutlet weak var timecodeView: UIView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var timeCodeTextField: UITextField!
    @IBOutlet weak var imageThumbnailImageView: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoApi = appDelegate.authClient.videoApi
        titleTextField.text = video?.title
        descriptionTextField.text = video?.description
        videoUpdated = video
        self.imageView.isHidden = true
        self.timecodeView.isHidden = true
    }
    
    @IBAction func unableThumbnail(_ sender: Any) {
        if thumbnailSwitch.isOn{
            thumbnailSegmentedControl.isEnabled = true
            if(thumbnailSegmentedControl.selectedSegmentIndex == 0 ){
                self.timecodeView.isHidden = false
            }
            if(thumbnailSegmentedControl.selectedSegmentIndex == 1 ){
                self.imageView.isHidden = false
            }
        }else{
            thumbnailSegmentedControl.isEnabled = false
            self.timecodeView.isHidden = true
            self.imageView.isHidden = true
        }
    }
    
    @IBAction func selectThumbnail(_ sender: Any) {
        switch thumbnailSegmentedControl.selectedSegmentIndex{
        case 0:
            self.timecodeView.isHidden = false
            self.imageView.isHidden = true
        case 1:
            self.timecodeView.isHidden = true
            self.imageView.isHidden = false
        default:
            break
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let file = info[.originalImage] as! UIImage
        let fileUrl = info[.imageURL] as! URL
        
        self.fileName = fileUrl.lastPathComponent
        self.filePath = fileUrl.absoluteString
        self.url = fileUrl
        self.image = file
        
        imageThumbnailImageView.image = file
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectImage(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.allowsEditing = false
        imagePickerController.videoQuality = .typeHigh
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func updateVideo(_ sender: Any) {
        videoUpdated?.title = titleTextField.text!
        videoUpdated?.description = descriptionTextField.text!
        videoApi.updateVideo(video: videoUpdated!){(updated, resp) in
            if updated{
                print("video updated")
            }
        }
        if thumbnailSwitch.isOn{
            switch thumbnailSegmentedControl.selectedSegmentIndex {
            case 0:
                self.videoApi.pickThumbnail(videoId: videoUpdated!.videoId, timecode: timeCodeTextField.text!){(updated, resp) in
                    if updated{
                        print("the thumbnail has been correctly changed, but the change will be effective in maximum 1h")
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else{
                        if(resp != nil){
                            print("upload went wrong error \((resp?.statusCode)!) : \((resp?.message)!)")
                        }
                    }
                }
            case 1:
                let imageData:Data = self.image.pngData()!
                self.videoApi.uploadImageThumbnail(videoId: videoUpdated!.videoId, url: self.url, filePath: self.filePath, fileName: self.fileName, imageData: imageData){(updated, resp) in
                    if updated{
                        print("image has been correctly added of thumbnail")
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else{
                        if(resp != nil){
                            print("upload went wrong error \((resp?.statusCode)!) : \((resp?.message)!)")
                        }
                    }
                }
            default:
                break
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

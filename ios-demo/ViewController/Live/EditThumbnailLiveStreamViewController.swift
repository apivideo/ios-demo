//
//  EditThumbnailLiveStreamViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by romain PETIT on 30/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo

class EditThumbnailLiveStreamViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    let imagePickerController = UIImagePickerController()
    var liveStream: LiveStream!
    var filePath = ""
    var fileName = ""
    var url: URL!
    var image: UIImage!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var liveStreamApi: LiveStreamApi!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.liveStream!)
        self.liveStreamApi = appDelegate.authClient.liveStreamApi
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let file = info[.originalImage] as! UIImage
        let fileUrl = info[.imageURL] as! URL
        
        self.fileName = fileUrl.lastPathComponent
        self.filePath = fileUrl.absoluteString
        self.url = fileUrl
        self.image = file
        
        thumbnailImageView.image = file
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageThumbnail(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.allowsEditing = false
        imagePickerController.videoQuality = .typeHigh
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func uploadThumbnail(_ sender: Any) {
        let imageData: Data = self.image.pngData()!
        self.liveStreamApi.uploadImageThumbnail(liveStreamId: self.liveStream.liveStreamId, url: self.url, filePath: self.filePath, fileName: self.fileName, imageData: imageData){(uploaded, resp)in
            if uploaded{
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

//
//  ViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by Romain on 01/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo
import AVKit

class UploadVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var UploadButton: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    let imagePickerController = UIImagePickerController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var filePath = ""
    var fileName = ""
    var url: URL!
    var videoApi: VideoApi!
    var mediaAspectRatio: Double!
    let alertOk = UIAlertController(title: "Uploaded", message: "La video est upload", preferredStyle: .alert)
    let alertAsync = UIAlertController(title: "Do this task in background", message: "uploading...", preferredStyle: .alert)
    let alertLoading = UIAlertController(title: nil, message: "uploading...", preferredStyle: .alert)
    let badAlert = UIAlertController(title: "Not Uploaded", message: "il y a eu une erreur quelque part", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoApi = appDelegate.authClient.videoApi
        self.hideKeyboardWhenTappedAround()
        self.alertOk.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        self.badAlert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))
        self.alertAsync.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction!) in
            self.alertAsync.dismiss(animated: true, completion: nil)
        }))
        self.alertAsync.addAction(UIAlertAction(title: "No", style: .default, handler: {(action: UIAlertAction!)in
            self.present(self.alertLoading, animated: true)
        }))
        
        let loadingIndic = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndic.hidesWhenStopped = true
        loadingIndic.style = UIActivityIndicatorView.Style.medium
        loadingIndic.startAnimating();
        self.alertLoading.view.addSubview(loadingIndic)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 60, y: 28, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.color = UIColor.orange
        loadingIndicator.startAnimating()
        self.alertAsync.view.addSubview(loadingIndicator)
        
    }
    
    // MARK: - Select Video
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let file = info[.mediaURL] as! URL
        let lastPath = file.lastPathComponent

        self.filePath = file.absoluteString
        self.fileName = lastPath
        self.url = info[.mediaURL] as? URL
        
        initAspectRatioOfVideo(with: self.url)
        videoNameLabel.text = ("\(file.absoluteString )")
        
        let asset = AVURLAsset(url: file.absoluteURL)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(value: Int64(0), timescale: Int32(1)), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage!)
        
        if(cgImage != nil){
            thumbnailImageView.image = thumbnail
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func initAspectRatioOfVideo(with fileURL: URL) {
      let resolution = resolutionForLocalVideo(url: fileURL)

      guard let width = resolution?.width, let height = resolution?.height else {
         return
      }
        self.mediaAspectRatio = Double(height / width)
    }

    private func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
       let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
    
    func fileSizeInBytes(fromPath path: String) -> UInt64? {
        guard let size = try? FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size],
            let fileSize = size as? UInt64 else {
            return nil
        }
        return fileSize
    }
    
    func fileSizeInMB(fromPath path: String) -> String? {
        guard let size = try? FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size],
            let fileSize = size as? UInt64 else {
            return nil
        }
        var floatSize = Float(fileSize / 1024)
        floatSize = floatSize / 1024
        return String(format: "%.1f MB", floatSize)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        _ = info["UIImagePickerControllerReferenceURL"] as? NSURL
     imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectVideo(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary

        imagePickerController.delegate = self

        imagePickerController.mediaTypes = ["public.movie"]
        
        imagePickerController.allowsEditing = false
        
        imagePickerController.videoQuality = .typeHigh
        
        // for IOS 11 and more
        if #available(iOS 11.0, *) {
            //desable video compressing to get the highest video quality
            imagePickerController.videoExportPreset = AVAssetExportPresetPassthrough
        }

        present(imagePickerController, animated: true, completion: nil)
    }
    // MARK: - Upload Video
    @IBAction func uploadVideo(_ sender: Any) {
        DispatchQueue.main.async {
            self.present(self.alertAsync, animated: true, completion: nil)
        }
        
        self.videoApi.create(title: titleTextField.text!, description: descriptionTextField.text!, fileName: self.fileName, filePath: self.filePath, url: self.url){ (uploaded, resp) in
            if(resp != nil){
                print("error : \((resp?.statusCode)!) -> \((resp?.message)!)")
            }else{
                if(uploaded){
                    DispatchQueue.main.async {
                        self.alertAsync.dismiss(animated: true, completion: nil)
                        self.alertLoading.dismiss(animated: true, completion: nil)
                        self.present(self.alertOk, animated: true)
                    }
                }else{
                    DispatchQueue.main.async {
                        self.alertAsync.dismiss(animated: true, completion: nil)
                        self.alertLoading.dismiss(animated: true, completion: nil)
                        self.present(self.badAlert, animated: true)
                    }
                }
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

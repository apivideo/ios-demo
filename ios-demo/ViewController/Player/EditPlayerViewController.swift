//
//  EditPlayerViewController.swift
//  sdkApiVideoExempleApp
//
//  Created by romain PETIT on 04/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import sdkApiVideo

class EditPlayerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var ShapeMarginTextField: UITextField!
    @IBOutlet weak var ShapeRadiusTextField: UITextField!
    @IBOutlet weak var ShapeAspectTextField: UITextField!
    @IBOutlet weak var RedShapeBackgroundTopTextField: UITextField!
    @IBOutlet weak var GreenShapeBackgroundTopTextField: UITextField!
    @IBOutlet weak var BlueShapeBackgroundTopTextField: UITextField!
    @IBOutlet weak var AlphaShapeBackgroundTopTextField: UITextField!
    @IBOutlet weak var RedShapeBackgroundBottomTextField: UITextField!
    @IBOutlet weak var GreenShapeBackgroundBottomTextField: UITextField!
    @IBOutlet weak var BlueShapeBackgroundBottomTextField: UITextField!
    @IBOutlet weak var AlphaShapeBackgroundBottomTextField: UITextField!
    @IBOutlet weak var RedTextTextField: UITextField!
    @IBOutlet weak var GreenTextTextField: UITextField!
    @IBOutlet weak var BlueTextTextField: UITextField!
    @IBOutlet weak var AlphaTextTextField: UITextField!
    @IBOutlet weak var RedLinkTextField: UITextField!
    @IBOutlet weak var GreenLinkTextField: UITextField!
    @IBOutlet weak var BlueLinkTextField: UITextField!
    @IBOutlet weak var AlphaLinkTextField: UITextField!
    @IBOutlet weak var RedLinkHoverTextField: UITextField!
    @IBOutlet weak var GreenLinkHoverTextField: UITextField!
    @IBOutlet weak var BlueLinkHoverTextField: UITextField!
    @IBOutlet weak var AlphaLinkHoverTextField: UITextField!
    @IBOutlet weak var RedLinkActiveTextField: UITextField!
    @IBOutlet weak var GreenLinkActiveTextField: UITextField!
    @IBOutlet weak var BlueLinkActiveTextField: UITextField!
    @IBOutlet weak var AlphaLinkActiveTextField: UITextField!
    @IBOutlet weak var RedTrackPlayedTextField: UITextField!
    @IBOutlet weak var GreenTrackPlayedTextField: UITextField!
    @IBOutlet weak var BlueTrackPlayedTextField: UITextField!
    @IBOutlet weak var AlphaTrackPlayedTextField: UITextField!
    @IBOutlet weak var RedTrackUnplayedTextField: UITextField!
    @IBOutlet weak var GreenTrackUnplayedTextField: UITextField!
    @IBOutlet weak var BlueTrackUnplayedTextField: UITextField!
    @IBOutlet weak var AlphaTrackUnplayedTextField: UITextField!
    @IBOutlet weak var RedTrackBackgroundTextField: UITextField!
    @IBOutlet weak var GreenTrackBackgroundTextField: UITextField!
    @IBOutlet weak var BlueTrackBackgroundTextField: UITextField!
    @IBOutlet weak var AlphaTrackBackgroundTextField: UITextField!
    @IBOutlet weak var RedBackgroundTopTextField: UITextField!
    @IBOutlet weak var GreenBackgroundTopTextField: UITextField!
    @IBOutlet weak var BlueBackgroundTopTextField: UITextField!
    @IBOutlet weak var AlphaBackgroundTopTextField: UITextField!
    @IBOutlet weak var RedBackgroundBottomTextField: UITextField!
    @IBOutlet weak var GreenBackgroundBottomTextField: UITextField!
    @IBOutlet weak var BlueBackgroundBottomTextField: UITextField!
    @IBOutlet weak var AlphaBackgroundBottomTextField: UITextField!
    @IBOutlet weak var RedBackgroundTextTextField: UITextField!
    @IBOutlet weak var GreenBackgroundTextTextField: UITextField!
    @IBOutlet weak var BlueBackgroundTextTextField: UITextField!
    @IBOutlet weak var AlphaBackgroundTextTextField: UITextField!
    @IBOutlet weak var EnableApiSwitch: UISwitch!
    @IBOutlet weak var EnableControlsSwitch: UISwitch!
    @IBOutlet weak var ForceAutoPlaySwitch: UISwitch!
    @IBOutlet weak var HideTitleSwitch: UISwitch!
    @IBOutlet weak var ForceLoopSwitch: UISwitch!
    @IBOutlet weak var SelectLogoView: UIView!
    @IBOutlet weak var LogoImageView: UIImageView!
    @IBOutlet weak var LinkLogoTextField: UITextField!
    @IBOutlet weak var EnableLogoSwitch: UISwitch!
    
    let imagePickerController = UIImagePickerController()
    var player: Player!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var playerApi: PlayerApi!
    var filePath = ""
    var fileName = ""
    var url: URL!
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.playerApi = appDelegate.authClient.playerApi

        if EnableLogoSwitch.isOn{
            SelectLogoView.isHidden = false
        }else{
            SelectLogoView.isHidden = true
        }
        
        ShapeMarginTextField.text = self.player.shapeMargin.description
        ShapeRadiusTextField.text = self.player.shapeRadius.description
        ShapeAspectTextField.text = self.player.shapeAspect
        
        let rgbaShapeBackgroundTop = getRGBA(text: self.player.shapeBackgroundTop)
        RedShapeBackgroundTopTextField.text = rgbaShapeBackgroundTop.red
        GreenShapeBackgroundTopTextField.text = rgbaShapeBackgroundTop.green
        BlueShapeBackgroundTopTextField.text = rgbaShapeBackgroundTop.blue
        AlphaShapeBackgroundTopTextField.text = rgbaShapeBackgroundTop.alpha
        
        let rgbaShapeBackgroundBottom = getRGBA(text: self.player.shapeBackgroundBottom)
        RedShapeBackgroundBottomTextField.text = rgbaShapeBackgroundBottom.red
        GreenShapeBackgroundBottomTextField.text = rgbaShapeBackgroundBottom.green
        BlueShapeBackgroundBottomTextField.text = rgbaShapeBackgroundBottom.blue
        AlphaShapeBackgroundBottomTextField.text = rgbaShapeBackgroundBottom.alpha
        
        let rgbaText = getRGBA(text: self.player.text)
        RedTextTextField.text = rgbaText.red
        GreenTextTextField.text = rgbaText.green
        BlueTextTextField.text = rgbaText.blue
        AlphaTextTextField.text = rgbaText.alpha
        
        let rgbaLink = getRGBA(text: self.player.link)
        RedLinkTextField.text = rgbaLink.red
        GreenLinkTextField.text = rgbaLink.green
        BlueLinkTextField.text = rgbaLink.blue
        AlphaLinkTextField.text = rgbaLink.alpha
        
        let rgbaLinkHover = getRGBA(text: self.player.linkHover)
        RedLinkHoverTextField.text = rgbaLinkHover.red
        GreenLinkHoverTextField.text = rgbaLinkHover.green
        BlueLinkHoverTextField.text = rgbaLinkHover.blue
        AlphaLinkHoverTextField.text = rgbaLinkHover.alpha
        
        let rgbaLinkActive = getRGBA(text: self.player.linkActive)
        RedLinkActiveTextField.text = rgbaLinkActive.red
        GreenLinkActiveTextField.text = rgbaLinkActive.green
        BlueLinkActiveTextField.text = rgbaLinkActive.blue
        AlphaLinkActiveTextField.text = rgbaLinkActive.alpha
        
        let rgbaTrackPlayed = getRGBA(text: self.player.trackPlayed)
        RedTrackPlayedTextField.text = rgbaTrackPlayed.red
        GreenTrackPlayedTextField.text = rgbaTrackPlayed.green
        BlueTrackPlayedTextField.text = rgbaTrackPlayed.blue
        AlphaTrackPlayedTextField.text = rgbaTrackPlayed.alpha
        
        let rgbaTrackUnplayed = getRGBA(text: self.player.trackUnplayed)
        RedTrackUnplayedTextField.text = rgbaTrackUnplayed.red
        GreenTrackUnplayedTextField.text = rgbaTrackUnplayed.green
        BlueTrackUnplayedTextField.text = rgbaTrackUnplayed.blue
        AlphaTrackUnplayedTextField.text = rgbaTrackUnplayed.alpha
        
        let rgbaTrackBackground = getRGBA(text: self.player.trackBackground)
        RedTrackBackgroundTextField.text = rgbaTrackBackground.red
        GreenTrackBackgroundTextField.text = rgbaTrackBackground.green
        BlueTrackBackgroundTextField.text = rgbaTrackBackground.blue
        AlphaTrackBackgroundTextField.text = rgbaTrackBackground.alpha
        
        let rgbaBackgroundTop = getRGBA(text: self.player.backgroundTop)
        RedBackgroundTopTextField.text = rgbaBackgroundTop.red
        GreenBackgroundTopTextField.text = rgbaBackgroundTop.green
        BlueBackgroundTopTextField.text = rgbaBackgroundTop.blue
        AlphaBackgroundTopTextField.text = rgbaBackgroundTop.alpha
        
        let rgbaBackgroundBottom = getRGBA(text: self.player.backgroundBottom)
        RedBackgroundBottomTextField.text = rgbaBackgroundBottom.red
        GreenBackgroundBottomTextField.text = rgbaBackgroundBottom.green
        BlueBackgroundBottomTextField.text = rgbaBackgroundBottom.blue
        AlphaBackgroundBottomTextField.text = rgbaBackgroundBottom.alpha
        
        let rgbaBackgroundText = getRGBA(text: self.player.backgroundText)
        RedBackgroundTextTextField.text = rgbaBackgroundText.red
        GreenBackgroundTextTextField.text = rgbaBackgroundText.green
        BlueBackgroundTextTextField.text = rgbaBackgroundText.blue
        AlphaBackgroundTextTextField.text = rgbaBackgroundText.alpha
        
        if self.player.enableApi{
            EnableApiSwitch.setOn(true, animated: false)
        }else{
            EnableApiSwitch.setOn(false, animated: false)
        }
        
        if self.player.enableControls{
            EnableControlsSwitch.setOn(true, animated: false)
        }else{
            EnableControlsSwitch.setOn(false, animated: false)
        }
        
        if self.player.forceAutoplay{
            ForceAutoPlaySwitch.setOn(true, animated: false)
        }else{
            ForceAutoPlaySwitch.setOn(false, animated: false)
        }
        
        if self.player.hideTitle{
            HideTitleSwitch.setOn(true, animated: false)
        }else{
            HideTitleSwitch.setOn(false, animated: false)
        }
        
        if self.player.forceLoop{
            ForceLoopSwitch.setOn(true, animated: false)
        }else{
            ForceLoopSwitch.setOn(false, animated: false)
        }
    }
    
//    Get Red, Green, Blue, Alpha Int value from String
    public func getRGBA(text:String)->RGBA{
        let stringArray = text.components(separatedBy: CharacterSet.decimalDigits.inverted)
        var valueArray: [Int] = []
        for item in stringArray {
            if let number = Int(item) {
                valueArray.append(number)
            }
        }
        let red = valueArray[0].description
        let green = valueArray[1].description
        let blue = valueArray[2].description
        var alpha:String = ""
        if(valueArray.count == 5){
            alpha = ("\(valueArray[3]).\(valueArray[4])")
        }
        if(valueArray.count == 4){
            alpha = valueArray[3].description
        }
        let rgba = RGBA(red: red, green: green, blue: blue, alpha: alpha)
        return rgba
    }
    
    @IBAction func updatePlayer(_ sender: Any) {
        let imageData:Data = self.image.pngData()!
        
        let stringRGBAShapeBackgroundTop = toStringRGBA(red: RedTextTextField.text ?? "0", green: GreenShapeBackgroundTopTextField.text ?? "0", blue: BlueShapeBackgroundTopTextField.text ?? "0", alpha: AlphaShapeBackgroundTopTextField.text  ?? "0")
        
        let stringRGBAShapeBackgroundBottom = toStringRGBA(red: RedShapeBackgroundBottomTextField.text ?? "0", green: GreenShapeBackgroundBottomTextField.text ?? "0", blue: BlueShapeBackgroundBottomTextField.text ?? "0", alpha: AlphaShapeBackgroundBottomTextField.text  ?? "0")
        
        let stringRGBAText = toStringRGBA(red: RedTextTextField.text ?? "0", green: GreenTextTextField.text ?? "0", blue: BlueTextTextField.text ?? "0", alpha: AlphaTextTextField.text  ?? "0")
        
        let stringRGBALink = toStringRGBA(red: RedLinkTextField.text ?? "0", green: GreenLinkTextField.text ?? "0", blue: BlueLinkTextField.text ?? "0", alpha: AlphaLinkTextField.text  ?? "0")
        
        let stringRGBALinkHover = toStringRGBA(red: RedLinkHoverTextField.text ?? "0", green: GreenLinkHoverTextField.text ?? "0", blue: BlueLinkHoverTextField.text ?? "0", alpha: AlphaLinkHoverTextField.text  ?? "0")
        
        let stringRGBALinkActive = toStringRGBA(red: RedLinkActiveTextField.text ?? "0", green: GreenLinkActiveTextField.text ?? "0", blue: BlueLinkActiveTextField.text ?? "0", alpha: AlphaLinkActiveTextField.text  ?? "0")
        
        let stringRGBATrackPlayed = toStringRGBA(red: RedTrackPlayedTextField.text ?? "0", green: GreenTrackPlayedTextField.text ?? "0", blue: BlueTrackPlayedTextField.text ?? "0", alpha: AlphaTrackPlayedTextField.text  ?? "0")
        
        let stringRGBATrackUnplayed = toStringRGBA(red: RedTrackUnplayedTextField.text ?? "0", green: GreenTrackUnplayedTextField.text ?? "0", blue: BlueTrackUnplayedTextField.text ?? "0", alpha: AlphaTrackUnplayedTextField.text  ?? "0")
        
        let stringRGBATrackBackground = toStringRGBA(red: RedTrackBackgroundTextField.text ?? "0", green: GreenTrackBackgroundTextField.text ?? "0", blue: BlueTrackBackgroundTextField.text ?? "0", alpha: AlphaTrackBackgroundTextField.text  ?? "0")
        
        let stringRGBABackgroundTop = toStringRGBA(red: RedBackgroundTopTextField.text ?? "0", green: GreenBackgroundTopTextField.text ?? "0", blue: BlueBackgroundTopTextField.text ?? "0", alpha: AlphaBackgroundTopTextField.text  ?? "0")
        
        let stringRGBABackgroundBottom = toStringRGBA(red: RedBackgroundBottomTextField.text ?? "0", green: GreenBackgroundBottomTextField.text ?? "0", blue: BlueBackgroundBottomTextField.text ?? "0", alpha: AlphaBackgroundBottomTextField.text  ?? "0")
        
        let stringRGBABackgroundText = toStringRGBA(red: RedBackgroundTextTextField.text ?? "0", green: GreenBackgroundTextTextField.text ?? "0", blue: BlueBackgroundTextTextField.text ?? "0", alpha: AlphaBackgroundTextTextField.text  ?? "0")
        
        let shapeMargin = Int64(ShapeMarginTextField.text ?? "10")!
        let shapeRadius = Int64(ShapeRadiusTextField.text ?? "3")!
        let shapeAspect = ShapeAspectTextField.text ?? "flat"
        
        let enableAPI: Bool
        if EnableApiSwitch.isOn{
             enableAPI = true
        }else{
            enableAPI = false
        }
        
        let enableControls: Bool
        if EnableControlsSwitch.isOn {
            enableControls = true
        }else{
            enableControls = false
        }
        
        let forceAutoPlay: Bool
        if ForceAutoPlaySwitch.isOn {
            forceAutoPlay = true
        }else{
            forceAutoPlay = false
        }
        
        let hideTitle: Bool
        if HideTitleSwitch.isOn {
            hideTitle = true
        }else{
            hideTitle = false
        }
        
        let forceLoop: Bool
        if ForceLoopSwitch.isOn{
            forceLoop = true
        }else{
            forceLoop = false
        }
        
        let updatedPlayer = Player(playerId: player.playerId, shapeMargin: shapeMargin, shapeRadius: shapeRadius, shapeAspect: shapeAspect, shapeBackgroundTop: stringRGBAShapeBackgroundTop, shapeBackgroundBottom: stringRGBAShapeBackgroundBottom, text: stringRGBAText, link: stringRGBALink, linkHover: stringRGBALinkHover, linkActive: stringRGBALinkActive, trackPlayed: stringRGBATrackPlayed, trackUnplayed: stringRGBATrackUnplayed, trackBackground: stringRGBATrackBackground, backgroundTop: stringRGBABackgroundTop, backgroundBottom: stringRGBABackgroundBottom, backgroundText: stringRGBABackgroundText, enableApi: enableAPI, enableControls: enableControls, forceAutoplay: forceAutoPlay, hideTitle: hideTitle, forceLoop: forceLoop, assets: nil, language: "en", createdAt: "", updatedAt: "")
        
        self.playerApi.updatePlayer(player: updatedPlayer){(updated, resp) in
            if(resp != nil){
                print("error : \(String(describing: resp?.statusCode)) -> \(String(describing: resp?.message))")
            }else{
                if updated{
                    print("the player have been correctly updated")
                }
            }
        }
        if EnableLogoSwitch.isOn{
            self.playerApi.uploadLogo(playerId: player.playerId, url: self.url, filePath: self.filePath, fileName: self.fileName, imageData: imageData){ (uploaded, resp) in
                if(resp != nil){
                    print("error : \(String(describing: resp?.statusCode)) -> \(String(describing: resp?.message))")
                }else{
                    if uploaded{
                        print("logo has been correctly added")
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else{
                        print("error during logo upload")
                    }
                }
            }
        }
        
    }
    
    public func toStringRGBA(red:String, green: String, blue:String, alpha:String)-> String{
        return("rgba(\(red.description), \(green.description), \(blue.description), \(alpha.description))")
    }
    
    @IBAction func enableLogoUpload(_ sender: Any) {
        if EnableLogoSwitch.isOn{
            SelectLogoView.isHidden = false
        }else{
            SelectLogoView.isHidden = true
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let file = info[.originalImage] as! UIImage
        let fileUrl = info[.imageURL] as! URL
        
        self.fileName = fileUrl.lastPathComponent
        self.filePath = fileUrl.absoluteString
        self.url = fileUrl
        self.image = file
        
        LogoImageView.image = file
        imagePickerController.dismiss(animated: true, completion: nil)
    }

    
    
    @IBAction func selectLogo(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.allowsEditing = false
        imagePickerController.videoQuality = .typeHigh
        present(imagePickerController, animated: true, completion: nil)
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
public struct RGBA{
    public var red:String
    public var green:String
    public var blue:String
    public var alpha:String
    
    init(red: String, green: String, blue: String, alpha: String) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

//
//  LiveStreamApi.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 24/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation
import HaishinKit
import AVFoundation
import VideoToolbox

public class LiveStreamApi{
    public let qualities = ["240p", "360p", "480p", "720p", "1080p", "2160p"]
    let sampleRate: Double = 44_100
    private static let maxRetryCount: Int = 5
    private var retryCount: Int = 0
    private var tokenType: String!
    private var key: String!
    private var environnement: String!
    private let pagination : Pagination!
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var rtmpStream: RTMPStream!
    private var rtmpConnection = RTMPConnection()
    private var currentPosition: AVCaptureDevice.Position = .back
    private var livestreamkey: String?
    
    public init(tokenType: String, key: String, environnement: String){
        self.tokenType = tokenType
        self.key = key
        self.environnement = environnement
        self.pagination = Pagination(tokenType: tokenType, key: key)
    }
    
    //MARK: Create LiveStream
    public func create(name: String, record: Bool, playerId: String, completion: @escaping(Bool, Response?)->()){
        let apiPath = self.environnement  + ApiPaths.liveStream.rawValue
        var created = false
        var resp: Response?
        let body = [
            "name" : name,
            "record" : record,
            "playerId" : playerId,
            ] as Dictionary<String, AnyObject>
        var request = URLRequest(url: URL(string: apiPath)!)
        
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode{
            case 200, 201:
                if(json != nil){
                    created = true
                    resp = nil
                    completion(created, resp)
                }
            default:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                }
                completion(created, resp)
            }
        })
        task.resume()
    }
    //MARK: Get Live Stream By Id
    public func getLiveStreamById(liveStreamId: String, completion: @escaping (LiveStream?, Response?)->()){
        var liveStream: LiveStream?
        var resp: Response?
        let apiPath = self.environnement + ApiPaths.liveStream.rawValue + "/" + liveStreamId
        var request = URLRequest(url: URL(string: apiPath)!)
        
        request.httpMethod = "Get"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        
        let group = DispatchGroup()
        group.enter()
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode{
            case 200, 201:
                if(json != nil){
                    liveStream = try! self.decoder.decode(LiveStream.self, from: data!)
                    completion(liveStream, resp)
                }
            case 400:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(liveStream,resp)
                }
            default:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(liveStream,resp)
                }
            }
            
            group.leave()
        })
        task.resume()
        group.wait()
    }
    //MARK: Get All LiveStream
    public func getAllLiveStreams(completion: @escaping ([LiveStream], Response?)->()){
        var liveStreams: [LiveStream] = []
        let path = self.environnement + ApiPaths.liveStream.rawValue
        var nbItems = self.pagination.getNbOfItems(apiPath: path)
        var resp: Response?
        
        if(nbItems > 0){
            nbItems = nbItems - 1
        }
        for number in (0...nbItems){
            let apiPath = "\(path)?currentPage=\(number + 1)&pageSize=25"
            var request = URLRequest(url: URL(string: apiPath)!)
            
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
            
            let group = DispatchGroup()
            group.enter()
            
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
                let httpResponse = response as? HTTPURLResponse
                switch httpResponse?.statusCode{
                case 200:
                    if(json != nil){
                        for data in json!["data"] as! [AnyObject]{
                            let jsonData = try? JSONSerialization.data(withJSONObject:data)
                            let live = try? self.decoder.decode(LiveStream.self, from: jsonData!)
                            liveStreams.append(live!)
                        }
                    }
                case 400:
                    if(json != nil){
                        let stringStatus = String(json!["status"] as! Int)
                        resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                        completion(liveStreams,resp)
                    }
                default:
                    if(json != nil){
                        let stringStatus = String(json!["status"] as! Int)
                        resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                        completion(liveStreams,resp)
                    }
                }
                group.leave()
            })
            task.resume()
            group.wait()
        }
        completion(liveStreams,resp)
    }
    //MARK: Update Live Stream
    public func updateLiveStream(liveId: String, name: String?, record: Bool?, playerId: String?, completion: @escaping (Bool, Response?)->()){
        let apiPath = self.environnement + ApiPaths.liveStream.rawValue + "/\(liveId)"
        var body = [:] as Dictionary<String, Any>
        
        if(name != nil){
            body["name"] = name
        }
        if(record != nil){
            body["record"] = record
        }
        if(playerId != nil){
            body["playerId"] = playerId
        }
                
        var request = URLRequest(url: URL(string: apiPath)!)
        
        request.httpMethod = "PATCH"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        
        let group = DispatchGroup()
        group.enter()
        
        var updated = false
        var resp: Response?
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode{
            case 200, 201:
                if(json != nil){
                    updated = true
                    completion(updated, resp)
                }
            default:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                }
                completion(updated, resp)
            }
            group.leave()
        })
        task.resume()
        group.wait()
    }
    //MARK: Delete Live Stream
    public func deleteLiveStream(liveStreamId: String, completion: @escaping (Bool, Response?)->()){
        let apiPath = self.environnement + ApiPaths.liveStream.rawValue + "/\(liveStreamId)"
        var request = URLRequest(url: URL(string: apiPath)!)
        var deleted = false
        var resp : Response?
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        
        let group = DispatchGroup()
        group.enter()
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode{
            case 200, 201, 204:
                deleted = true
                completion(deleted, resp)
            case 400, 404:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(deleted,resp)
                }else{
                    completion(deleted,resp)
                }
            default:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(deleted,resp)
                }
            }
            group.leave()
        })
        task.resume()
        group.wait()
    }
    
    //MARK: Uplaod Thumbnail
    public func uploadImageThumbnail(liveStreamId: String, url: URL, filePath: String, fileName: String, imageData: Data, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.liveStream.rawValue + "/\(liveStreamId)" + ApiPaths.thumbnail.rawValue
        let boundary = generateBoundaryString()
        var request = URLRequest(url: URL(string: apiPath)!)
        
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? createBodyWithData(data: imageData, filePath: filePath, fileName: fileName, boundary: boundary)
        
        var isChanged = false
        var resp: Response?
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode{
            case 200, 201:
                isChanged = true
                completion(isChanged, resp)
            case 400, 404:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(isChanged, resp)
                }
            default:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(isChanged,resp)
                }
            }
        })
        task.resume()
    }
    
    public func deleteThumbnail(liveStreamId: String, completion: @escaping (Bool, Response?)->()){
        let apiPath = self.environnement + ApiPaths.liveStream.rawValue + "/\(liveStreamId)" + ApiPaths.thumbnail.rawValue
        var request = URLRequest(url: URL(string: apiPath)!)
        var deleted = false
        var resp : Response?
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        
        let group = DispatchGroup()
        group.enter()
        

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode{
            case 200, 201, 204:
                deleted = true
                completion(deleted, resp)
            case 400, 404:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(deleted,resp)
                }else{
                    completion(deleted,resp)
                }
            default:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(deleted,resp)
                }
            }
            group.leave()
        })
        task.resume()
        group.wait()
        
    }
    
    public func StartLiveStreamFlux(liveStream: LiveStream, captureQuality: String, streamQuality: String, fps: Float64){
        
        self.livestreamkey = liveStream.streamKey
        
        rtmpConnection.connect(ApiPaths.rtmpServerUrl.rawValue)
        rtmpStream = RTMPStream(connection: rtmpConnection)
        if let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) {
            rtmpStream.orientation = orientation
        }
        rtmpStream.setZoomFactor(CGFloat(0), ramping: true, withRate: 5.0)
        rtmpStream.attachAudio(AVCaptureDevice.default(for: AVMediaType.audio)) { error in
            print("======== Audio Flux Error ==========")
            print(error.description)
        }
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: .back)) { error in
            print("======== Camera Flux Error ==========")
            print(error.description)
        }
        
        rtmpStream.audioSettings = [
            .sampleRate: sampleRate,
            .muted: true
        ]
        setCaptureVideo(quality: captureQuality)
        setStreamVideoQuality(quality: streamQuality)
        rtmpStream.captureSettings[.fps] = fps
        
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(on(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    public func rotateCamera(){
        let position: AVCaptureDevice.Position = currentPosition == .back ? .front : .back
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: position)) { error in
            print(error.description)
        }
        currentPosition = position
    }
    
    private func setStreamVideoQuality(quality: String){
        switch quality {
        case "240p":
            // 352 * 240
            rtmpStream.videoSettings = [
                .width: 352,
                .height: 240,
            ]
        case "360p":
            // 480 * 360
            rtmpStream.videoSettings = [
                .width: 480,
                .height: 360,
            ]
            
        case "480p":
            // 858 * 480
            rtmpStream.videoSettings = [
                .width: 858,
                .height: 480,
            ]
        case "720p":
            // 1280 * 720
            rtmpStream.videoSettings = [
                .width: 1280,
                .height: 720,
            ]
        case "1080p":
            // 1920 * 1080
            rtmpStream.videoSettings = [
                .width: 1920,
                .height: 1080,
                .profileLevel: kVTProfileLevel_H264_High_4_0
            ]
        case "2160p":
            // 3860 * 2160
            rtmpStream.videoSettings = [
                .width: 3860,
                .height: 2160,
                .profileLevel: kVTProfileLevel_H264_High_AutoLevel
            ]
        default:
            rtmpStream.videoSettings = [
                .width: 480,
                .height: 360,
            ]
        }
    }
    
    private func setCaptureVideo(quality: String){
        switch quality {
        case "240p":
            // 352 * 240
            rtmpStream.captureSettings = [
                .sessionPreset: AVCaptureSession.Preset.low,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
        case "360p":
            // 480 * 360
            rtmpStream.captureSettings = [
                .sessionPreset: AVCaptureSession.Preset.low,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
            
        case "480p":
            // 858 * 480
            rtmpStream.captureSettings = [
                .sessionPreset: AVCaptureSession.Preset.vga640x480,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
        case "720p":
            // 1280 * 720
            rtmpStream.captureSettings = [
                .sessionPreset: AVCaptureSession.Preset.hd1280x720,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
        case "1080p":
            // 1920 * 1080
            rtmpStream.captureSettings = [
                .sessionPreset: AVCaptureSession.Preset.hd1920x1080,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
        case "2160p":
            // 3860 * 2160
            rtmpStream.captureSettings = [
                .sessionPreset: AVCaptureSession.Preset.hd4K3840x2160,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
        default:
            rtmpStream.captureSettings = [
                .sessionPreset: AVCaptureSession.Preset.low,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
        }
    }
    
    public func StopLiveStreamFlux(){
        rtmpStream.close()
        rtmpStream.dispose()
        rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
    }
    
    public func SetUpFpsRecord(fps: Int){
        rtmpStream.captureSettings[.fps] = fps
    }
    
    @objc
    private func on(_ notification: Notification) {
        guard let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) else {
            return
        }
        rtmpStream.orientation = orientation
    }
    
    
    
    @objc private func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
            return
        }
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            retryCount = 0
            //            rtmpStream!.publish(Preference.defaultInstance.streamName!)
            rtmpStream!.publish(self.livestreamkey!)
        // sharedObject!.connect(rtmpConnection)
        case RTMPConnection.Code.connectFailed.rawValue, RTMPConnection.Code.connectClosed.rawValue:
            guard retryCount <= LiveStreamApi.maxRetryCount else {
                return
            }
            Thread.sleep(forTimeInterval: pow(2.0, Double(retryCount)))
            //            rtmpConnection.connect(Preference.defaultInstance.uri!)
            rtmpConnection.connect("rtmp://broadcast.api.video/s")
            retryCount += 1
        default:
            break
        }
    }
    
    @objc
    private func rtmpErrorHandler(_ notification: Notification) {
        let e = Event.from(notification)
        print("rtmpErrorHandler: \(e)")
        DispatchQueue.main.async {
            self.rtmpConnection.connect("rtmp://broadcast.api.video/s")
        }
    }
    
    
    
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    private func createBodyWithData(data: Data, filePath: String, fileName: String, boundary: String) throws -> Data{
        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(filePath)\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        return body
    }
}

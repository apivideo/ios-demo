//
//  Client.swift
//  sdkApiVideo
//
//  Created by Romain on 01/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public class Client{
    private var tokenType: String = ""
    private var refreshToken: String = ""
    private var exprireIn: Int = 0
    private var accessToken: String = ""
    private var environnement: String = ""
    
    public var videoApi: VideoApi!
    public var playerApi: PlayerApi!
    public var liveStreamApi: LiveStreamApi!
    public var analyticsLiveApi: AnalyticsLiveApi!
    public var analyticsVideoApi: AnalyticsVideoApi!
    public var captionApi: CaptionApi!
    public var chapterApi: ChapterApi!
    

    public init(){}
    
    public func createProduction(key: String, completion: @escaping (Bool, Response?) ->()){
        self.environnement = ApiPaths.apiVideoProduction.rawValue
        let apiPath = ApiPaths.apiVideoProduction.rawValue + ApiPaths.createProduction.rawValue
        let body = ["apiKey": key] as Dictionary<String, String>
        var request = URLRequest(url: URL(string: apiPath)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let group = DispatchGroup()
        group.enter()
        
        var resp: Response?
        var created = false
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode{
            case 200, 201:
                self.accessToken = json?["access_token"] as! String
                self.tokenType = json?["token_type"] as! String
                self.videoApi = VideoApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.playerApi = PlayerApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.liveStreamApi = LiveStreamApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.analyticsLiveApi = AnalyticsLiveApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.analyticsVideoApi = AnalyticsVideoApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.captionApi = CaptionApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.chapterApi = ChapterApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                created = true
                resp = nil
                completion(created, resp)
            case 400:
                let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                completion(created, resp)
            default:
                let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                completion(created, resp)
            }
            
            group.leave()
        })
        task.resume()
        group.wait()
    }
    
    public func createSandbox(key: String, completion: @escaping (Bool, Response?) ->()){
        self.environnement = ApiPaths.apiVideoSandbox.rawValue
        let apiPath = ApiPaths.apiVideoSandbox.rawValue + ApiPaths.createProduction.rawValue
        let body = ["apiKey": key] as Dictionary<String, String>
        var request = URLRequest(url: URL(string: apiPath)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let group = DispatchGroup()
        group.enter()
        
        var resp: Response?
        var created = false
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode{
            case 200, 201:
                self.accessToken = json?["access_token"] as! String
                self.tokenType = json?["token_type"] as! String
                self.videoApi = VideoApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.playerApi = PlayerApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.liveStreamApi = LiveStreamApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.analyticsLiveApi = AnalyticsLiveApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.analyticsVideoApi = AnalyticsVideoApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.captionApi = CaptionApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.chapterApi = ChapterApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                created = true
                resp = nil
                completion(created, resp)
            case 400:
                let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                completion(created, resp)
            default:
                let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                completion(created, resp)
            }
            
            group.leave()
        })
        task.resume()
        group.wait()
    }
    
    public func getAccessToken() -> String {
        return self.accessToken
    }
    
    public func getTokenType() -> String {
        return self.tokenType
    }
    
    public func getEnvironnement() -> String {
        return self.environnement
    }
    
    
}

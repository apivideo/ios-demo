//
//  PlayerApi.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 03/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public class PlayerApi{
    
    private var tokenType: String!
    private var key: String!
    private var environnement: String!
    private let pagination : Pagination!
    
    public init(tokenType: String, key: String, environnement: String){
        self.tokenType = tokenType
        self.key = key
        self.environnement = environnement
        self.pagination = Pagination(tokenType: tokenType, key: key)
    }
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    //MARK: Create Player
    public func createPlayer(player: Player, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.players.rawValue
        let body = [
            "shapeMargin" : player.shapeMargin,
            "shapeRadius" : player.shapeRadius,
            "shapeAspect" : player.shapeAspect,
            "shapeBackgroundTop" : player.shapeBackgroundTop,
            "shapeBackgroundBottom" : player.shapeBackgroundBottom,
            "text" : player.text,
            "link" : player.link,
            "linkHover" : player.linkHover,
            "linkActive" : player.linkActive,
            "trackPlayed" : player.trackPlayed,
            "trackUnplayed" : player.trackUnplayed,
            "trackBackground" : player.trackBackground,
            "backgroundTop" : player.backgroundTop,
            "backgroundBottom" : player.backgroundBottom,
            "backgroundText" : player.backgroundText,
            "enableApi" : player.enableApi,
            "enableControls" : player.enableControls,
            "forceAutoplay" : player.forceAutoplay,
            "hideTitle" : player.hideTitle,
            "forceLoop" : player.forceLoop,
            ] as Dictionary<String, AnyObject>
        var created = false
        var resp: Response?
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
    
    //MARK: Get All Players
    public func getAllPlayers(completion: @escaping ([Player], Response?) ->()){
        var players: [Player] = []
        let path = self.environnement + ApiPaths.players.rawValue
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
                            let player = try? self.decoder.decode(Player.self, from: jsonData!)
                            players.append(player!)
                        }
                    }
                case 400:
                    if(json != nil){
                        let stringStatus = String(json!["status"] as! Int)
                        resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                        completion(players,resp)
                    }
                default:
                    if(json != nil){
                        let stringStatus = String(json!["status"] as! Int)
                        resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                        completion(players,resp)
                    }
                }
                group.leave()
            })
            task.resume()
            group.wait()
        }
        completion(players,resp)
    }
    
    //MARK: Get Player with Id
    public func getPlayerById(playerId: String, completion: @escaping (Player?, Response?) ->()){
        var player: Player?
        var resp: Response?
        let apiPath = self.environnement + ApiPaths.players.rawValue + "/" + playerId
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
                    player = try! self.decoder.decode(Player.self, from: data!)
                    completion(player,resp)
                }
            case 400:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(player,resp)
                }
            default:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(player,resp)
                }
            }
            
            group.leave()
        })
        task.resume()
        group.wait()
    }
    
    //MARK: Update Player
    public func updatePlayer(player: Player, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.players.rawValue + "/\(player.playerId)"
        let body = [
            "shapeMargin": player.shapeMargin,
            "shapeRadius": player.shapeRadius,
            "shapeAspect": player.shapeAspect,
            "shapeBackgroundTop": player.shapeBackgroundTop,
            "shapeBackgroundBottom": player.shapeBackgroundBottom,
            "text": player.text,
            "link": player.link,
            "linkHover": player.linkHover,
            "linkActive": player.linkActive,
            "trackPlayed": player.trackPlayed,
            "trackUnplayed": player.trackUnplayed,
            "trackBackground": player.trackBackground,
            "backgroundTop": player.backgroundTop,
            "backgroundBottom": player.backgroundBottom,
            "backgroundText": player.backgroundText,
            "enableApi": player.enableApi,
            "enableControls": player.enableControls,
            "forceAutoplay": player.forceAutoplay,
            "hideTitle": player.hideTitle,
            "forceLoop" : player.forceLoop,
            ] as Dictionary<String, AnyObject>
        var updated = false
        var resp: Response?
        var request = URLRequest(url: URL(string: apiPath)!)
        
        request.httpMethod = "PATCH"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
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
    
    //MARK: Upload logo
    public func uploadLogo(playerId: String, url: URL, filePath: String, fileName: String, imageData: Data, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.players.rawValue + "/\(playerId)" + ApiPaths.logoPlayer.rawValue
        let boundary = generateBoundaryString()
        var uploaded = false
        var resp : Response?
        var request = URLRequest(url: URL(string: apiPath)!)
        
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? createBodyWithData(data: imageData, filePath: filePath, fileName: fileName, boundary: boundary)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode{
            case 200, 201:
                if(json != nil){
                    uploaded = true
                    completion(uploaded, resp)
                }else{
                    completion(uploaded, resp)
                }
            case 400, 404:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(uploaded,resp)
                }else{
                    completion(uploaded,resp)
                }
            default:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    let url = json!["type"] as! String
                    let message = json!["title"] as! String
                    resp = Response(url: url, statusCode: stringStatus, message: message)
                    completion(uploaded,resp)
                }
            }
        })
        task.resume()
        
    }
    
    //MARK: Delete Player
    public func deletePlayer(playerId: String, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.players.rawValue + "/\(playerId)"
        var deleted = false
        var resp : Response?
        
        var request = URLRequest(url: URL(string: apiPath)!)
        
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

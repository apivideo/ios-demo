//
//  ChapterApi.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 28/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation
import MobileCoreServices


public class ChapterApi{
    private var tokenType: String!
    private var key: String!
    private var environnement: String!
    private let pagination : Pagination!
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init(tokenType: String, key: String, environnement: String){
        self.tokenType = tokenType
        self.key = key
        self.environnement = environnement
        self.pagination = Pagination(tokenType: tokenType, key: key)
    }
    
    /**
     - Parameters:
        - videoId: The videoId to upload chapter
        - url: The URL of .vtt file
        - filePath: The .vtt file path
        - fileName: The .vtt file name (for example: chapter_en.vtt)
        - language: The language for the .vtt file (for exemple: en)
     */
    public func uploadChapter(videoId: String, url: URL, filePath: String, fileName: String, language: String, completion: @escaping(Bool, Response?) -> ()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.chapters.rawValue + "/" + language
        let boundary = generateBoundaryString()
        var request = URLRequest(url: URL(string: apiPath)!)
        
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? createBodyWithUrl(url: url, filePath: filePath, fileName: fileName, boundary: boundary)
        
        var isUploaded = false
        var resp: Response?
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode{
            case 200, 201:
                isUploaded = true
                completion(isUploaded, resp)
            case 400, 404:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(isUploaded, resp)
                }
            default:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(isUploaded,resp)
                }
            }
        })
        task.resume()
    }
    
    /**
    - Parameters:
       - videoId: The videoId to get chapter of the video
       - language: The language of the .vtt file (for exemple: en)
    */
    public func getChapter(videoId: String, language: String, completion: @escaping(Chapter?, Response?)->()){
        var chapter: Chapter?
        var resp: Response?
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.chapters.rawValue + "/\(language)"
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
            case 200:
                chapter = try? self.decoder.decode(Chapter.self, from: data!)
                completion(chapter, resp)
            case 400, 401, 404:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(chapter,resp)
                }
            default:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    completion(chapter,resp)
                }
            }
            group.leave()
        })
        task.resume()
        group.wait()
    }
    
    /**
    - Parameters:
       - videoId: The videoId to get all chapters of the video
    */
    public func getAllChapters(videoId: String, completion: @escaping([Chapter], Response?) -> ()){
        var chapters: [Chapter] = []
        let path = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.chapters.rawValue
        var nbItems = self.pagination.getNbOfItems(apiPath: path)
        var resp: Response?
        
        if(nbItems > 0){
            nbItems = nbItems - 1
        }
        for number in (0...nbItems){
            let apiPath = "\(path)?currentPage=\(number + 1)&pageSize=25"
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
                case 200:
                    for data in json!["data"] as! [AnyObject]{
                        let jsonData = try? JSONSerialization.data(withJSONObject:data)
                        let chapter = try? self.decoder.decode(Chapter.self, from: jsonData!)
                        chapters.append(chapter!)
                    }
                case 400, 401:
                    if(json != nil){
                        let stringStatus = String(json!["status"] as! Int)
                        resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                        completion(chapters,resp)
                    }
                default:
                    if(json != nil){
                        let stringStatus = String(json!["status"] as! Int)
                        resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                        completion(chapters,resp)
                    }
                }
                group.leave()
            })
            task.resume()
            group.wait()
        }
        completion(chapters,resp)
    }
    
    /**
     - Parameters:
        - videoId: The videoId to get all chapters of the video
        - language: The language to delete the good file (for exemple: en)
     */
    public func deleteChapter(videoId: String, language: String, completion: @escaping(Bool, Response?)->()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.chapters.rawValue + "/\(language)"
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
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    private func createBodyWithUrl(url: URL, filePath: String, fileName: String, boundary: String) throws -> Data{
        var body = Data()
        let data = try Data(contentsOf: url)
        let mimetype = mimeType(for: filePath)
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(filePath)\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \(mimetype)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    private func mimeType(for path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
}

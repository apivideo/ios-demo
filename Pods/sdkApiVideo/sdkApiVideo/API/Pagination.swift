//
//  Pagination.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 27/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public class Pagination{
    private var tokenType: String!
    private var key: String!
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init(tokenType: String, key: String){
        self.tokenType = tokenType
        self.key = key
    }
    
    public func getNbOfItems(apiPath: String)-> Int{
        var resp: Response?
        var nbOfItems = 0
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
                let pagination = json!["pagination"] as! Dictionary<String, AnyObject>
                let itemsTotal = pagination["pagesTotal"]
                nbOfItems = itemsTotal as! Int
            case 400:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    print("resp : \(String(describing: resp))" )
                }
            default:
                if(json != nil){
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                    print("resp : \(String(describing: resp))" )
                }
            }
            group.leave()
        })
        task.resume()
        group.wait()
        
        return nbOfItems
    }
}

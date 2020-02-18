//
//  AnalyticsLiveApi.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 13/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public class AnalyticsLiveApi{
    
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
    
    public func searchLiveAnalyticsById(idLiveStream: String, period: String? = nil, completion: @escaping ([AnalyticData], Response?) -> ()){
        var analyticsData: [AnalyticData] = []
        var nbItems = 0
        
        if(period != nil){
            nbItems = self.pagination.getNbOfItems(apiPath: self.environnement + "\(ApiPaths.analyticsLiveStream.rawValue)\(idLiveStream)?period=\(period!)")
        }else{
            nbItems = self.pagination.getNbOfItems(apiPath: self.environnement + ApiPaths.analyticsLiveStream.rawValue + idLiveStream)
        }
        var resp: Response?
        
        if(nbItems > 0){
            nbItems = nbItems - 1
        }
        for number in (0...nbItems){
            var apiPath = ""
            if(period != nil){
                apiPath = self.environnement + "\(ApiPaths.analyticsLiveStream.rawValue)\(idLiveStream)?\(period!)&currentPage=\(number + 1)&pageSize=25"
            }else{
                apiPath = self.environnement + ApiPaths.analyticsLiveStream.rawValue + idLiveStream + "?currentPage=\(number + 1)&pageSize=25"
            }
            
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
                        
                        let jsonDataSession = try? JSONSerialization.data(withJSONObject:data["session"]!!)
                        let session = try? self.decoder.decode(AnalyticSession.self, from: jsonDataSession!)
                        
                        let jsonDataLocation = try? JSONSerialization.data(withJSONObject:data["location"]!!)
                        let location = try? self.decoder.decode(AnalyticLocation.self, from: jsonDataLocation!)
                        
                        let jsonDataReferrer = try? JSONSerialization.data(withJSONObject:data["referrer"]!!)
                        let referrer = try? self.decoder.decode(AnalyticReferrer.self, from: jsonDataReferrer!)
                        
                        let jsonDataDevice = try? JSONSerialization.data(withJSONObject:data["device"]!!)
                        let device = try? self.decoder.decode(AnalyticDevice.self, from: jsonDataDevice!)
                        
                        let jsonDataOs = try? JSONSerialization.data(withJSONObject:data["os"]!!)
                        let os = try? self.decoder.decode(AnalyticOs.self, from: jsonDataOs!)
                        
                        let jsonDataClient = try? JSONSerialization.data(withJSONObject:data["client"]!!)
                        let client = try? self.decoder.decode(AnalyticClient.self, from: jsonDataClient!)
                        
                        let analyticData = AnalyticData(session: session!, location: location!, referrer: referrer!, device: device!, os: os!, client: client!)
                        
                        analyticsData.append(analyticData)
                    }
                    
                case 400, 401, 404:
                    if(json != nil){
                        let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                        resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                        completion(analyticsData, resp)
                        break
                    }
                default:
                    if(json != nil){
                        let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                        resp = Response(url: json!["type"] as! String, statusCode: stringStatus, message: json!["title"] as! String)
                        completion(analyticsData, resp)
                        break
                    }
                }
                
                group.leave()
            })
            task.resume()
            group.wait()
        }
        completion(analyticsData, resp)
    }
}

//
//  AnalyticClient.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 13/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct AnalyticClient: Codable{
    public var type: String
    public var name: String
    public var version: String
    
    init(type: String, name: String, version: String) {
        self.type = type
        self.name = name
        self.version = version
    }
    
    enum CodingKeys : String, CodingKey {
        case type
        case name
        case version
    }
}

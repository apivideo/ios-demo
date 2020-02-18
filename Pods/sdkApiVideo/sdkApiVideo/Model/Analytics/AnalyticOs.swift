//
//  AnalyticOs.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 13/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct AnalyticOs: Codable{
    public var name: String
    public var shortname: String
    public var version: String
    
    init(name: String, shortname: String, version: String) {
        self.name = name
        self.shortname = shortname
        self.version = version
    }
    
    enum CodingKeys : String, CodingKey {
        case name
        case shortname
        case version
    }
}

//
//  AnalyticDevice.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 13/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct AnalyticDevice: Codable{
    public var type: String
    public var vendor: String
    public var model: String
    
    init(type: String, vendor: String, model: String) {
        self.type = type
        self.vendor = vendor
        self.model = model
    }
    
    enum CodingKeys : String, CodingKey {
        case type
        case vendor
        case model
    }
}

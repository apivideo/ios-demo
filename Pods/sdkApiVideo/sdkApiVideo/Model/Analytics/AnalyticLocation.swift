//
//  AnalyticLocation.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 13/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct AnalyticLocation: Codable{
    public var country: String
    public var city: String
    
    init(country: String, city: String) {
        self.country = country
        self.city = city
    }
    
    enum CodingKeys : String, CodingKey {
        case country
        case city
    }
}

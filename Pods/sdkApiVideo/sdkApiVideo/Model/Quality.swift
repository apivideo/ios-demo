//
//  Quality.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 19/11/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation
public struct Quality: Codable{
    public var quality: String?
    public var status: String?
    
    init(quality: String, status: String) {
        self.quality = quality
        self.status = status
    }
    
    enum CodingKeys : String, CodingKey {
        case quality
        case status
    }
}

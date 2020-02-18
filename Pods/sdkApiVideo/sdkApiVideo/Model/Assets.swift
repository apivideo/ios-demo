//
//  Assets.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 15/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public struct Assets: Codable{
    public var hls: String
    public var iframe: String
    public var player: String
    public var thumbnail: String
    
    init(hls: String, iframe: String, player: String, thumbnail: String) {
        self.hls = hls
        self.iframe = iframe
        self.player = player
        self.thumbnail = thumbnail
    }
    
    enum CodingKeys : String, CodingKey {
        case hls
        case iframe
        case player
        case thumbnail
    }
}

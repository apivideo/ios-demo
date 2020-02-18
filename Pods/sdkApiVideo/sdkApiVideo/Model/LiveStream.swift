//
//  LiveStream.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 24/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public struct LiveStream: Codable{
    public var liveStreamId: String
    public var streamKey: String
    public var name: String
    public var record: Bool
    public var broadcasting: Bool
    public var assets: Assets
    public var playerId: String?
    
    public init(liveStreamId: String, streamKey: String, name: String, record: Bool, broadcasting: Bool, assets: Assets, playerId: String?) {
        self.liveStreamId = liveStreamId
        self.streamKey = streamKey
        self.name = name
        self.record = record
        self.broadcasting = broadcasting
        self.assets = assets
        self.playerId = playerId
    }
    
    enum CodingKeys : String, CodingKey {
        case liveStreamId
        case streamKey
        case name
        case record
        case broadcasting
        case assets
        case playerId
    }
    
}

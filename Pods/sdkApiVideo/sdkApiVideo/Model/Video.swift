//
//  Video.swift
//  sdkApiVideo
//
//  Created by Romain on 02/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public struct Video: Codable{
    public var videoId: String
    public var title: String
    public var description: String
    public var isPublic: Bool
    public var publishedAt: String
    public var tags: [String]
    public var metaData: [Dictionary<String,String>]
    public var assets: Assets
    public var sourceVideo: SourceVideo
    public var playerId: String?
    public var isPanoramic: Bool
    
    public init(videoId:String, title:String, description: String, isPublic: Bool, publishedAt: String, tags: [String], metaData: [Dictionary<String,String>], assets: Assets, sourceVideo: SourceVideo, playerId: String?, panoramic: Bool){
        self.videoId = videoId
        self.title = title
        self.description = description
        self.isPublic = isPublic
        self.publishedAt = publishedAt
        self.tags = tags
        self.metaData = metaData
        self.assets = assets
        self.sourceVideo = sourceVideo
        self.playerId = playerId
        self.isPanoramic = panoramic
    }
    
    enum CodingKeys : String, CodingKey {
        case videoId
        case title
        case description
        case isPublic = "public"
        case publishedAt
        case tags
        case metaData = "metadata"
        case assets
        case sourceVideo = "source"
        case playerId
        case isPanoramic = "panoramic"
    }
}

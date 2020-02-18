//
//  AnalyticVideo.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 13/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct AnalyticVideo: Codable{
    public var videoId: String
    public var videoTitle: String
    public var tags: [String]
    public var period: String
    public var data: [AnalyticData]
    
    init(videoId: String, videoTitle: String, tags: [String], period: String, data: [AnalyticData]) {
        self.videoId = videoId
        self.videoTitle = videoTitle
        self.tags = tags
        self.period = period
        self.data = data
    }
    
    enum CodingKeys : String, CodingKey {
        case videoId
        case videoTitle
        case tags
        case period
        case data
    }
}

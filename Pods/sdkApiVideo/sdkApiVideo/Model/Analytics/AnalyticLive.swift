//
//  AnalyticLive.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 13/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct AnalyticLive: Codable{
    public var liveStreamId: String
    public var liveName: String
    public var period: String
    public var data: [AnalyticData]
    
    init(liveStreamId: String, liveName: String, period: String, data: [AnalyticData]) {
        self.liveStreamId = liveStreamId
        self.liveName = liveName
        self.period = period
        self.data = data
    }
    
    enum CodingKeys : String, CodingKey {
        case liveStreamId
        case liveName
        case period
        case data
    }
}

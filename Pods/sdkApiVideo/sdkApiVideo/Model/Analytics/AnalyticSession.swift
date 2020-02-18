//
//  AnalyticSession.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 13/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct AnalyticSession: Codable{
    public var sessionId: String
    public var loadedAt: String
    public var endedAt: String
    
    init(sessionId: String, loadedAt: String, endedAt: String) {
        self.sessionId = sessionId
        self.loadedAt = loadedAt
        self.endedAt = endedAt
    }
    
    enum CodingKeys : String, CodingKey {
        case sessionId
        case loadedAt
        case endedAt
    }
}

//
//  AnalyticEvent.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 13/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct AnalyticEvent: Codable{
    public var type: String
    public var emitted_at: String
    public var at: Int
    
    public var from: Int
    public var to: Int
    
    init(type: String, emitted_at: String, at: Int, from: Int, to: Int) {
        self.type = type
        self.emitted_at = emitted_at
        self.at = at
        self.from = from
        self.to = to
    }
    
    enum CodingKeys : String, CodingKey {
        case type
        case emitted_at
        case at
        case from
        case to
    }
}

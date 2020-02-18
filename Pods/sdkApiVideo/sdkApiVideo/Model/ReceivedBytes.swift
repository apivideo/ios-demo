//
//  ReceivedBytes.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 19/11/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation
public struct ReceivedBytes: Codable{
    public var to: Int?
    public var from: Int?
    public var total: Int?
    
    init(to: Int, from: Int, total: Int) {
        self.to = to
        self.from = from
        self.total = total
    }
    
    enum CodingKeys : String, CodingKey {
        case to
        case from
        case total
    }
}

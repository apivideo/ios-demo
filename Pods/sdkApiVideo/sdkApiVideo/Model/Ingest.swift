//
//  Ingest.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 19/11/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public struct Ingest: Codable{
    public var status: String
    public var filesize: Int
    public var receivedBytes: [ReceivedBytes]
    
    init(status: String, filesize: Int, receivedBytes: [ReceivedBytes]) {
        self.status = status
        self.filesize = filesize
        self.receivedBytes = receivedBytes
    }
    
    enum CodingKeys : String, CodingKey {
        case status
        case filesize
        case receivedBytes
    }
}

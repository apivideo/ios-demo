//
//  VideoStatus.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 19/11/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public struct Status: Codable{
    public var ingest: Ingest
    public var encodingVideo: EncodingVideo
    
    init(ingest: Ingest, encodingVideo: EncodingVideo) {
        self.ingest = ingest
        self.encodingVideo = encodingVideo
    }
    
    enum CodingKeys : String, CodingKey {
        case ingest
        case encodingVideo = "encoding"
    }
    
}

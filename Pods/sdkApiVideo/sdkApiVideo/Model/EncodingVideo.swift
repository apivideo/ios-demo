//
//  EncodingVideo.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 19/11/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public struct EncodingVideo: Codable{
    public var playable: Bool
    public var qualities: [Quality]
    public var metaData: MetaDataEncoding
    
    init(playable: Bool, qualities: [Quality], metaData: MetaDataEncoding) {
        self.playable = playable
        self.qualities = qualities
        self.metaData = metaData
    }
    
    enum CodingKeys : String, CodingKey {
        case playable
        case qualities
        case metaData = "metadata"
    }
    
}

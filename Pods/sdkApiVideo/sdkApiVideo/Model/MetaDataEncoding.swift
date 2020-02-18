//
//  MetaDataEncoding.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 19/11/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation
public struct MetaDataEncoding: Codable{
    public var width: Int?
    public var height: Int?
    public var bitrate: Double?
    public var duration: Int?
    public var framerate: Int?
    public var samplerate: Int?
    public var videoCodec: String?
    public var audioCodec: String?
    public var aspectRatio: String?
    
    init(width: Int, height: Int, bitrate: Double, duration: Int, framerate: Int, samplerate: Int, videoCodec: String, audioCodec: String, aspectRatio: String?) {
        self.width = width
        self.height = height
        self.bitrate = bitrate
        self.duration = duration
        self.framerate = framerate
        self.samplerate = samplerate
        self.videoCodec = videoCodec
        self.audioCodec = audioCodec
        self.aspectRatio = aspectRatio
    }
    
    enum CodingKeys : String, CodingKey {
        case width
        case height
        case bitrate
        case duration
        case framerate
        case samplerate
        case videoCodec
        case audioCodec
        case aspectRatio
    }
}

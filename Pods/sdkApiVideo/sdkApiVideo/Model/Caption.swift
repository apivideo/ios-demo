//
//  Caption.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 27/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct Caption: Codable{
    public var uri: String
    public var src: String
    public var srcLang: String
    public var isDefault: Bool
    
    public init(uri: String, src: String, srcLang: String, isDefault: Bool){
        self.uri = uri
        self.src = src
        self.srcLang = srcLang
        self.isDefault = isDefault
    }
    
    enum CodingKeys : String, CodingKey {
        case uri
        case src
        case srcLang = "srclang"
        case isDefault = "default"
    }
}

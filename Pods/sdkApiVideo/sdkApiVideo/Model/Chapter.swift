//
//  Chapter.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 28/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct Chapter: Codable{
    public var uri: String
    public var src: String
    public var language: String
    
    public init(uri: String, src: String, language: String){
        self.uri = uri
        self.src = src
        self.language = language
    }
    
    enum CodingKeys : String, CodingKey {
        case uri
        case src
        case language
    }
}


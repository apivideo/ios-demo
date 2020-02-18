//
//  AssetsPlayer.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 03/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public struct AssetsPlayer: Codable{
    public var logo: String?
    public var link: String?
    
    public init(logo: String?, link: String?) {
        self.logo = logo
        self.link = link
    }
    
    enum CodingKeys : String, CodingKey {
        case logo
        case link
    }
}

//
//  AnalyticReferrer.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 13/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct AnalyticReferrer: Codable{
    public var url: String
    public var medium: String
    public var source: String
    public var search_term: String
    
    init(url: String, medium: String, source: String, search_term: String) {
        self.url = url
        self.medium = medium
        self.source = source
        self.search_term = search_term
    }
    
    enum CodingKeys : String, CodingKey {
        case url
        case medium
        case source
        case search_term = "searchTerm"
    }
}

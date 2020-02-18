//
//  AnalyticData.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 13/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct AnalyticData: Codable{
    public var session: AnalyticSession
    public var location: AnalyticLocation
    public var referrer: AnalyticReferrer
    public var device: AnalyticDevice
    public var os: AnalyticOs
    public var client: AnalyticClient
    
    init(session: AnalyticSession, location: AnalyticLocation, referrer: AnalyticReferrer, device: AnalyticDevice, os: AnalyticOs, client: AnalyticClient) {
        self.session = session
        self.location = location
        self.referrer = referrer
        self.device = device
        self.os = os
        self.client = client
    }
    
    enum CodingKeys : String, CodingKey {
        case session
        case location
        case referrer
        case device
        case os
        case client
    }
}

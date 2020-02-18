//
//  Player.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 03/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public struct Player: Codable{
    public var playerId: String
    public var shapeMargin: Int64
    public var shapeRadius: Int64
    public var shapeAspect: String
    public var shapeBackgroundTop: String
    public var shapeBackgroundBottom: String
    public var text: String
    public var link: String
    public var linkHover: String
    public var linkActive: String
    public var trackPlayed: String
    public var trackUnplayed: String
    public var trackBackground: String
    public var backgroundTop: String
    public var backgroundBottom: String
    public var backgroundText: String
    public var enableApi: Bool
    public var enableControls: Bool
    public var forceAutoplay: Bool
    public var hideTitle: Bool
    public var forceLoop: Bool
    public var assets: AssetsPlayer?
    public var language: String?
    public var createdAt: String
    public var updatedAt: String
    
    public init(playerId: String, shapeMargin: Int64, shapeRadius: Int64, shapeAspect: String, shapeBackgroundTop: String, shapeBackgroundBottom: String, text: String, link: String, linkHover: String, linkActive: String, trackPlayed: String, trackUnplayed: String, trackBackground: String, backgroundTop: String, backgroundBottom: String, backgroundText: String, enableApi: Bool, enableControls: Bool, forceAutoplay: Bool, hideTitle: Bool, forceLoop: Bool, assets: AssetsPlayer?, language: String?, createdAt: String, updatedAt: String){
        self.playerId = playerId
        self.shapeMargin = shapeMargin
        self.shapeRadius = shapeRadius
        self.shapeAspect = shapeAspect
        self.shapeBackgroundTop = shapeBackgroundTop
        self.shapeBackgroundBottom = shapeBackgroundBottom
        self.text = text
        self.link = link
        self.linkHover = linkHover
        self.linkActive = linkActive
        self.trackPlayed = trackPlayed
        self.trackUnplayed = trackUnplayed
        self.trackBackground = trackBackground
        self.backgroundTop = backgroundTop
        self.backgroundBottom = backgroundBottom
        self.backgroundText = backgroundText
        self.enableApi = enableApi
        self.enableControls = enableControls
        self.forceAutoplay = forceAutoplay
        self.hideTitle = hideTitle
        self.forceLoop = forceLoop
        self.assets = assets
        self.language = language
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys : String, CodingKey {
        case playerId
        case shapeMargin
        case shapeRadius
        case shapeAspect
        case shapeBackgroundTop
        case shapeBackgroundBottom
        case text
        case link
        case linkHover
        case linkActive
        case trackPlayed
        case trackUnplayed
        case trackBackground
        case backgroundTop
        case backgroundBottom
        case backgroundText
        case enableApi
        case enableControls
        case forceAutoplay
        case hideTitle
        case forceLoop
        case assets
        case language
        case createdAt
        case updatedAt
    }
    
}

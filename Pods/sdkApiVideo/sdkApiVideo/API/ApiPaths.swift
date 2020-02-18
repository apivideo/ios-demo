//
//  ApiPaths.swift
//  sdkApiVideo
//
//  Created by Romain on 02/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

// ALL API'S PATHS
enum ApiPaths: String{
    case apiVideoSandbox = "https://sandbox.api.video"
    case apiVideoProduction = "https://ws.api.video"
    case createProduction = "/auth/api-key"
    case videos = "/videos"
    case uploadVideo = "/source"
    case status = "/status"
    case thumbnail = "/thumbnail"
    case players = "/players"
    case logoPlayer = "/logo"
    case liveStream = "/live-streams"
    case rtmpServerUrl = "rtmp://broadcast.api.video/s"
    case analyticsLiveStream = "/analytics/live-streams/"
    case analyticsLivesStream = "/analytics/live-streams"
    case analyticsVideo = "/analytics/videos/"
    case analyticsVideos = "/analytics/videos"
    case captions = "/captions"
    case chapters = "/chapters"
}



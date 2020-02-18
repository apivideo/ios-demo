# IOS SDK API.VIDEO

![Language](https://img.shields.io/badge/language-Swift%205.1-orange.svg)

The api.video web-service helps you put video on the web without the hassle. This documentation helps you use the corresponding IOS client. This is an early version, feel free to report any issue.

# Installation
## Cocoapod

1. Add the following entry to your Podfile:
```swift
pod ‘sdkApiVideo’
```
3. Then run `pod install`
4. Don’t forget to import sdkApiVideo in every file you’d like to use api.video sdk

# Quick Start
### 1. In the AppDelegate.swift instantiate a new Client
```swift
let authClient = Client()
```
### 2. In the didFinishLaunchingWithOptions func add the following code
  - If you want to use the production environment, use `createProduction` method
  - If you want to use the sandbox environment , use `createSandbox` method
 ```swift
 authClient.createSandbox(key: « YOUR_SANDBOX_API_KEY »){ (created, reponse) in
}
 ```
### 3. In your ViewController.swift file import the sdk 
```swift
import sdkApiVideo
```
### 4. Create Variable
```swift
let appDelegate = UIApplication.shared.delegate as! AppDelegate
```
### 5. In viewDidLoad func  
```swift
self.videoApi = appDelegate.authClient.videoApi
```
### 6. Create and upload a video file
```swift
self.videoApi.create(title: «title», description: «description», fileName: «filename», filePath: «filePath», url: «url»){ (uploaded, resp) in
    if(resp != nil){
        print("error : \((resp?.statusCode)!) -> \((resp?.message)!)")
    }else{
        if(uploaded){
            //Do whatever you want
        }else{
            // Do whatever you want
        }
    }
}

```

# FULL API
## Client
```swift
//Create production environnement
let client =  Client()
client.createProduction(key: YOUR_PRODUCTON_API_KEY){ (created, reponse) in
    if(reponse != nil && reponse?.statusCode != "200"){
        // Error
        // Do whatever you want
        // created == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // created == true uri & resp == nil
    }
}
```
```swift
//Create sandbox environnement
let client =  Client()
client.createSandbox(key: YOUR_SANDBOX_API_KEY){ (created, reponse) in
    if(reponse != nil && reponse?.statusCode != "200"){
        // Error
        // Do whatever you want
        // created == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // created == true uri & resp == nil
    }
}
```
## Video
```swift
//Create video
let videoApi = client.videoApi
            
videoApi.initVideo(title: title, description: description){ (uri, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // uri == "" & resp != nil
    }else{
        // Success
        // Do whatever you want
        // uri == video uri & resp == nil
    }
}
```
```swift
//Upload small video <128Mb
let videoApi = client.videoApi
            
videoApi.uploadSmallVideoFile(videoUri: VIDEO_URI, fileName: FILE_NAME, filePath: FILE_PATH, url: URL){ (uploaded, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // uploaded == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // uploaded == true & resp == nil
    }
}
```
```swift
//Upload big video
let videoApi = client.videoApi
            
videoApi.uploadBigVideoFile(videoUri: VIDEOURI, fileName: FILENAME, filePath: FILEPATH, url: URL){ (uploaded, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // uploaded == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // uploaded == true & resp == nil
    }
}
```
```swift
//Create and auto upload video
let videoApi = client.videoApi
            
videoApi.create(title: title, description: description, fileName: filename, filePath: filepath, url: url){ (created, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // created == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // created == true & resp == nil
    }
}
```
```swift
//Update video
let videoApi = client.videoApi
            
videoApi.updateVideo(video: Video){ (updated, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // updated == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // updated == true & resp == nil
    }
}
```
```swift
//Get video with his id 
let videoApi = client.videoApi
            
videoApi.getVideoByID(videoId: VIDEO_ID){ (video, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // video == nil & resp != nil
    }else{
        // Success
        // Do whatever you want
        // video != nil & resp == nil
    }
}
```
```swift
//Get list of video
let videoApi = client.videoApi
            
videoApi.getAllVideos(){(videos, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // videos == nil & resp == nil
    }else{
        // Success
        // Do whatever you want
        // videos != nil & resp == nil
    }
}
```
```swift
//Delete video
let videoApi = client.videoApi
            
videoApi.deleteVideo(videoId: VIDEO_ID){ (deleted, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // isDeleted == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // isDeleted == true & resp == nil
    }
}
```
```swift
//Get video status
let videoApi = client.videoApi
            
videoApi.getStatus(videoId: VIDEO_ID){(stat, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // isDeleted == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // isDeleted == true & resp == nil
    }
}
```
```swift
//Pick thumbnail
let videoApi = client.videoApi
            
videoApi.pickThumbnail(videoId: VIDEO_ID, timecode: "00:01:00.00"){(changed, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // changed == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // changed == true & resp == nil
    }
}
```
```swift
//Upload image as thumbnail
let videoApi = client.videoApi
            
videoApi.uploadImageThumbnail(videoId: VIDEO_ID, url: IMAGE_URL, filePath: FILEPATH, fileName: FILENAME, imageData: DATA){(uploaded, resp) in
    if uploaded{
        // Error
        // Do whatever you want
        // uploaded == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // uploaded == true & resp == nil
    }
}
```
## Player
```swift
//Create player
let playerApi = client.playerApi

playerApi.createPlayer(player: PLAYER){ (created, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // created == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // created == true & resp == nil
    }
}
```
```swift
//Get player with id 
let playerApi = client.playerApi

playerApi.getPlayerById(playerId: PLAYER_ID){(player, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // created == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // created == true & resp == nil
    }
}
```
```swift
//Get player with id
let playerApi = client.playerApi

playerApi.getPlayerById(playerId: PLAYER_ID){(player, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // player == nil & resp != nil
    }else{
        // Success
        // Do whatever you want
        // player != nil & resp == nil
    }
}
```
```swift
//Get list of players
let playerApi = client.playerApi

playerApi.getAllPlayers(){(players, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // players == nil & resp != nil
    }else{
        // Success
        // Do whatever you want
        // players != nil & resp == nil
    }
}
```
```swift
//Update player
let playerApi = client.playerApi

playerApi.updatePlayer(player: PLAYER){(updated, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // updated == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // updated == true & resp == nil
    }
}
```
```swift
//Upload logo
let playerApi = client.playerApi

playerApi.uploadLogo(playerId: PLAYER_ID, url: URL, filePath: FILEPATH, fileName: FILENAME, imageData: DATA){ (uploaded, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // uploaded == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // uploaded == true & resp == nil
    }
}
```
```swift
//Delete player
let playerApi = client.playerApi

playerApi.deletePlayer(playerId: PLAYER_ID){ (deleted, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // deleted == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // deleted == true & resp == nil
    }
}
```
## LiveStream
```swift
//Create live stream
let liveStreamApi = client.liveStreamApi

liveStreamApi.create(name: NAME, record: RECORD, playerId: PLAYER_ID){(created, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // created == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // created == true & resp == nil
    }
}
```
```swift
//Get live stream with id
let liveStreamApi = client.liveStreamApi

liveStreamApi.getLiveStreamById(liveStreamId: LIVE_STREAM_ID){(live, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // live == nil & resp != nil
    }else{
        // Success
        // Do whatever you want
        // live != nil & resp == nil
    }
}
```
```swift
//Get list of livestreams
let liveStreamApi = client.liveStreamApi

liveStreamApi.getAllLiveStreams(){(lives, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // lives == nil & resp != nil
    }else{
        // Success
        // Do whatever you want
        // lives != nil & resp == nil
    }
}
```
```swift
//Delete livestream
let liveStreamApi = client.liveStreamApi

liveStreamApi.deleteLiveStream(liveStreamId: LIVE_STREAM_ID){(deleted, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // deleted == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // deleted == true & resp == nil
    }
}
```
```swift
//Upload thumbnail livestream
let liveStreamApi = client.liveStreamApi

liveStreamApi.uploadImageThumbnail(liveStreamId: LIVE_STREAM_ID, url: URL, filePath: FILEPATH, fileName: FILENAME, imageData: DATA){(uploaded, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // uploaded == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // uploaded == true & resp == nil
    }
}
```
```swift
//Delete thumbnail livestream
let liveStreamApi = client.liveStreamApi

liveStreamApi.deleteThumbnail(liveStreamId: LIVE_STREAM_ID){ (deleted, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // deleted == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // deleted == true & resp == nil
    }
}
```
## Caption
```swift
//Upload caption
let captionApi = client.captionApi
            
captionApi.upload(videoId: VIDEO_ID, url: URL, filePath: FILEPATH, fileName: FILENAME, language: LANGUAGE){ (uploaded, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // uploaded == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // uploaded == true & resp == nil
    } 
}
```
```swift
//Get caption with id
let captionApi = client.captionApi
            
captionApi.getCaption(videoId: VIDEO_ID, language: LANGUAGE){ (caption, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // caption == nil & resp != nil
    }else{
        // Success
        // Do whatever you want
        // caption != nil & resp == nil
    } 
}
```
```swift
//Get list of captions
let captionApi = client.captionApi
            
captionApi.getAllCaptions(videoId: VIDEO_ID){ (captions, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // captions == nil & resp != nil
    }else{
        // Success
        // Do whatever you want
        // captions != nil & resp == nil
    } 
}
```
```swift
//Update default caption
let captionApi = client.captionApi
            
captionApi.updateDefaultValue(videoId: VIDEO_ID, language: LANGUAGE, isDefault: BOOL){ (updated, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // updated == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // updated == true & resp == nil
    } 
}
```
```swift
//Delete caption
let captionApi = client.captionApi
            
captionApi.(videoId: VIDEO_ID, language: LANGUAGE){ (deleted, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // deleted == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // deleted == true & resp == nil
    } 
}
```
## Chapter
```swift
//Upload chapter
let chapterApi = client.chapterApi
            
chapterApi.uploadChapter(videoId: VIDEO_ID, url: URL, filePath: FILEPATH, fileName: FILENAME, language: LANGUAGE){ (uploaded, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // uploaded == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // uploaded == true & resp == nil
    } 
}
```
```swift
//Get chapter with id
let chapterApi = client.chapterApi
            
chapterApi.getChapter(videoId: VIDEO_ID, language: LANGUAGE){ (chapter, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // chapter == nil & resp != nil
    }else{
        // Success
        // Do whatever you want
        // chapter != nil & resp == nil
    } 
}
```
```swift
//Get list of chapters
let chapterApi = client.chapterApi
            
chapterApi.getAllChapters(videoId: VIDEO_ID){ (chapters, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // chapters == nil & resp != nil
    }else{
        // Success
        // Do whatever you want
        // chapters != nil & resp == nil
    } 
}
```
```swift
//Delete chapter
let chapterApi = client.chapterApi
            
chapterApi.deleteChapter(videoId: VIDEO_ID, language: LANGUAGE){ (deleted, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // deleted == false & resp != nil
    }else{
        // Success
        // Do whatever you want
        // deleted == true & resp == nil
    } 
}
```
## Analytics Video
```swift
//Get analytics of video
let analyticsVideoApi = client.analyticsVideoApi
            
analyticsVideoApi.searchVideoAnalyticsById(idVideo: VIDEO_ID, period : PERIOD){ (analytics, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // analytics == nil & resp != nil
    }else{
        // Success
        // Do whatever you want
        // analytics != nil & resp == nil
    } 
}
```
## Analytics Live Stream
```swift
//Get analytics of live stream
let analyticsLiveApi = client.analyticsLiveApi
            
analyticsLiveApi.searchLiveAnalyticsById(idLiveStream: LIVE_STREAM_ID, period: PERIOD){ (analytics, resp) in
    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
        // Error
        // Do whatever you want
        // analytics == nil & resp != nil
    }else{
        // Success
        // Do whatever you want
        // analytics != nil & resp == nil
    } 
}
```
### Plugins

API.Video sdk is using external library

| Plugin | README |
| ------ | ------ |
| HaishinKit | [https://github.com/shogo4405/HaishinKit.swift][HaishinKit] |

### FAQ
If you have any questions, ask us here:  https://community.api.video .
Or use [Issues].

License
----

Apache-2.0


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [HaishinKit]: <https://github.com/shogo4405/HaishinKit.swift>
   [Issues]: <https://github.com/apivideo/ios-sdk/issues>

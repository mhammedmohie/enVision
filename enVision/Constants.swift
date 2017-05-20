//
//  Design.swift
//  enVision
//
//  Created by andrei on 14/04/2017.
//  Copyright © 2017 id-labs. All rights reserved.
//

import Foundation


// always define fonts like this
// instead of specifying the name and size, so that it supports DynamicType
//
// UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
// UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)


// ========================================================
// MARK: General
// ========================================================

struct UIConstants {
    static let popupAppearanceDuration = 0.25
}

struct Animations {
    static let eysense = "eysense"
}

struct Tutorial {
    static let stuckUserRepeatDelay = 5.0
}

struct Limitations {
    static let maxPersonSaved = 10
}


// ========================================================
// MARK: Sounds
// ========================================================

enum SpeechVoiceName: String {
    case Siri = "com.apple.ttsbundle.Siri_compact"
    case samanthaEnhanced = "com.apple.ttsbundle.Samantha-premium"
    case samantha = "com.apple.ttsbundle.Samantha-compact"
    case arthur = "com.apple.ttsbundle.siri_male_en-GB_compact"
    case nicky = "com.apple.ttsbundle.siri_female_en-US_compact"
    case aaron = "com.apple.ttsbundle.siri_male_en-US_compact"
}

enum SpeakPhrase: String {
    case welcomeMessage = "Welcome to Eye Sense"
    case faces
    case newFaceProcessing = "Recognizing face"
    case missedVoiceInput = "I missed it. Explain in other words"
}

enum SpeechVoiceSpeed: Float {
    case low = 0.8
    case medium = 0.9
    case high = 1 // current setting
}

enum SoundType: String {
    case ding = "ding"
    case tone1 = "beep_1"
    case tone2 = "beep_2"
    case click = "click"
}

let kMaxBgMusicVolume = 0.58


struct Sounds {
    static let splashScreen = SoundType.ding
    static let smileDetected = SoundType.ding
    static let listenToUserVoiceStarted = SoundType.tone1
    static let listenToUserVoiceStopped = SoundType.tone2
    static let faceLearnStarted = SoundType.tone1
    static let faceLearnFinished = SoundType.tone2
    static let cameraSwitchedBack = SoundType.tone1
    static let cameraSwitchedFront = SoundType.tone2
    static let click = SoundType.click
}


// ========================================================
// MARK: Services/VUIService.swift for recognized words
// ========================================================


// ========================================================
// MARK: Design
// ========================================================

//class Design {
//    
//    // face contour line width
//    static let strokeWidth : CGFloat = 3
//    
//    enum Colors: Int {
//        
//        case unfamiliar // unknowns
//        case known
//        case scheduled
//        case recognizing // processing
//        case phone
//        case facebook
//        case mightBe
//        
//        // you can use this for RGB
//        // return UIColor(red: 154/255, green: 36/255, blue: 66/255, alpha: 1)
//        
//        var color : UIColor {
//            switch self {
//            case .unfamiliar:
//                return UIColor(hexString: "#fedd52")!.withAlphaComponent(0.9)
//            case .known:
//                return UIColor(hexString: "#fd618d")!.withAlphaComponent(0.9)
//            case .scheduled:
//                return UIColor(hexString: "#B6C9BB")!.withAlphaComponent(0.9)
//            case .recognizing:
//                return UIColor(hexString: "#7D0552")!.withAlphaComponent(0.9)
//            case .phone:
//                return UIColor(hexString: "#20bfe1")!.withAlphaComponent(0.9)
//            case .facebook:
//                return UIColor(hexString: "#3b5a96")!.withAlphaComponent(0.9)
//            case .mightBe:
//                return UIColor(hexString: "#fd8761")!.withAlphaComponent(0.9)
//            }
//        }
//        
//    }
//}


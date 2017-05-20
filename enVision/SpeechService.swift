//
//  SpeechService.swift
//  enVision
//
//  Created by Vladislav Mazur on 30/01/2017.
//  Copyright © 2017 id-labs. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import LambdaKit
import SwiftyTimer
import Speech

enum UserDefaultKeys: String {
    case selectedVoice = "selected-voice"
    case voiceSpeed = "voice-speed"
    case autoSpeech = "auto-speech"
    case affectivaEmotionThreshold = "affectiva-emotion-threshold"
    case affectivaEmotionSpeaking = "affectiva-emotion-speaking"
    case autoPlayTutorial = "auto-play-tutorial"
}
struct SpeechServiceOptions: OptionSet {
    let rawValue: Int
    
    static let welcomeMessage = SpeechServiceOptions(rawValue: 1 << 0)
    static let faces = SpeechServiceOptions(rawValue: 1 << 1)
    static let newFaceProcessing = SpeechServiceOptions(rawValue: 1 << 2)
    static let missedVoiceInput = SpeechServiceOptions(rawValue: 1 << 3)
    
    static let all: SpeechServiceOptions = [.welcomeMessage, .faces, .newFaceProcessing, .missedVoiceInput]
}

final class SpeechService {
    static let shared = SpeechService()
    
    private let synth = AVSpeechSynthesizer()
    private var synthIsBusy = false
    
    private var voiceOverRunning: Bool {
        return UIAccessibilityIsVoiceOverRunning()
    }
    
    var voiceName = SpeechVoiceName.samanthaEnhanced {
        didSet {
            let availableVoices = AVSpeechSynthesisVoice.speechVoices()
            var bestVoice = availableVoices.filter { voice -> Bool in return voice.identifier == voiceName.rawValue }.first
            if bestVoice == nil {
                bestVoice = AVSpeechSynthesisVoice(language: "en-US")
            }
            voice = bestVoice
        }
    }
    
    var voiceSpeed = SpeechVoiceSpeed.high
    
    private let phraseToOptionsMap = [SpeakPhrase.welcomeMessage: SpeechServiceOptions.welcomeMessage,
                                     .faces: .faces,
                                     .newFaceProcessing: .newFaceProcessing,
                                     .missedVoiceInput: .missedVoiceInput
    ]
    
    private func allowed(phrase: SpeakPhrase) -> Bool {
        return speakOptions.contains(phraseToOptionsMap[phrase]!)
    }
    
    let speakOptions = SpeechServiceOptions.all
    private var voice = AVSpeechSynthesisVoice(identifier: SpeechVoiceName.samanthaEnhanced.rawValue)
    
    init() {
        // disabled for now
        // setupVoice()
    }
    
    func setupVoice() {
        let selectedVoiceIndex = Defaults[UserDefaultKeys.selectedVoice.rawValue].int ?? 5
        let voiceMap = [0: SpeechVoiceName.samanthaEnhanced,
                   1: .arthur,
                   2: .nicky,
                   3: .aaron,
                   4: .aaron,
                   5: .Siri

        ]
        voiceName = voiceMap[selectedVoiceIndex]!
        
        let selectedVoiceSpeedIndex = Defaults[UserDefaultKeys.voiceSpeed.rawValue].int ?? 2
        let speedMap = [0: SpeechVoiceSpeed.low,
                   1: .medium,
                   2: .high,
        ]
        voiceSpeed = speedMap[selectedVoiceSpeedIndex]!
    }
    
    func speak(phrase: SpeakPhrase, rightNow: Bool = false) {
        guard allowed(phrase: phrase) else { return }
        
        speak(text: phrase.rawValue, rightNow: rightNow)
    }
    
    func speak(text: String, rightNow: Bool = false, useCancellationHandler: Bool = false, completion: LKDidFinishSpeechUtterance? = nil) {
        speak(texts: [text], rightNow: rightNow, useCancellationHandler: useCancellationHandler, completion: completion)
    }
    
    func speak(texts: [String], rightNow: Bool = false, useCancellationHandler: Bool = false, completion: LKDidFinishSpeechUtterance? = nil) {
        if rightNow {
            stop()
        }
        
        let wholeText = texts.joined(separator: " ")
        
        if voiceOverRunning {
            var token: NSObjectProtocol?
            token = NotificationCenter.default.addObserver(forName: Notification.Name.UIAccessibilityAnnouncementDidFinish, object: nil, queue: nil) { [unowned self] notification in
                if let completion = completion {
                    let utt = AVSpeechUtterance(string: wholeText)
                    completion(self.synth, utt) // dirty hack
                }
                NotificationCenter.default.removeObserver(token!)
            }
            
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, wholeText)
            
            return
        }
        
        var token: NSObjectProtocol?
        token = NotificationCenter.default.addObserver(forName: Notification.Name.UIAccessibilityElementFocused, object: nil, queue: nil) { [unowned self] notification in
            if self.synth.pauseSpeaking(at: .word) {
                Timer.after(7.seconds) { [unowned self] in
                    self.synth.continueSpeaking()
                }
            }
            NotificationCenter.default.removeObserver(token!)
        }
        
        // speech parameters
        let utterance = AVSpeechUtterance(string: wholeText)
        utterance.voice = voice
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * voiceSpeed.rawValue
         //utterance.pitchMultiplier = 1.66 // [0.5 - 2] Default = 1
        // utterance.volume = 1 // [0-1] Default = 1

        
        if let completion = completion {
            if useCancellationHandler {
                synth.didCancelSpeechUtterance = completion
            } else {
                synth.didCancelSpeechUtterance = nil
            }
            synth.speakUtterance(utterance, didFinishUtterance: completion)
        } else {
            synth.speak(utterance)
        }
    }
    
    func stop() {
        if synth.isSpeaking {
            synth.stopSpeaking(at: .immediate)
        }
    }
    
    
}

//
//  IBLVoiceManager.swift
//  RootPrint
//
//  Created by Luofei on 2018/12/3.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import AVFoundation

class IBLVoiceManager: NSObject {

    /// 单例管理语音播报 比较适用于多种类型语音播报管理
    public static let shared = IBLVoiceManager()
    
    var synthesizer = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance?
    var voiceType = AVSpeechSynthesisVoice(language: Locale.current.languageCode)
    
    private override init() {
        super.init()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .duckOthers)
        } catch {
            print(error.localizedDescription)
        }
        synthesizer.delegate = self
    }
    
    /// 自定义语音播报方法
    /// 此处只举例播报一个String的情况
    func speechWeather(with weather: String) {
        if let _ = speechUtterance {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }
        
        speechUtterance = AVSpeechUtterance(string: weather)
        
        speechUtterance?.voice = voiceType
        speechUtterance?.rate = 0.5
        synthesizer.speak(speechUtterance!)
    }
    
}

extension IBLVoiceManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        do {
            try AVAudioSession.sharedInstance().setActive(false, with: .notifyOthersOnDeactivation)
        } catch {
            print(error.localizedDescription)
        }
        speechUtterance = nil
    }
}

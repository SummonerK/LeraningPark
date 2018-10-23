//
//  audioBackGroundManager.swift
//  pageSwitch
//
//  Created by Luofei on 2018/10/16.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit
import AVFoundation

/// 后台运行音乐 Manager

let audioBackGroundM = audioBackGroundManager.shared

class audioBackGroundManager: NSObject {
    
    //播放器对象
    fileprivate var audioPlayer: AVAudioPlayer?
    
    fileprivate var musicName:String?
    
/**
 * swift3.0 单例样式
 * 使用方法：let mark = SingelClass.shared
 */
    static let shared = audioBackGroundManager()
    // 重载并私有
    private override init() {
        PrintFM("audioBackGroundManager 单例")
    }
    
/// 后台运行音乐开启
///
/// 后台音乐开启-意味着app退入后台仍然有活性，并且不受 180s，600s限制，可以无限运行，不挂起。
///
///  - Returns: Void
    
    func ABGBegin() -> Void {
        addPlayerToAVPlayerLayer()
    }
    
/// 后台运行音乐关闭
///
///  - Returns: Void
    
    func ABGEnd() -> Void {
        closePlayer()
    }

/// 注册播放音乐
///
///  warning : 注册应在播放之前
///
///  - Parameters:
///     - music:播放音乐的名字 ~.mp3
///  - Returns: Void
    
    func setMusic(music:String) -> Void {
        musicName = music
    }
    
    fileprivate func addPlayerToAVPlayerLayer() -> Void {
        
        var music = String()
        
        if musicName != nil,musicName != ""{
            music = musicName!
        }else{
            music = "xmj.mp3"
        }
        
        //获取本地视频资源
        guard let path = Bundle.main.path(forResource: music, ofType: nil) else {
            PrintFM("音乐不可播放，请查看音乐文件是否合法")
            return
        }
        
        let pathURL=NSURL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pathURL as URL)
        } catch {
            audioPlayer = nil
        }
        
        audioPlayer?.setVolume(1.0, fadeDuration: 0.8)
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.prepareToPlay()
        
        audioPlayer?.play()
    }
    
    fileprivate func closePlayer() -> Void{
        ///此处直接把播放对象置空，是考虑到激活app前台运行，会长时间有活性。释放空间，逻辑更合理，性能更优。        audioPlayer?.stop()
        audioPlayer = nil
    }
    
}

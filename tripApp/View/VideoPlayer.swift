//
//  VideoPlayer.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/04.
//

import Foundation
import AVFoundation
import UIKit

class VideoPlayer: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
   
   
    var isStart = false
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    let startButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
 
    func setup(){
        self.addSubview(startButton)
        startButton.center(inView: self)
        startButton.addTarget(self, action: #selector(closeImage(sender:)), for: .touchDown)
    }
    func setupVideoTap(){
        //
        startButton.isUserInteractionEnabled = true
        let tapVideo = UITapGestureRecognizer(target: self, action: #selector(tapVideo(sender:)))
        self.addGestureRecognizer(tapVideo)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    @objc func tapVideo(sender: UIButton){
        isStart = !isStart
        if isStart{
            start()
            startButton.isHidden = true
        }
        else{
            stop()
            startButton.isHidden = false
        }
    }
    @objc func closeImage(sender: UIButton){
        isStart = !isStart
        if isStart{
            start()
            startButton.isHidden = true
        }
        else{
            stop()
            startButton.isHidden = false
        }
    }
    func stop(){
        player!.pause()
    }
    func start(){
        player?.play()
    }
    func loadVideo(urlString:String){
        let url = URL(string: urlString)
        print("load videooooooooooooo")
        player = AVPlayer(url: url!)
        self.backgroundColor = .black
        startButton.isUserInteractionEnabled = false
    }
    @objc private func playerItemDidReachEnd(_ notification: Notification) {
           // 動画を最初に巻き戻す
          player?.currentItem?.seek(to: CMTime.zero, completionHandler: nil)
        startButton.isHidden = false
        isStart = false
    }
}

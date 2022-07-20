//
//  VideoPlayer.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/04.
//

import Foundation
import AVFoundation
import UIKit
import PKHUD
class VideoPlayer: UIView {
    var isStart = false
    var player: AVPlayer? {
        get {
            print("get")
            return playerLayer.player
        }
        set {
            print("setsetsetsetsetsetsetsetsetsetsetsetset")
            playerLayer.player = newValue
        }
    }
    var playerLayer: AVPlayerLayer {
        layer.frame  = self.frame
        return layer as! AVPlayerLayer
    }
    override static var layerClass: AnyClass {
           return AVPlayerLayer.self
    }
    let startButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.isHidden = true
        return button
    }()
    
    let videoLengthLabel:UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let currntLengthLabel:UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let slider:UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
       
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        self.backgroundColor = .black
        player?.automaticallyWaitsToMinimizeStalling = false
        player?.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
        if isStart {
            startButton.isHidden = false
            start()
           
        }
        else {
            stop()
            startButton.isHidden = true
        }
    }
    
    @objc func handleSliderChange(){
        print("handle Slider")
        if let duration = player?.currentItem?.duration {
            let total = CMTimeGetSeconds(duration)
            let value = Float64(slider.value) * total
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { result in
            })
        }
        print(slider.value)
    }
    
    func setup(){
        
        self.addSubview(startButton)
        startButton.center(inView: self)
        startButton.addTarget(self, action: #selector(closeImage(sender:)), for: .touchDown)
//        player?.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
        if isStart {
            startButton.isHidden = true

        }
        else {
            startButton.isHidden = false
        }
    }
    func setupVideoTap(){
        startButton.isUserInteractionEnabled = true
        let tapVideo = UITapGestureRecognizer(target: self, action: #selector(tapVideo(sender:)))
        self.addGestureRecognizer(tapVideo)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    func setupSlider(){

        self.addSubview(videoLengthLabel)
        self.addSubview(currntLengthLabel)
        self.addSubview(slider)
        
        videoLengthLabel.anchor(right: safeAreaLayoutGuide.rightAnchor, paddingRight: 8,
                                bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 8)
        
        currntLengthLabel.anchor(left:safeAreaLayoutGuide.leftAnchor,paddingLeft: 8,
                                 bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 8)
        
        slider.anchor(left:currntLengthLabel.rightAnchor,paddingLeft: 8,
                      right: videoLengthLabel.leftAnchor,paddingRight: 8,
                      bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0,
                      height: 30)
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
    }
    func updateSlider(){
        if let duration = player?.currentItem?.duration {
           
            let seconds = CMTimeGetSeconds(duration)
            if seconds.isNaN == false {
              
                let secondText = Int(seconds.truncatingRemainder(dividingBy: 60))
                let fixText = String(format: "%02d", secondText)
                videoLengthLabel.text = "00:\(fixText)"
            }
            
        }
        let interval = CMTime(value: 1, timescale:2)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: nil , using: { [self](currentTime) in
            let seconds = CMTimeGetSeconds(currentTime)
            let secondText = Int(seconds.truncatingRemainder(dividingBy: 60))
            let fixText = String(format: "%02d", secondText)
            currntLengthLabel.text = "00:\(fixText)"
            //sliderを動かす
            if let duration = player?.currentItem?.duration {
                let currntseconds = CMTimeGetSeconds(duration)
                slider.value = Float(seconds / currntseconds)
            }
        })
    }
    
    @objc func tapVideo(sender: UIButton){
        isStart = !isStart
        if isStart{
            start()
        }
        else{
            stop()
        }
    }
    @objc func closeImage(sender: UIButton){
        isStart = !isStart
        if isStart{
            start()
        }
        else{
            stop()
        }
    }
    func stop(){
        startButton.isHidden = false
        if player != nil {
            player!.pause()
        }
      
    }
    func start(){
        startButton.isHidden = true
        if player != nil {
            player?.play()
        }
       
    }
    func loadVideo(urlString:String){
    
        CacheManager.shared.getFileWith(stringUrl: urlString) { [self]  result in
            
            switch result {
                case .success(let url):
                print("1",url)
                    startButton.isHidden = false
                    player = AVPlayer(url: url)
                case .failure(let error):
                    print(error)
                    // handle errror
                }
        }
    }
    func loadVideo(view:UIView,urlString:String,compleation:@escaping (Bool) -> Void){
        CacheManager.shared.getFileWith(stringUrl: urlString) { [self]  result in
            
            switch result {
                
                case .success(let url):
                    print("2",url)
                  
                    player = AVPlayer(url: url)
                    compleation(true)
              
                case .failure(let error):
                    print(error)
                    compleation(false)
                    // handle errror
                }
        }
        
    }
    
    @objc private func playerItemDidReachEnd(_ notification: Notification) {
           // 動画を最初に巻き戻す
        player?.currentItem?.seek(to: CMTime.zero, completionHandler: nil)
        stop()
        isStart = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

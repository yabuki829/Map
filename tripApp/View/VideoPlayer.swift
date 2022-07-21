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
    var indicator = UIActivityIndicatorView()
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    var playerLayer: AVPlayerLayer {
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
        addSubview(indicator)
        indicator.center(inView: self)
        indicator.center = self.center
        indicator.color = .white
        indicator.tintColor = .white
        indicator.layer.zPosition = 1
        
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
            if value != 0.0{
                let seekTime = CMTime(value: Int64(value), timescale: 1)
                player?.seek(to: seekTime, completionHandler: { result in
                })
            }
         
        }
        print(slider.value)
    }
    
   
    func setup(){
      
        self.addSubview(startButton)
        startButton.center(inView: self)
        startButton.addTarget(self, action: #selector(closeImage(sender:)), for: .touchDown)
        player!.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        if isStart {
            startButton.isHidden = true

        }
        else {
            startButton.isHidden = false
        }
    }
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .playing || newStatus == .paused {
                        print("A")
                        
                        self?.indicator.stopAnimating()
                        self?.slider.isHidden = false
                        self?.videoLengthLabel.isHidden = false
                        self?.currntLengthLabel.isHidden = false
                        self?.setupSlider()
                        self?.updateSlider()
                    } else {
                        print("B")
//                        self?.loaderView.isHidden = false
                    }
                }
            }
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
        isStart = false
        if player != nil {
            player!.pause()
        }
      
    }
    func start(){
        isStart = true
        startButton.isHidden = true
        if player != nil {
            player?.play()
        }
       
    }
    func loadVideo(urlString:String,isWithCashe:Bool){
        indicator.startAnimating()
        let url = URL(string: urlString)!
        player = AVPlayer(url: url)
        
       
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

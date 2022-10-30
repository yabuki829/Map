//
//  CameraViewController.swift
//  tripApp
//
//  Created by 薮木翔大 on 2022/07/31.
//

import Foundation
import UIKit
import AVFoundation
import CropViewController

class CameraViewController: UIViewController {
    var session = AVCaptureSession()
    let output = AVCapturePhotoOutput()
    let movieOutput = AVCaptureMovieFileOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    var isPhoto = false
    let shutterButton:UIButton = {
        let button = UIButton(frame:CGRect(x: 0, y: 0, width: 50, height: 50) )
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    let imageview = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        shutterButton.addTarget(self, action: #selector(tapShutter), for: .touchDown)
        checkCameraPermission()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.width / 2, y: view.frame.height - (view.frame.height / 6) )
    }
    
    func checkCameraPermission(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
            case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {[weak self] result in
                guard result else { return }
                
                DispatchQueue.main.async {
                    self?.setupCamera()
                    self?.setupVideo()
                }
            }
            case .restricted:
                //アクセスできるようにalertする
                break
            case .denied:
                break
                //アクセスできるようにalertする
            case .authorized:
                setupCamera()
            
        @unknown default:
            break
        }
    }
    func setupCamera(){
        let session = AVCaptureSession()
        if let devise = AVCaptureDevice.default(for: .video){
            do {
                let input = try AVCaptureDeviceInput(device: devise)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output){
                    session.addOutput(output)
                }
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            }
            catch {
                
            }
        }
    }
    func setupVideo(){
        let session = AVCaptureSession()
        if let devise = AVCaptureDevice.default(for: .video), let audio = AVCaptureDevice.default(for: .audio){
        
            do {
                let videoInput = try AVCaptureDeviceInput(device: devise)
                session.addInput(videoInput)

                           // audio inputを capture sessionに追加
                let audioInput = try AVCaptureDeviceInput(device: audio)
                session.addInput(audioInput)

                           // max 30sec
                self.movieOutput.maxRecordedDuration = CMTimeMake(value: 30, timescale: 1)
                session.addOutput(movieOutput)

                           // プレビュー
                let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                videoLayer.frame = self.view.bounds
                videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.view.layer.addSublayer(videoLayer)
                session.startRunning()
            }
            catch {
                
            }
           
        }
    }
    
    @objc func tapShutter(){
        //写真を撮る
        print("撮影しました")
        if isPhoto {
            output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
        else {
            if movieOutput.isRecording {
                //録画開始
                print("終了")
                movieOutput.stopRecording()
            }
            else {
                print("録画します")
             
            }
        }
        
    }
}

extension CameraViewController:AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
}

extension CameraViewController:AVCapturePhotoCaptureDelegate{
   
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)
        session.stopRunning()
        imageview.image = image
        imageview.contentMode = .scaleAspectFill
        imageview.frame = view.bounds
        view.addSubview(imageview)
     
    }
    
   
}


extension CameraViewController :CropViewControllerDelegate {
    
}

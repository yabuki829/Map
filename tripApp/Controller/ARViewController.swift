//
//  ARViewController.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/27.
//NSCameraUsageDescription

import Foundation
import UIKit
import ARKit
import SceneKit


class ARViewController :UIViewController,ARSCNViewDelegate{
 
    @IBOutlet weak var arView: ARSCNView!
    var discription:Article?
    var isFirst = 0
    override func viewDidLoad() {
        self.title = "AR"
        self.view.backgroundColor = .white
        let scene = SCNScene()
        arView.scene = scene
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        arView.session.pause()
    }
    

    
    @IBAction func tapGesture(_ recognizer: UITapGestureRecognizer) {
        if isFirst == 0 {
            let infrontOfCamera = SCNVector3(x: 0, y: 0, z: -0.3)

              // カメラ座標系 -> ワールド座標系
              guard let cameraNode = arView.pointOfView else { return }
              let pointInWorld = cameraNode.convertPosition(infrontOfCamera, to: nil)
              // ワールド座標系 -> スクリーン座標系
              var screenPos = arView.projectPoint(pointInWorld)

              // スクリーン座標系で
              // x, yだけ指の位置に変更
              // zは変えない
              let finger = recognizer.location(in: nil)
              screenPos.x = Float(finger.x)
              screenPos.y = Float(finger.y)

              // ワールド座標に戻す
              let finalPosition = arView.unprojectPoint(screenPos)

              // nodeを置く
            
            let imagePlane = SCNPlane(width: 0.1, height: 0.1)
            let imageview = UIImageView()
           isFirst = 1
            if discription?.type ==  "image" {
                
                imageview.setImage(urlString:discription!.data.url) { image in
                    
                    let planeNode = SCNNode(geometry: imagePlane)
                    planeNode.position = finalPosition
                    planeNode.geometry?.firstMaterial?.diffuse.contents = image
                    self.arView.scene.rootNode.addChildNode(planeNode)

                }
            }
            else {
                imageview.setImage(urlString:discription!.thumnail!.url) { image in
                    let planeNode = SCNNode(geometry: imagePlane)
                    planeNode.geometry?.firstMaterial?.diffuse.contents = image
                    self.arView.scene.rootNode.addChildNode(planeNode)

                }
            }
        }
        
    }

   
}

/*
 投稿のLocationの方角が違っていれば　矢印　＜ーを表示する
 例
 目的のlocationが北側で、今向いている方向が西側であれば　ー＞　を表示する
 
 
 
 
 
 */

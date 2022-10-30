//
//  MapAndDiscriptionCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/30.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation


// MapAndDiscription -> MapCell
//                   -> DiscriptionCell -> DiscriptionCell

class MapAndDiscriptionCell:BaseCell,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    var discriptionList : [Article]?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    var userid = String()
    var discriptioncell = discriptionCell()
    var mapCell = MapCell()
    var viewWidth = CGFloat()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collecitonview = UICollectionView(frame: .zero, collectionViewLayout:layout )
        collecitonview.dataSource = self
        collecitonview.delegate = self
        collecitonview.isScrollEnabled = false
        collecitonview.automaticallyAdjustsScrollIndicatorInsets = false
        return collecitonview
    }()
    
    override func setupViews() {
        contentView.addSubview(collectionView)
        addCollectionViewConstaraiont()
        collectionView.register(MapCell.self, forCellWithReuseIdentifier: "MapCell")
        collectionView.register(discriptionCell.self, forCellWithReuseIdentifier: "DiscriptionCell")
       
        discriptioncell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscriptionCell", for: IndexPath()) as! discriptionCell
        mapCell =  collectionView.dequeueReusableCell(withReuseIdentifier: "MapCell", for: IndexPath()) as! MapCell
  
    }
    func addCollectionViewConstaraiont(){
        collectionView.anchor(top: topAnchor, paddingTop: 0.0,
                              left: leftAnchor, paddingLeft: 0.0,
                              right: rightAnchor, paddingRight:0.0,
                              bottom: bottomAnchor, paddingBottom: 0.0)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("mapanddisc呼ばれてます")
        if indexPath.row == 1{
            mapCell.descriptionList = discriptionList!
            mapCell.viewWidth = viewWidth
            return mapCell
        }
        else{
            discriptioncell.discriptionList = discriptionList!
            return discriptioncell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    

   
}



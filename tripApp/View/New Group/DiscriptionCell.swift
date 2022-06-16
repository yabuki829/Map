//
//  DiscriptionCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/29.
//

import Foundation
import UIKit

class discriptionCell:BaseCell,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    var imageArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    var discriptionList : [Discription]?{
        didSet{
            
            if discriptionList!.count == 0{
                print("投稿が0件")
                emptyLabel.isHidden = false
                collectionView.isHidden = true
            }
            else{
                print("投稿があります")
                emptyLabel.isHidden = true
                collectionView.isHidden = false
                collectionView.reloadData()
            }
           
        }
    }
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collecitonview = UICollectionView(frame: .zero, collectionViewLayout:layout )
        collecitonview.dataSource = self
        collecitonview.delegate = self
        collecitonview.backgroundColor = .white
        collecitonview.automaticallyAdjustsScrollIndicatorInsets = false
        return collecitonview
    }()
    
    let emptyLabel : UILabel = {
        let label = UILabel()
        label.text = "投稿がありません"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.isHidden = true
        return label
    }()
    override func setupViews() {
       
        addSubview(collectionView)
        addSubview(emptyLabel)
      
        addConstaraiont()
        
        self.backgroundColor = .white
        collectionView.register(DiscriptionImageCell.self, forCellWithReuseIdentifier: "DiscriptionImageCell")
        
 
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discriptionList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscriptionImageCell", for: indexPath) as! DiscriptionImageCell
        
        cell.imageView.loadImageUsingUrlString(urlString:discriptionList![indexPath.row].image.imageUrl)
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width / 3, height: frame.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        delegate?.toDetail(discription: discriptionList![indexPath.row] )
        
    }
 
    func addConstaraiont(){
        collectionView.anchor(top: topAnchor, paddingTop: 5.0,
                              left: leftAnchor, paddingLeft: 0.0,
                              right: rightAnchor, paddingRight:0.0,
                              bottom: bottomAnchor, paddingBottom: 5.0)
        emptyLabel.anchor(top: topAnchor, paddingTop: 60,
                          left: leftAnchor, paddingLeft: 20,
                          right: rightAnchor, paddingRight: 20)
    }
    
    weak var delegate:transitionDelegate? = nil
    
}

protocol transitionDelegate: class  {
    func toDetail(discription:Discription)
    func toFriendList()
    func scroll()
}




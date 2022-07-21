//
//  DiscriptionView.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/14.
//

import Foundation
import UIKit


class DiscriptionView:baseView,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    var isHome = false
    var discriptionList : [Discription]?{
        didSet{
            if isHome {
                if discriptionList?.count != 0{
                    emptyLabel.isHidden = true
                    collectionView.isHidden = false
                    collectionView.reloadData()
                }
                else{
                    print("")
                    emptyLabel.text = "投稿がありません"
                }
            }
            
            else{
                if discriptionList!.count == 0{
                    emptyLabel.text = "投稿がありません"
                    emptyLabel.isHidden = false
                    collectionView.isHidden = true
                }
                else{
                    emptyLabel.isHidden = true
                    collectionView.isHidden = false
                    collectionView.reloadData()
                }
            }
            
           
        }
    }

    var cell = articleCell()
    var imageCell = DiscriptionImageCell()
    var profileArray = [Profile]()
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
      
        label.textAlignment = .center
        label.textColor = .darkGray
        label.isHidden = true
        return label
    }()
    override func setupViews() {
       
        self.addSubview(collectionView)
        self.addSubview(emptyLabel)
        
        addConstaraiont()
        
        collectionView.register(DiscriptionImageCell.self, forCellWithReuseIdentifier: "DiscriptionImageCell")
        collectionView.register(articleCell.self, forCellWithReuseIdentifier: "articleCell")
        collectionView.register(AdCell.self, forCellWithReuseIdentifier: "AdCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if DataManager.shere.getSubScriptionState() {
            return discriptionList!.count
        }
        else {
            if isHome{
                return discriptionList!.count + 3
            }
            else{
                return discriptionList!.count
            }
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if DataManager.shere.getSubScriptionState() {
            if isHome {
                //広告を入れる
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! articleCell
                cell.setCell(disc: discriptionList![indexPath.row])
                self.cell = cell
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscriptionImageCell", for: indexPath) as! DiscriptionImageCell
                cell.setCell(disc: discriptionList![indexPath.row])
                
                self.imageCell = cell
                return cell
            }
        }
        else {
            if isHome {
                //広告を入れる
                if indexPath.row < 3{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCell", for: indexPath) as! AdCell
                    return cell
                }
                else{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! articleCell
                    cell.setCell(disc: discriptionList![indexPath.row - 3])
                    self.cell = cell
                    return cell
                }
               
                
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscriptionImageCell", for: indexPath) as! DiscriptionImageCell
                cell.setCell(disc: discriptionList![indexPath.row])
                
                self.imageCell = cell
                return cell
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if DataManager.shere.getSubScriptionState() {
            if isHome {
                return CGSize(width:collectionView.frame.width, height: frame.width)
              
            }
            else{
                return CGSize(width:collectionView.frame.width / 3, height: frame.width / 3)
            }
        }
        else{
            if isHome {
                if indexPath.row < 3{
                    //広告　大きさ　320 / 100
                    return CGSize(width:collectionView.frame.width, height: 275)
                }
                else{
                    return CGSize(width:collectionView.frame.width, height: frame.width)
                }
              
            }
            else{
                return CGSize(width:collectionView.frame.width / 3, height: frame.width / 3)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if DataManager.shere.getSubScriptionState() {
            //サブスクリプションユーザー
           
            if isHome {
                let articleCell = collectionView.cellForItem(at: indexPath) as! articleCell
                
                if discriptionList![indexPath.row].type == "image"{
                    print("サブスクリプション 画像")
                    //imageの場合
                    delegate?.toDetailWithDiscriptionpCell(discription: discriptionList![indexPath.row], selectImage: articleCell.imageView.image!)
                }else{
                    print("サブスクリプション 動画")
                //ビデオの場合
                    delegate?.toDetailWithDiscriptionpCell(discription: discriptionList![indexPath.row])
                }
            }
            else{
                let discriptionCell = collectionView.cellForItem(at: indexPath) as! DiscriptionImageCell
                if discriptionList![indexPath.row].type == "image"{
                    print("サブスクリプション 画像 profile")
                    delegate?.toDetailWithDiscriptionpCell(discription:discriptionList![indexPath.row] , selectImage: discriptionCell.imageView.image!)
                }
                else{
                    print("サブスクリプション 動画　profile")
                    delegate?.toDetailWithDiscriptionpCell(discription: discriptionList![indexPath.row])
                }
              
            }
        }
        else {
            let index = IndexPath(row: indexPath.row - 3, section: 0)
            let articleCell = collectionView.cellForItem(at: index) as! articleCell
            if isHome {
               
                //1か2に変更する
                if indexPath.row < 3{
                    //広告
                }
                else{
                   
                    //imageの場合
                    if discriptionList![indexPath.row - 3].type == "image"{
                        delegate?.toDetailWithDiscriptionpCell(discription: discriptionList![indexPath.row - 3], selectImage: articleCell.imageView.image!)
                    }else{
                    //ビデオの場合
                        delegate?.toDetailWithDiscriptionpCell(discription: discriptionList![indexPath.row - 3])
                    }
                   
                    
                }
               
                
            }
            else{
                let discriptionCell = collectionView.cellForItem(at: indexPath) as! DiscriptionImageCell
                if discriptionList![indexPath.row].type == "image"{
                    print("image",discriptionCell.imageView.image!)
                    delegate?.toDetailWithDiscriptionpCell(discription:  discriptionList![indexPath.row], selectImage: discriptionCell.imageView.image!)
                }
                else{
                    print("video")
                    delegate?.toDetailWithDiscriptionpCell(discription: discriptionList![indexPath.row])
                }
              
            }
        }
     
       
        
    }
 
    func addConstaraiont(){
        collectionView.anchor(top: topAnchor, paddingTop: 0.0,
                              left: leftAnchor, paddingLeft: 0.0,
                              right: rightAnchor, paddingRight:0.0,
                              bottom: bottomAnchor, paddingBottom: 0.0)
        emptyLabel.anchor(top: topAnchor, paddingTop: 60,
                          left: leftAnchor, paddingLeft: 20,
                          right: rightAnchor, paddingRight: 20)
    }
    
    
    weak var delegate:transitionDelegate? = nil
    
}


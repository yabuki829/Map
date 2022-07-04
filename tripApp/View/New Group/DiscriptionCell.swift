//
//  DiscriptionCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/29.
//



import Foundation
import UIKit
class discriptionCell:BaseCell,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    var isHome = false
    var discriptionList : [Discription]?{
        didSet{
            if isHome {
                print("----------------Home--------------")
                if discriptionList?.count != 0{
                    print("投稿があります")
                    emptyLabel.isHidden = true
                    collectionView.isHidden = false
                    collectionView.reloadData()
                }
                else{
                    print("")
                    emptyLabel.text = "投稿がありません"
                }
                print("---------------------------------")
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
       
        contentView.addSubview(collectionView)
        contentView.addSubview(emptyLabel)
      
        addConstaraiont()
        
        collectionView.register(DiscriptionImageCell.self, forCellWithReuseIdentifier: "DiscriptionImageCell")
        collectionView.register(articleCell.self, forCellWithReuseIdentifier: "articleCell")
        collectionView.register(AdCell.self, forCellWithReuseIdentifier: "AdCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("カウント")
        if isHome{
            
            return discriptionList!.count + 3
        }
        else{
            return discriptionList!.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isHome {
            //広告を入れる
            if indexPath.row < 3{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCell", for: indexPath) as! AdCell
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! articleCell
                cell.setCell(userid: discriptionList![indexPath.row - 3].userid)
                cell.imageView.setImage(urlString:discriptionList?[indexPath.row - 3].image.url ?? "backgraund" )
                cell.dateLabel.text = discriptionList![indexPath.row - 3].created.secondAgo()
                return cell
            }
           
            
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscriptionImageCell", for: indexPath) as! DiscriptionImageCell
            cell.imageView.setImage(urlString: discriptionList![indexPath.row].image.url)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isHome {
            if indexPath.row < 3{
                
            }
            else{
                let cell = collectionView.cellForItem(at: indexPath) as! articleCell
                //imageの場合
                if discriptionList![indexPath.row - 3].type == "image"{
                    delegate?.toDetailWithDiscriptionpCell(discription:  discriptionList![indexPath.row - 3], selectImage: cell.imageView.image!)
                }else{
                //ビデオの場合
                }
               
                
            }
           
            
        }
        else{
            let cell = collectionView.cellForItem(at: indexPath) as! DiscriptionImageCell
            delegate?.toDetailWithDiscriptionpCell(discription:  discriptionList![indexPath.row], selectImage: cell.imageView.image!)
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

protocol transitionDelegate: class  {
    func toDetailWithDiscriptionpCell(discription:Discription,selectImage:UIImage)
    func toFriendList()
    func scroll()
}




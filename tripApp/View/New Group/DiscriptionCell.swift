//
//  DiscriptionCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/29.
//



import Foundation
import UIKit
class discriptionCell:BaseCell,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, ArticleCellDelegate{
    func showMenu(disc: Discription, profile: Profile) {
        delegate?.showMenu(disc: disc, profile: profile)
    }
    
   
    
    
    var isHome = false
    var discriptionList : [Discription]?{
        didSet{
            
            if isHome {
                    emptyLabel.isHidden = true
                    collectionView.isHidden = false
                    collectionView.reloadData()
                
             
            }
            
            else{
                emptyLabel.isHidden = true
                collectionView.isHidden = false
                collectionView.reloadData()
                
            }
            
           
        }
    }

    var articleCell = ArticleCell()
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
       
        contentView.addSubview(collectionView)
        contentView.addSubview(emptyLabel)
        
        addConstaraiont()
        
        collectionView.register(DiscriptionImageCell.self, forCellWithReuseIdentifier: "DiscriptionImageCell")
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "articleCell")
        collectionView.register(AdCell.self, forCellWithReuseIdentifier: "AdCell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        if isHome{
            return discriptionList!.count + 1
        }
        else{
            
            return discriptionList!.count
        }
        
        
       
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scroll")
        delegate?.scroll()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            if isHome {
                //広告を入れる
                if indexPath.row < 1 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCell", for: indexPath) as! AdCell
                    return cell
                }
                else{
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCell
                    cell.setCell(disc: discriptionList![indexPath.row - 1])
                    cell.delegate = self
                    articleCell = cell
                    
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
            if isHome {
                if indexPath.row < 1{
                    //広告　大きさ　320 / 100
                    return CGSize(width:collectionView.frame.width, height: frame.width)
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
            //1か2に変更する
            
            if indexPath.row < 1 {
                //広告
            }
            else{
                let articleCell = collectionView.cellForItem(at: indexPath) as! ArticleCell
                articleCell.backgroundColor = .systemGray6
                //imageの場合
                if discriptionList![indexPath.row - 1].type == "image"{
                    delegate?.toDetailWithDiscriptionpCell(discription: discriptionList![indexPath.row - 1], selectImage: articleCell.imageView.image!)
                }else{
                    //ビデオの場合
                    delegate?.toDetailWithDiscriptionpCell(discription: discriptionList![indexPath.row - 1])
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


import AVFoundation

protocol transitionDelegate: AnyObject  {
    func toDetailWithDiscriptionpCell(discription:Discription,selectImage:UIImage)
    func toDetailWithDiscriptionpCell(discription:Discription)
    func toFriendList()
    func scroll()
    func toEditPageWithProfileCell()
    func showMenu(disc:Discription,profile:Profile)
}





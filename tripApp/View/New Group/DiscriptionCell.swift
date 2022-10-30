//
//  DiscriptionCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/29.
//



import Foundation
import UIKit
class discriptionCell:BaseCell,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, ArticleCellDelegate{
    func showMenu(disc: Article, profile: Profile) {
        delegate?.showMenu(disc: disc, profile: profile)
    }
    
    var isHome = false
    var discriptionList : [Article]?{
        didSet{
            if discriptionList?.isEmpty == true {
                emptyLabel.isHidden = false
                collectionView.isHidden = true
                
                if LanguageManager.shered.getlocation() == "ja" {
                    emptyLabel.text = "まだ投稿がありません"
                }
                else {
                    emptyLabel.text = "No posts yet."
                }
                
                
            }
            else {
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
//        collectionView.register(NativeAdCell.self, forCellWithReuseIdentifier: "NativeAdCell")
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        if isHome{
            if LanguageManager.shered.getlocation() == "ja" {
                let a = Double(discriptionList!.count / 9 + 1)
                let i = ceil(a)
                return discriptionList!.count + Int(i)
            }
            else {
               
                return discriptionList!.count
            }
           
        }
        else{
            
            return discriptionList!.count
        }
        
        
       
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        delegate?.scroll()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            print(indexPath.row)
            if isHome {
                
                if LanguageManager.shered.getlocation() == "ja" {
                    //広告を入れる　日本語であれば
                    if indexPath.row ==  0 {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCell", for: indexPath) as! AdCell
                        return cell
                    }
                    else if indexPath.row % 9 == 0 {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCell", for: indexPath) as! AdCell
                        return cell
                    }
                    else {
                        let a = Double(discriptionList!.count / 9 + 1)
                        let i = Int(ceil(a))
                       
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCell
                        cell.setCell(disc: discriptionList![indexPath.row - i])
                        cell.delegate = self
                        articleCell = cell
                        return cell
                    }
                }
                else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCell
                    cell.setCell(disc: discriptionList![indexPath.row])
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
               
                return CGSize(width:collectionView.frame.width, height: frame.width)
                
              
            }
            else{
                return CGSize(width:collectionView.frame.width / 3, height: frame.width / 3)
            }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isHome {
            if LanguageManager.shered.getlocation() == "ja" {
                // 日本語であれば
                if indexPath.row !=  0 || indexPath.row % 9 != 0 {
                    let i = indexPath.row / 9 + 1
                    let articleCell = collectionView.cellForItem(at: indexPath) as! ArticleCell
                    articleCell.backgroundColor = .white
                    //imageの場合
                    if discriptionList![indexPath.row - i].type == "image"{
                        delegate?.toDetailWithDiscriptionpCell(discription: discriptionList![indexPath.row - i], selectImage: articleCell.imageView.image!)
                    }else{
                        //ビデオの場合
                        delegate?.toDetailWithDiscriptionpCell(discription: discriptionList![indexPath.row - i])
                    }
                }
            }
            else {
                let articleCell = collectionView.cellForItem(at: indexPath) as! ArticleCell
                articleCell.backgroundColor = .white
                if discriptionList![indexPath.row].type == "image"{
                    delegate?.toDetailWithDiscriptionpCell(discription: discriptionList![indexPath.row], selectImage: articleCell.imageView.image!)
                }else{
                    delegate?.toDetailWithDiscriptionpCell(discription: discriptionList![indexPath.row])
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
    
    func toDetailWithDiscriptionpCell(discription:Article,selectImage:UIImage)
    func toDetailWithDiscriptionpCell(discription:Article)
    func toFriendList()
    func scroll()
    func toEditPageWithProfileCell()
    func showMenu(disc:Article,profile:Profile)
}





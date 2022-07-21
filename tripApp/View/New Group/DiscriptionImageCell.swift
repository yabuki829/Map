
import Foundation
import UIKit

class DiscriptionImageCell:UICollectionViewCell{
    
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    var discription:Discription?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){

       
    }
    func setCell(disc:Discription){
        discription = disc
        addImageViewConstraint()
    
    }
    func addImageViewConstraint(){
        contentView.addSubview(imageView)
        imageView.anchor(top: self.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                         left: self.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
                         right: self.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                         bottom: self.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        if discription!.type == "image"{
            imageView.setImage(urlString: discription!.data.url)
        }
        else {
            let playimage = UIImageView()
            playimage.image = UIImage(systemName: "play.fill")
            playimage.tintColor = .white
          
            imageView.addSubview(playimage)
            playimage.center(inView: imageView)
            imageView.setImage(urlString: discription!.thumnail!.url)
        }
        
       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





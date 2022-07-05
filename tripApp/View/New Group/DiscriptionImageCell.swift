
import Foundation
import UIKit

class DiscriptionImageCell:UICollectionViewCell{
    
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    let videoView = VideoPlayer()
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
        if discription!.type == "image"{
            contentView.addSubview(imageView)
            imageView.anchor(top: self.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                             left: self.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
                             right: self.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                             bottom: self.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
            imageView.setImage(urlString: discription!.image.url)
        }
        else{
            print("VideoView")
            contentView.addSubview(videoView)
            videoView.anchor(top: self.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                             left: self.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
                             right: self.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                             bottom: self.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
            videoView.loadVideo(urlString: discription!.image.url)
            videoView.setup()
        }
       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





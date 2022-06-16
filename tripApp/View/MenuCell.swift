import Foundation
import UIKit

class menubarCell:BaseCell{
    
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                backgroundColor = .systemGray5
            }
            else{
                backgroundColor = .white
            }
        }
    }
    
    let title:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let iconImage:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named:"tv")
        image.tintColor = .link
        return image
    }()

    override func setupViews() {
        addSubview(title)
        addSubview(iconImage)
        
        addtitleConstraint()
        addIconImageConstraint()
    }
    func setCell(setting:menuItem){
        title.text = setting.name
        iconImage.image = UIImage(systemName: setting.icon)
    }
    func addIconImageConstraint(){
        iconImage.topAnchor.constraint(equalTo: self.topAnchor, constant:10).isActive = true
        iconImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32).isActive = true
        iconImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    func addtitleConstraint(){
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        title.leftAnchor.constraint(equalTo: iconImage.rightAnchor, constant: 20).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
}



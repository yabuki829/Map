//
//  MenuView.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/24.
//

import Foundation
import UIKit

import UIKit
public let menuBarTitleArray = ["map","house"]

class MenuBar:UIView, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    var selectedIndexPath: IndexPath?
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
        
        let collecitonview = UICollectionView(frame: .zero, collectionViewLayout:layout )
        collecitonview.dataSource = self
        collecitonview.delegate = self
        collecitonview.backgroundColor = .white
        return collecitonview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        addCollectionViewConstaraiont()
        self.backgroundColor = .white
        collectionView.register(MenuBarCell.self, forCellWithReuseIdentifier: "Cell")
        
        let indexPath:IndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
        self.selectedIndexPath = indexPath
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuBarTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MenuBarCell
        cell.setCell(title: menuBarTitleArray[indexPath.row])
        if  selectedIndexPath?.row == indexPath.row{
                cell.isSelected = true
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width / 2, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        delegate?.reload()
    }
 
    func addCollectionViewConstaraiont(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5.0).isActive = true
    }
    weak var delegate:reloadDelegate? = nil
}



class MenuBarCell:BaseCell{
    
    override var isSelected: Bool{
        didSet{
            imageView.tintColor = isSelected ? .darkGray : .lightGray
        }
    }
    
    let imageView :UIImageView = {
        let imageview = UIImageView()
        imageview.tintColor = .lightGray
        
        return imageview
    }()
    
    override func  setupViews(){
        addSubview(imageView)
        imageView.setDimensions(width: 24, height: 24)
        imageView.center(inView: self)
    }

    func setCell(title:String){
        imageView.image = UIImage(systemName: title)
    }
    

        
}
protocol reloadDelegate: class  {
    func reload()
}

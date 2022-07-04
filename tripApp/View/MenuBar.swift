import Foundation
import UIKit

import UIKit

class MenuCell :BaseCell,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    var selectedIndexPath: IndexPath?
    var menuBarTitleArray = ["map","squareshape.split.3x3"]
    private let underlineView: UIView = {
         let view = UIView()
         return view
     }()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collecitonview = UICollectionView(frame: .zero, collectionViewLayout:layout )
        collecitonview.dataSource = self
        collecitonview.delegate = self
        collecitonview.isScrollEnabled = false
        return collecitonview
    }()
    override func setupViews() {
        contentView.addSubview(collectionView)
        addCollectionViewConstaraiont()
        backgroundColor = .red
        self.backgroundColor = .white
        collectionView.register(MenuBarCell.self, forCellWithReuseIdentifier: "Cell")
        
        
        let indexPath:IndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
        self.selectedIndexPath = indexPath
        
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuBarTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MenuBarCell
        cell.setCell(title: menuBarTitleArray[indexPath.row])
       
        if  selectedIndexPath?.row == indexPath.row {
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
        return CGSize(width:collectionView.frame.width / 2, height: frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        delegate?.reload()
    }
 
    func addCollectionViewConstaraiont(){
        collectionView.anchor(top: topAnchor, paddingTop: 0.0,
                              left: leftAnchor, paddingLeft: 0.0,
                              right: rightAnchor, paddingRight:0.0,
                              bottom: bottomAnchor, paddingBottom: 0.0)
    }
    weak var delegate:reloadDelegate? = nil
}

class MenuBarCell:BaseCell{
    override var isSelected: Bool{
          didSet{
              imageView.tintColor = isSelected ? .systemGray6 : .systemGray2
              backgroundColor = isSelected ? .systemGray2 : .systemGray6
          }
      }
      
      let imageView :UIImageView = {
          let imageview = UIImageView()
          imageview.tintColor = .systemGray4
          
          return imageview
      }()
      
      override func  setupViews(){
          addSubview(imageView)
          backgroundColor = .systemGray6
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


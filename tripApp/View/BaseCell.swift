//
//  BaseCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/12.
//

import Foundation
import UIKit
class BaseCell:UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){}
}


class BaseTableViewCell:UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:.default , reuseIdentifier: "comment")
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){}
}

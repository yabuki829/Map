import Foundation
import UIKit


class DetailViewController:UIViewController{
    
    var diary = Diary(id: "0", image: Data(), title: "", text: nil, date: Date(), location: nil) {
        didSet{
          
            topImage.image = UIImage(data: diary.image)
            textView.text = diary.text
            titleLabel.text = diary.title
        }
    }
    let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 30)
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        return label
    }()
    let topImage:UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        return image
    }()
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.textColor = .darkGray
        tv.isEditable = false
        
        return tv
    }()
    let deleteButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "trash.circle.fill"), for: .normal)
        button.tintColor = .systemGray6
        return button
    }()
    let backButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "chevron.backward.circle.fill"), for: .normal)
        button.tintColor = .systemGray5
        
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(topImage)
        view.addSubview(textView)
        view.addSubview(backButton)
        view.addSubview(deleteButton)
        view.addSubview(titleLabel)
        topImage.layer.cornerRadius = view.frame.width / 10
        topImage.clipsToBounds = true
        let mytapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        topImage.addGestureRecognizer(mytapGesture)
        
        deleteButton.addTarget(self, action: #selector(delete(sender:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        addTopImageConstraint()
        addTextViewConstraint()
        addButtonConstraints()
        addTitleLabelConstraint()
    }
    
    @objc internal func tapGesture(sender:UITapGestureRecognizer ){
        let  vc = ImageDetailViewContriller()
        vc.image = topImage.image
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    func setNav(){
        let backButton = UIImage(systemName: "chevron.left")
        let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
        let deleteItem = UIBarButtonItem(title: "削除する", style: .plain, target: self, action: #selector(delete(sender:)))
        
    
        backItem.tintColor = .darkGray
        navigationItem.leftBarButtonItem = backItem
        
        navigationItem.rightBarButtonItem = deleteItem
    }
    @objc func back(sender : UIButton){
        print("Back")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc func delete(sender : UIButton){
       deleteAlert()
    }
    func addTopImageConstraint(){
        topImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        topImage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        topImage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        topImage.heightAnchor.constraint(equalToConstant: view.frame.width - 10 - 10 ).isActive = true
    }
   
    func  addTitleLabelConstraint(){
        titleLabel.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: 2).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 2).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant:-2).isActive = true
    }
    func addTextViewConstraint(){
        textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func addButtonConstraints(){
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        let size = view.frame.width / 12
        backButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        backButton.layer.cornerRadius = size / 2
        backButton.clipsToBounds = true
        
        deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        deleteButton.layer.cornerRadius = size / 2
        deleteButton.clipsToBounds = true
       
    }
    func deleteAlert(){
        let alert = UIAlertController(title: "報告", message: "削除してもよろしいですか？", preferredStyle: .alert)
            
            
                
                let selectAction = UIAlertAction(title: "削除する", style: .default, handler: { _ in
                    DataManager.shere.delete(id: self.diary.id)
                    self.navigationController?.dismiss(animated: true, completion: nil)
                })
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

                alert.addAction(selectAction)
                alert.addAction(cancelAction)

                present(alert, animated: true)
    }
}

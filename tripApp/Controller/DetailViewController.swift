import Foundation
import UIKit


class DetailViewController:UIViewController, UITextFieldDelegate{
    
    var diary = Diary(id: "0", userid:nil, image: Data(), title: "", text: nil, date: Date(), location: nil) {
        didSet{
            topImage.image = UIImage(data: diary.image)
            textLabel.text = diary.text
            titleLabel.text = diary.title
            dateLabel.text = diary.date.covertString()
            diary.location?.geocoding(compleation: { (text) in
                self.navigationItem.title = text
            })
        }
    }
    let commentArray = ["コメント","コメント","コメント","コメント"]
    let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.indexDisplayMode = .alwaysHidden
        return scrollView
    }()
    let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        return label
    }()
    let topImage:UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        return image
    }()

    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.backgroundColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.tintColor = .systemGray5
        label.textAlignment = .right
        return label
    }()
    let baseView = UIView()
    let collectionview:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    let fieldView :textFieldView = {
        let view = textFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var textFieldViewBottomConstraint: NSLayoutConstraint!
    var scrollViewBottomConstraint:  NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionview.delegate = self
        collectionview.dataSource = self
        
        print("----------------------------------------------")
        view.addSubview(scrollView)
        view.addSubview(fieldView)
        scrollView.addSubview(topImage)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(textLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(collectionview)
        
        addScrollViewConstraint()

        setNav()
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        let mytapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        topImage.addGestureRecognizer(mytapGesture)
        let tapScrollView = UITapGestureRecognizer(target: self, action: #selector(tapScrollView(sender:)))
        scrollView.addGestureRecognizer(tapScrollView)
        setting()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
                     self,
                     selector:#selector(keyboardWillShow(_:)),
                     name: UIResponder.keyboardWillShowNotification,
                     object: nil
                   )
                   NotificationCenter.default.addObserver(
                     self,
                     selector: #selector(keyboardWillHide(_:)),
                     name: UIResponder.keyboardWillHideNotification,
                     object: nil
                   )
        
    }
    @objc func keyboardWillShow(_ notification: Notification) {
         
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        textFieldViewBottomConstraint.constant = -keyboardFrame.size.height + self.view.safeAreaInsets.bottom - 5
        print("オープン")
        print(textFieldViewBottomConstraint.constant)
        UIView.animate(withDuration: 1.0, animations: { [self] () -> Void in
            self.view.layoutIfNeeded()
        })
          
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        print("クローズ")
        
        textFieldViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 1.0, animations: { [self] () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func tapScrollView(sender:UITapGestureRecognizer){
        print("tap")
        self.view.endEditing(true)
        fieldView.textfield.resignFirstResponder()
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        fieldView.textfield.resignFirstResponder()
          return true
      }
    func setting(){
        fieldView.textfield.delegate = self
    }
    @objc internal func tapGesture(sender:UITapGestureRecognizer ){
        let  vc = ImageDetailViewContriller()
        vc.image = topImage.image
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
 
    func addScrollViewConstraint(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        
        scrollView.flashScrollIndicators()
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
        scrollViewBottomConstraint = scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0)
        
        topImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        topImage.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        topImage.rightAnchor.constraint(equalTo:scrollView.rightAnchor, constant: 0).isActive = true
        topImage.heightAnchor.constraint(equalToConstant: view.frame.width - 10 - 10 ).isActive = true
        topImage.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
       
        titleLabel.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo:scrollView.rightAnchor, constant: 0).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        dateLabel.rightAnchor.constraint(equalTo:scrollView.rightAnchor, constant: 0).isActive = true

        textLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        textLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        textLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -10).isActive = true
        
        collectionview.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant:10).isActive = true
        collectionview.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        collectionview.rightAnchor.constraint(equalTo:scrollView.rightAnchor, constant: 0).isActive = true
        collectionview.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        collectionview.heightAnchor.constraint(equalToConstant: CGFloat(commentArray.count * 70)).isActive = true
       
        fieldView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant:10).isActive = true
        fieldView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        fieldView.rightAnchor.constraint(equalTo:view.rightAnchor, constant: 0).isActive = true
//        fieldView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        textFieldViewBottomConstraint =  fieldView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        textFieldViewBottomConstraint.isActive = true
        fieldView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
    func setNav(){
        let backButton = UIImage(systemName: "chevron.left")
        let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
        let trashButton = UIImage(systemName: "trash.circle")
        let deleteItem = UIBarButtonItem(image:trashButton, style: .plain, target: self, action: #selector(delete(sender:)))
        
    
        backItem.tintColor = .darkGray
        deleteItem.tintColor = .darkGray
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
    
}


extension DetailViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 5
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 12
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 8, height: 8)
        cell.layer.masksToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.95, height: 60)
    }


}



class textFieldView:UIView{
    
    var textfield:UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .systemGray6
        textfield.layer.cornerRadius = 16
        textfield.layer.borderWidth = 2.0
        textfield.layer.borderColor = UIColor.systemGray2.cgColor
        textfield.clipsToBounds = true
        return textfield
    }()
    
    var sendButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("送信", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("A")
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){
        print("B")
        self.addSubview(textfield)
        self.addSubview(sendButton)
        addConsrtaints()
    }
    func addConsrtaints(){
        textfield.topAnchor.constraint(equalTo: self.topAnchor, constant: 2.0).isActive = true
        textfield.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0).isActive = true
        textfield.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 0.0).isActive = true
        textfield.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.0).isActive = true
        
        sendButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        sendButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5.0).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60 ).isActive = true
        print(self.frame.width)
    }
 
}


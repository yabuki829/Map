import Foundation
import UIKit


class DetailViewController:UIViewController{
    
    var diary = Diary(id: "0", image: Data(), title: "", text: nil, date: Date(), location: nil) {
        didSet{
            self.title = diary.title
            topImage.image = UIImage(data: diary.image)
            textView.text = diary.text
        }
    }
    let topImage:UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(topImage)
        view.addSubview(textView)
        let mytapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        topImage.addGestureRecognizer(mytapGesture)
        addTopImageConstraint()
        addTextViewConstraint()
        setNav()
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
        backItem.tintColor = .darkGray
        navigationItem.leftBarButtonItem = backItem
    }
    @objc func back(sender : UIButton){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    func addTopImageConstraint(){
        topImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        topImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        topImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        topImage.heightAnchor.constraint(equalToConstant: view.frame.width ).isActive = true
    }
    func addTextViewConstraint(){
        textView.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: 0).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}

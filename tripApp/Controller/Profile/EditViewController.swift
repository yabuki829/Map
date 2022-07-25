import Foundation
import UIKit
import CropViewController
import FirebaseStorage
import PKHUD
class EditViewController : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,CropViewControllerDelegate,UITextViewDelegate{
    
    let storege = Storage.storage().reference()
    
    let backgraundImage:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "person.crop.circle.fill")
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    let profileImage:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "backgorund")
        imageview.isUserInteractionEnabled = true
        imageview.backgroundColor = .white
        return imageview
    }()
    
    let wordCountLabel:UILabel = {
        let label = UILabel()
        label.text = "0 / 80"
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    let usernameStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    let textView:UITextView = {
        let textview = UITextView()
        textview.text = "profile"
        return textview
    }()
    let textfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Name.."
        return textfield
    }()
    var profileimagedata : Data?
    var isChangedProfileImage = false
    
    var backgroundimagedata : Data?
    var isChangedBackgroundImage = false
    
    var profile:Profile?{
        didSet{
            if profile!.backgroundImage.name == "background"  || profile!.backgroundImage.url == "background" {
                backgraundImage.image = UIImage(named: "background")
            }
            else if profile!.backgroundImage.name == "" || profile!.backgroundImage.url != ""{
                backgraundImage.setImage(urlString:profile!.backgroundImage.url  )
            }
            else{
                backgraundImage.setImage(urlString: (profile?.backgroundImage.url)!)
            }
            
            
            if  profile!.profileImage.name == "person.crop.circle.fill"  || profile!.profileImage.url == "person.crop.circle.fill" {
                profileImage.image =  UIImage(systemName:"person.crop.circle.fill")
            }
            else if profile!.profileImage.name == "" || profile!.profileImage.url == ""{
                profileImage.setImage(urlString: profile!.profileImage.url)
            }
            else{
                profileImage.setImage(urlString: (profile?.profileImage.url)!)
            }
            textfield.text = profile?.username
            textView.text = profile?.text
            wordCountLabel.text =  "\(textView.text.count) / 80"
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
     }
    override var shouldAutorotate: Bool {
                return true
    }
    override func viewDidLoad() {
        view.backgroundColor = .white
       
        setNav()
        addConstraint()
        tapSetting()
        profile = DataManager.shere.getMyProfile()
        textView.returnKeyType = .done
        textView.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        textfield.setUnderLine(color: .black)
    }
    
    func setNav(){
        self.title = "Edit"
        let backButton = UIImage(systemName: "chevron.left")
        let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
        
        let editItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action:  #selector(edit(sender:)))
        
        backItem.tintColor = .darkGray
        editItem.tintColor = .darkGray
        navigationItem.leftBarButtonItem = backItem
        
        navigationItem.rightBarButtonItem = editItem
    }
    func  addConstraint(){
        view.addSubview(backgraundImage)
        view.addSubview(profileImage)
        view.addSubview(usernameStackView)
        view.addSubview(wordCountLabel)
        view.addSubview(textView)
        
        backgraundImage.translatesAutoresizingMaskIntoConstraints = false
        backgraundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        backgraundImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        backgraundImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backgraundImage.heightAnchor.constraint(equalToConstant: view.frame.width / 2  ).isActive = true
        backgraundImage.widthAnchor.constraint(equalToConstant: view.frame.width  ).isActive = true
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: backgraundImage.bottomAnchor, constant: -view.frame.width / 4 / 2 ).isActive = true
        profileImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width / 2 - view.frame.width / 4 / 2).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        profileImage.layer.cornerRadius = view.frame.width / 4 / 2
        profileImage.clipsToBounds = true
        
        usernameStackView.translatesAutoresizingMaskIntoConstraints = false
        usernameStackView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        usernameStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        usernameStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        
        wordCountLabel.anchor(top: usernameStackView.bottomAnchor, paddingTop: 5,
                              left: view.leftAnchor, paddingLeft: 10,
                              right: view.rightAnchor, paddingRight: 10)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: wordCountLabel.bottomAnchor, constant: 0).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        let label = UILabel()
        label.text = "NAME:"
        
        usernameStackView.addArrangedSubview(label)
        usernameStackView.addArrangedSubview(textfield)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    func tapSetting(){
        let tapprofileimage = UITapGestureRecognizer(target: self, action: #selector(tapProfileImage(sender:)))
        let tapbackgroundimage = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundImage(sender:)))
        profileImage.addGestureRecognizer(tapprofileimage)
        backgraundImage.addGestureRecognizer(tapbackgroundimage)
    }
    @objc func back(sender : UIButton){
        print("Back")
        
        self.navigationController?.popViewController(animated: true)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder() //キーボードを閉じる
            return false
        }
        else {
            return textView.text.count + (text.count - range.length) <= 80
        }
        
    }
    func textViewDidChange(_ textView: UITextView) {
        wordCountLabel.text = "\(textView.text.count) / 80"
    }
}


extension EditViewController {
    
    @objc func tapBackgroundImage(sender:UITapGestureRecognizer){
        print("Tap Backgraund Image")
        //画像を開き長方形でカットする
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    @objc func tapProfileImage(sender:UITapGestureRecognizer){
        print("Tap Profile Image")
        //画像を開き正方形でカットする
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.allowsEditing {
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{ return }
            guard let imageData = image.jpegData(compressionQuality: 0.25) else {  return }
            profileImage.image = UIImage(data: imageData)
            profileimagedata = imageData
            isChangedProfileImage = true
            picker.dismiss(animated: true, completion: nil)
            
        }else{
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{ return }
            let cropController = CropViewController(croppingStyle: .default, image: image)
            cropController.delegate = self
            cropController.customAspectRatio = CGSize(width: view.frame.width, height: view.frame.width / 2)
            cropController.aspectRatioPickerButtonHidden = true
            cropController.resetAspectRatioEnabled = false
            cropController.rotateButtonsHidden = true
            
            cropController.cropView.cropBoxResizeEnabled = false
            picker.dismiss(animated: true) {
                self.present(cropController, animated: true, completion: nil)
            }
        }
        
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        guard let imageData = image.jpegData(compressionQuality: 0.25) else {  return }
        
        backgroundimagedata = imageData
        backgraundImage.image =  UIImage(data: imageData)
        isChangedBackgroundImage = true
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        picker.dismiss(animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
}


extension EditViewController{
    @objc func edit(sender : UIButton){
        print("Edit")
        if textfield.text == ""{
            return
        }
        //　インゲーターを回す
        HUD.show(.progress)
        
        if isChangedProfileImage || isChangedBackgroundImage {
            // プロフィール画像とバックグラウンド画像を変更する場合
            if  isChangedProfileImage && isChangedBackgroundImage{
                //前の画像を削除する
                print("-----------両方新しい画像-----------")
                if profile?.profileImage.name != "person.crop.circle.fill" {
                    StorageManager.shered.deleteProfileImage(name: (profile?.profileImage.name)!)
                    
                }
                if profile?.backgroundImage.name != "background"{
                    StorageManager.shered.deletebackgroundImage(name: (profile?.backgroundImage.name)!)
                }
                //両方とも新しい画像
                FirebaseManager.shered.editProfileA(text: textView.text,
                                                    username: textfield.text!,
                                                    bgImagedata: backgroundimagedata,
                                                    proImagedata: profileimagedata) { result in
                    HUD.hide()
                    if result {
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                }
            }
            else{
                
                if isChangedProfileImage{
                    //プロフィール画像を変更する場合
                    print("-----------プロフィール画像が新しい---------------")
                    if profile?.profileImage.name != "person.crop.circle.fill" {
                        StorageManager.shered.deleteProfileImage(name: (profile?.profileImage.name)!)
                        
                    }
                    
                    //profile画像を変更する　ここ
                  
                    
                    FirebaseManager.shered.editProfileB(text: textView.text!, username: textfield.text!, bgImagedata: nil, proImagedata: profileimagedata, profile: profile!) { result in
                        
                    
                        HUD.hide()
                        if result {
                            self.navigationController?.popViewController(animated: true)
                            return
                        }
                    }
                }
                else{
                    //バックグランド画像を変更する場合
                    if isChangedBackgroundImage  {
                        print("----------バックグラウンドが新しい画像-----------")
                        if profile?.profileImage.name != "person.crop.circle.fill" {
                            //前のbackgroundを削除する
                            StorageManager.shered.deletebackgroundImage(name: (profile?.backgroundImage.name)!)
                        }
                        FirebaseManager.shered.editProfileB(text: textView.text!, username: textfield.text!, bgImagedata: backgroundimagedata, proImagedata: nil, profile: profile!) { result in
                                HUD.hide()
                            if result {
                                self.navigationController?.popViewController(animated: true)
                                return
                            }
                        }
                    }
                }
            }
            
            
         
              
        }
        else{
            //画像を変更しない場合
            print("----------画像を変更しない------------")
            FirebaseManager.shered.editProfileC(text: textView.text!, username: textfield.text!, backgroundImageUrl: profile?.backgroundImage.url, profileImageUrl: profile?.profileImage.url){ result in
                
                HUD.hide()
                if result{
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                
            }
            
        }
    }
        
}

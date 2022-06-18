import Foundation
import UIKit
import CropViewController
import FirebaseStorage
import PKHUD
class EditViewController : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,CropViewControllerDelegate{
    
    let storege = Storage.storage().reference()
   
    let backgraundImage:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "person.crop.circle.fill")
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
    
    let usernameStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    let textView:UITextView = {
        let textview = UITextView()
        textview.text = "Learn from the mistakes of others. You can’t live long enough to make them all yourself."
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
    
    var profile:myProfile? {
        didSet{
            if profile!.backgroundImage.name == "background"  || profile!.backgroundImage.url == "background" {
                backgraundImage.image = UIImage(named: "background")
            }
            else if profile!.backgroundImage.name == "" || profile!.backgroundImage.url != ""{
                backgraundImage.loadImageUsingUrlString(urlString: profile!.backgroundImage.url )
            }
            else{
                backgraundImage.image = UIImage(data: profile!.backgroundImage.imageData)
            }
            
            
            if  profile!.profileImage.name == "person.crop.circle.fill"  || profile!.profileImage.url == "person.crop.circle.fill" {
                profileImage.image =  UIImage(systemName:"person.crop.circle.fill")
            }
            else if profile!.profileImage.name == "" || profile!.profileImage.url != ""{
                profileImage.loadImageUsingUrlString(urlString: profile!.profileImage.url )
            }
            else{
                profileImage.image = UIImage(data: profile!.profileImage.imageData)
            }
            textfield.text = profile?.username
            textView.text = profile?.text
        }
    }
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(backgraundImage)
        view.addSubview(profileImage)
        view.addSubview(usernameStackView)
        view.addSubview(textView)
        setNav()
        addConstraint()
        tapSetting()
        profile = DataManager.shere.getMyProfile()
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
       
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: usernameStackView.bottomAnchor, constant: 20).isActive = true
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
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc func edit(sender : UIButton){
        print("Edit")
        print("profile",profileimagedata,"backimage",backgroundimagedata)
        if textfield.text == ""{
            return
        }
        //　インゲーターを回す
        HUD.show(.progress)
        
        if isChangedProfileImage || isChangedBackgroundImage{
            
            // プロフィール画像とバックグラウンド画像を変更する場合
            if  isChangedProfileImage && isChangedBackgroundImage{
                //前の画像を削除する
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
                        self.navigationController?.dismiss(animated: true, completion: nil)
                        return
                    }
                }
            }
            else if isChangedProfileImage{
                //プロフィール画像を変更する場合
                if profile?.profileImage.name != "person.crop.circle.fill" {
                    StorageManager.shered.deletebackgroundImage(name: (profile?.backgroundImage.name)!)
                    
                }
                    //profile画像を変更する　ここ
                FirebaseManager.shered.editProfileB(text: textView.text!, username: textfield.text!, bgImagedata: nil, proImagedata: profileimagedata, backgroundimageurl: (profile?.backgroundImage.url)!, profileimageurl: (profile?.profileImage.url)!) { result in
                    HUD.hide()
                    if result {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                        return
                    }
                }
            }
            else{
                //バックグランド画像を変更する場合
                if isChangedBackgroundImage  {
                    if profile?.profileImage.name != "person.crop.circle.fill" {
                        StorageManager.shered.deletebackgroundImage(name: (profile?.backgroundImage.name)!)
                    }
                    FirebaseManager.shered.editProfileB(text: textView.text!, username: textfield.text!, bgImagedata: backgroundimagedata, proImagedata: nil, backgroundimageurl: (profile?.backgroundImage.url)!, profileimageurl:  (profile?.profileImage.url)!) { result in
                        HUD.hide()
                        if result {
                            self.navigationController?.dismiss(animated: true, completion: nil)
                            return
                        }
                    }
                }
            }
          
        }
        else{
            //画像を変更しない場合
            FirebaseManager.shered.editProfileC(text: textView.text!, username: textfield.text!, backgroundImageUrl: profile?.backgroundImage.url, profileImageUrl: profile?.profileImage.url){ result in
            
                    HUD.hide()
                    if result{
                        self.navigationController?.dismiss(animated: true, completion: nil)
                        return
                    }
                  
                }

        }
        
       
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

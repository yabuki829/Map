import Foundation
import UIKit
import IQKeyboardManagerSwift
import FirebaseAuth

class EmailLoginViewController:UIViewController, UITextFieldDelegate{
    let iconImageView:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "地球アイコン")
        image.contentMode = .scaleAspectFit
        return image
    }()
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Sign in With Email"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    let emailTextField :UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.keyboardType = .emailAddress
        tf.placeholder = "Email"
        return tf
    }()
    let passwordTextField :UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        return tf
    }()
    let loginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Sign in ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.backgroundColor = .link
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.view.backgroundColor = .white
        view.addSubview(iconImageView)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: view.frame.width / 4,
                             left: view.leftAnchor,paddingLeft: view.frame.width / 2 - view.frame.width / 4,
                             width: view.frame.width / 2,
                             height: view.frame.width / 2)
        view.addSubview(titleLabel)
        titleLabel.anchor(left: view.leftAnchor, paddingLeft: 10,
                          right: view.rightAnchor, paddingRight: 10,
                          bottom: iconImageView.topAnchor,paddingBottom: 5
        )
        
        view.addSubview(emailTextField)
        emailTextField.center(inView: view)
        emailTextField.anchor(width:view.frame.width - 80, height: 40)
        
        view.addSubview(passwordTextField)
        passwordTextField.anchor(top:emailTextField.bottomAnchor , paddingTop: 40,
                                 left: view.leftAnchor, paddingLeft: 40,
                                 right: view.rightAnchor, paddingRight: 40,
                                 height: 40)
        view.addSubview(loginButton)
        loginButton.anchor(top:passwordTextField.bottomAnchor , paddingTop: 60,
                           left: view.leftAnchor, paddingLeft: 40,
                           right: view.rightAnchor, paddingRight: 40,
                           height: 40)
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(loginWithEmail), for: .touchDown)
        setting()
    }
    func setting(){
        IQKeyboardManager.shared.enable = true
        emailTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        emailTextField.leftViewMode = .always
        
        passwordTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        passwordTextField.leftViewMode = .always
        
        
    }
    

    func setNav(){
      
        let backButton = UIImage(systemName: "chevron.left")
        let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
        backItem.tintColor = .darkGray
        navigationItem.leftBarButtonItem = backItem
      
      
    }
    @objc func back(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func loginWithEmail(){
        //パスワードとメールアドレスが入っているか確認
        guard !emailTextField.text!.isEmpty || !passwordTextField.text!.isEmpty else{
            print("パスワードもしくはメールがからです")
            return
        }
        
        let passwordValidate = Validator.shared.passwordCheck(with: "aaa", min: 8, max: 20)
        
        if validateEmail(email: emailTextField.text!) || passwordValidate.isValid{
            print("OK")
            AuthManager.shered.startAuthWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { result in
                if result {
                    FirebaseManager.shered.getProfile(userid: Auth.auth().currentUser!.uid) { profile in
                        
                        let myprofile:Profile = Profile(userid: profile.userid,
                                                  username: profile.username,
                                                        text: profile.text ,
                                                          backgroundImage: ProfileImage(url: profile.backgroundImage.url, name: profile.profileImage.url ),
                                                          profileImage: ProfileImage( url: profile.profileImage.url,name:profile.profileImage.name))
                        
                        DataManager.shere.setMyProfile(profile: myprofile)
                        
                        self.move()
                    }
                }
            }
        }
        else{
            //メールアドレスもしくは、パスワードが正しくありません
            print("メールアドレスではありません")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
    func validateEmail(email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    func validate(password:String) -> Bool{
        return true
    }
    func move(){
        let nav = MainTabBarController()
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    @objc func loginWithApple(){
        print("AppleLogin")
        let nav = LoginViewController()
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

class RegisterWithEmailViewController:UIViewController,UITextFieldDelegate{
    let iconImageView:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "地球アイコン")
        image.contentMode = .scaleAspectFit
        return image
    }()
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Register With Email"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    let emailTextField :UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.keyboardType = .emailAddress
        tf.placeholder = "Email"
        return tf
    }()
    let passwordTextField :UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        return tf
    }()
    let loginButton:UIButton = {
        let button = UIButton()
        button.setTitle("Register ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.backgroundColor = .link
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.view.backgroundColor = .white
        view.addSubview(iconImageView)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: view.frame.width / 4,
                             left: view.leftAnchor,paddingLeft: view.frame.width / 2 - view.frame.width / 4,
                             width: view.frame.width / 2,
                             height: view.frame.width / 2)
        view.addSubview(titleLabel)
        titleLabel.anchor(left: view.leftAnchor, paddingLeft: 10,
                          right: view.rightAnchor, paddingRight: 10,
                          bottom: iconImageView.topAnchor,paddingBottom: 5
        )
        
        view.addSubview(emailTextField)
        emailTextField.center(inView: view)
        emailTextField.anchor(width:view.frame.width - 80, height: 40)
        
        view.addSubview(passwordTextField)
        passwordTextField.anchor(top:emailTextField.bottomAnchor , paddingTop: 40,
                                 left: view.leftAnchor, paddingLeft: 40,
                                 right: view.rightAnchor, paddingRight: 40,
                                 height: 40)
        view.addSubview(loginButton)
        loginButton.anchor(top:passwordTextField.bottomAnchor , paddingTop: 60,
                           left: view.leftAnchor, paddingLeft: 40,
                           right: view.rightAnchor, paddingRight: 40,
                           height: 40)
        loginButton.layer.cornerRadius = 20
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(loginWithEmail), for: .touchDown)
        setting()
    }
    func setting(){
        IQKeyboardManager.shared.enable = true
        emailTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        emailTextField.leftViewMode = .always
        
        passwordTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 0))
        passwordTextField.leftViewMode = .always
        
        
    }
    

    func setNav(){
      
        let backButton = UIImage(systemName: "chevron.left")
        let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
        backItem.tintColor = .darkGray
        navigationItem.leftBarButtonItem = backItem
      
      
    }
    @objc func back(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func loginWithEmail(){
        //パスワードとメールアドレスが入っているか確認
        guard !emailTextField.text!.isEmpty || !passwordTextField.text!.isEmpty else{
            print("パスワードもしくはメールがからです")
            return
        }
        
        let passwordValidate = Validator.shared.passwordCheck(with: "aaa", min: 8, max: 20)
        
        if validateEmail(email: emailTextField.text!) || passwordValidate.isValid{
            print("OK")
            AuthManager.shered.startAuthWithEmail(email: emailTextField.text!, password: passwordTextField.text!) {[self] result in
                if result {
                    FirebaseManager.shered.getProfile(userid: Auth.auth().currentUser!.uid) { profile in
                        //friend Listを取得する
                        //discriptionを取得する
                        let myprofile:Profile = Profile(userid: profile.userid,
                                                  username: profile.username,
                                                  text: profile.text ,
                                                        backgroundImage: ProfileImage(url: profile.backgroundImage.url, name: profile.backgroundImage.name),
                                                        profileImage: ProfileImage(url: profile.profileImage.url, name: profile.profileImage.name))
                        
                        DataManager.shere.setMyProfile(profile: myprofile)
                        
                        self.move()
                    }
                }
            }
        }
        else{
            //メールアドレスもしくは、パスワードが正しくありません
            print("メールアドレスではありません")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
    func validateEmail(email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    func validate(password:String) -> Bool{
        return true
    }
    func move(){
        let nav = MainTabBarController()
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    @objc func loginWithApple(){
        print("AppleLogin")
        let nav = LoginViewController()
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}




enum ValidationResult {
    case valid
    case dataIsEmpty(section: String)
    case lengthInvalid(section: String, min: Int, max: Int)
    case invalidFormat(section: String)

    
    var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .dataIsEmpty:
            return false
        case .lengthInvalid:
            return false
        case .invalidFormat:
            return false
        }
    }

    
    var errorMessage: String {
        switch self {
        case .valid:
            return ""
        case .dataIsEmpty(let section):
            return "\(section)の入力がありません"
        case .lengthInvalid(let section, let min, let max):
            return "\(section)：\(min)文字以上\(max)文字以下で入力してください"
        case .invalidFormat(let section):
            return "\(section)に使用できない文字が含まれています"
        }
    }
}



//英数字のみ
//大文字小文字の制限は設けない
//文字数は8文字以上
final class Validator {

    static let shared: Validator = .init()
    private init() {}

    
    func passwordCheck(with _password: String?, min: Int, max: Int) -> ValidationResult {
        guard let _password = _password, !_password.isEmpty else {
            //passwordがから
            return .dataIsEmpty(section: "パスワード")
        }

        
        guard _password.count >= min && _password.count <= max else {
            //paswordの文字数が満たされていない
            return .lengthInvalid(section: "パスワード", min: min, max: max)
        }

        
        let pattern = "[^a-zA-Z0-9]"
            
        if _password.range(of: pattern, options: .regularExpression) != nil {
            //例外的文字列が含まれている
            return .invalidFormat(section: "パスワード")
        }

        // ⑧
        return .valid
    }

}



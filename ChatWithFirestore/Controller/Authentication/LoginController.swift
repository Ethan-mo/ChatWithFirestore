//
//  LoginController.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/06.
//
import UIKit
import Firebase
import JGProgressHUD

protocol AuthenticationControllerProtocol {
    func checkFormStatus()
}

class LoginController: UIViewController {
    // MARK: - Properties
    
    private var viewModel = LoginViewModel()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "message")
        iv.tintColor = .white
        iv.setDimensions(width: 100, height: 100)
        return iv
    }()
    private lazy var emailContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
       return view
    }()
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
       return view
    }()
    private var emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    private var passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "PassWord")
        tf.isSecureTextEntry = true
        return tf
    }()
    private var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.setTitle("Log in", for: .normal)
        btn.setTitleColor(UIColor.systemPurple, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.anchor(paddingTop:40 ,height:50)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    private var dontAccountButton: UIButton = {
        let btn = Utilities().button("Don't have an account? ", " Sign Up")
        btn.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        configureUI()
        checkFormStatus()
     }
    
    // MARK: - API
    
    func login() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        showLoader(true, withText: "Logging in")
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                self.showLoader(false)
                customAlert(view: self, alertTitle: "알림", alertMessage: "존재하지 않는 아이디입니다.") { action in
                    // Alert을 끄는 동작
                    return
                }
                print("DEBUG: 로그인에 실패하였습니다. error\(error.localizedDescription)")
            }
            if let user = user {
                // 현재 present되고있는 LoginController를 의미
                self.showLoader(false)
                self.dismiss(animated: true)
            }            
        }
    }
    
    // MARK: - Selector
    @objc func handleLogin() {
        login()
    }
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }else{
            viewModel.pass = sender.text
        }
        checkFormStatus()
    }
    
    // MARK: - Helpers
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        view.configureGradientLayer(self.view, firstColor: UIColor.systemPurple.cgColor, secondColor: UIColor.systemPink.cgColor)
        view.addSubview(logoImageView)
        logoImageView.anchor(top:topLayoutGuide.topAnchor, paddingTop: 100)
        logoImageView.centerX(inView: self.view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,loginButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        view.addSubview(stack)
        stack.anchor(top:logoImageView.bottomAnchor,left:view.leftAnchor,right: view.rightAnchor, paddingTop: 50, paddingLeft: 32, paddingRight: 32)
        stack.centerX(inView: self.view)
        
        view.addSubview(dontAccountButton)
        dontAccountButton.anchor(bottom:view.bottomAnchor, paddingBottom: 30)
        dontAccountButton.centerX(inView: self.view)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.setTitle("로그인", for: .normal)
        }else {
            loginButton.isEnabled = false
            loginButton.setTitle("이메일과 비밀번호를 입력해주세요.", for: .normal)
        }
    }
}

//
//  RegistrationController.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/06.
//

import UIKit

final class RegistrationController: UIViewController {
    // MARK: - Properties
    private var viewModel = RegistrationViewModel()
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo"), for: .normal)
        btn.tintColor = .white
        btn.setDimensions(width: 128, height: 128)
        btn.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return btn
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
       return view
    }()
    private lazy var passwordContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
       return view
    }()
    private lazy var fullNameContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullNameTextField)
       return view
    }()
    private lazy var nickNameContainerView: UIView = {
        let view = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: nickNameTextField)
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
    private var fullNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Full Name")
        return tf
    }()
    private var nickNameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "NickName")
        return tf
    }()
    private var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(UIColor.systemPurple, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.anchor(paddingTop:40 ,height:50)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    private var alreadyHaveAccountButton: UIButton = {
        let btn = Utilities().button("Already have an account? ", " Sign Up")
        btn.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return btn
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        configureUI()
        checkFormStatus()
        configureNotificationObservers()
    }
    // MARK: - API
    // MARK: - Selector
    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleSignUp() {
        
    }
    @objc func handleShowLogin() {
        print("DEBUG: 로그인 페이지로 이동합니다.")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }else if sender == passwordTextField{
            viewModel.password = sender.text
        }else if sender == fullNameTextField{
            viewModel.fullname = sender.text
        }else {
            viewModel.nickname = sender.text
        }
        checkFormStatus()
    }
    
    // MARK: - Helpers
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        view.configureGradientLayer(self.view, firstColor: UIColor.systemPurple.cgColor, secondColor: UIColor.systemPink.cgColor)
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top:view.topAnchor, paddingTop: 80)
        plusPhotoButton.centerX(inView: self.view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,fullNameContainerView,nickNameContainerView,loginButton])
        stack.spacing = 12
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 32, paddingRight: 32)
        
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(bottom:view.bottomAnchor, paddingBottom: 30)
        alreadyHaveAccountButton.centerX(inView: self.view)
        
        imagePicker.delegate = self
        
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        nickNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
// MARK: - UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.cornerRadius = 64
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true)
    }
}
extension RegistrationController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.setTitle("회원가입", for: .normal)
        }else {
            loginButton.isEnabled = false
            loginButton.setTitle("모든 항목을 입력해주세요.", for: .normal)
        }
    }
}

//
//  LoginController.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/06.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    // MARK: - Properties
    
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
     }
    
    // MARK: - API
    
    // MARK: - Selector
    @objc func handleLogin() {
        
    }
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
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
    }
}

//
//  ProfileHeader.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/04/05.
//

import UIKit
import SDWebImage
protocol ProfileHeaderDelegate:class {
    func dismissView()
}

class ProfileHeader: UIView {
    // MARK: - Properties
    var user: User? {
        didSet {
            print("ProfileHeader: User정보가 들어왔습니다.")
            print("user:\(user)")
            populateUserData()
        }
    }
    let gradient = CAGradientLayer()
    weak var delegate: ProfileHeaderDelegate?
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.tintColor = .white
        button.imageView?.setDimensions(width: 22, height: 22)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        return iv
    }()
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = "풀네임"
        label.textAlignment = .center
        return label
    }()
    private let nicknameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.text = "닉네임"
        label.textAlignment = .center
        return label
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        populateUserData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        configureUI()
    }
    // MARK: - Selectors
    @objc func handleDismissal() {
        print("취소버튼을 눌렀습니다.")
        delegate?.dismissView()
    }
    
    // MARK: - Helper
    func configureUI() {
        configureGradientLayer()
        
        profileImageView.setDimensions(width: 180, height: 180)
        profileImageView.layer.cornerRadius = 90
        
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, nicknameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: profileImageView.bottomAnchor, paddingTop: 12)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12)
        dismissButton.setDimensions(width: 48, height: 48)
               
        
    }
    
    func populateUserData() {
        guard let user = user else { return }
        profileImageView.sd_setImage(with: user.profileImageUrl)
        fullnameLabel.text = user.fullname
        nicknameLabel.text = "@" + user.nickname 
    }

    func configureGradientLayer() {
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradient.locations = [0, 1]
        layer.addSublayer(gradient)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
}

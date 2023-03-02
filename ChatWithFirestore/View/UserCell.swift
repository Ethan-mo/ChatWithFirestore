//
//  UserCell.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/22.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    // MARK: - Properties
    var user: User? {
        didSet{
            configureUI()
            print("DEBUG: UserCell안에 데이터가 감지되었습니다.")
        }
    }
    private lazy var profileImageView: UIImageView = {
        let profileIV = UIImageView()
        profileIV.backgroundColor = .systemPurple
        profileIV.contentMode = .scaleAspectFill
        profileIV.clipsToBounds = true
        return profileIV
    }()
    private let nicknameLabel: UILabel = {
       let nicknameLB = UILabel()
        nicknameLB.font = UIFont.boldSystemFont(ofSize: 14)
        nicknameLB.text = "닉네임"
        return nicknameLB
    }()
    private let fullnameLabel: UILabel = {
       let fullnameLB = UILabel()
        fullnameLB.font = UIFont.systemFont(ofSize: 14)
        fullnameLB.text = "풀네임"
        return fullnameLB
    }()
    
    // MARK: - Lifrcycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - API
    // MARK: - Selector
    // MARK: - Helper
    func configureUI() {
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(width: 56, height: 56)
        profileImageView.layer.cornerRadius = 28
        
        let stack = UIStackView(arrangedSubviews: [nicknameLabel, fullnameLabel])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        
        addSubview(stack)
        stack.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        guard let nickname = user?.nickname else { return }
        guard let fullname = user?.fullname else { return }
        guard let profileImage = user?.profileImageUrl else { return }
        nicknameLabel.text = nickname
        fullnameLabel.text = fullname
        profileImageView.sd_setImage(with: profileImage)
    }
}

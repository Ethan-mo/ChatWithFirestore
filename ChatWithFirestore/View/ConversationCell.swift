//
//  ConversationCell.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/04/04.
//

import Foundation
import SDWebImage

class ConversationCell: UITableViewCell {
    // MARK: - Properties
    var conversation: Conversation? {
        didSet{
            configureUI()
        }
    }
    private lazy var profileImageView: UIImageView = {
        let profileIV = UIImageView()
        profileIV.backgroundColor = .systemPurple
        profileIV.contentMode = .scaleAspectFill
        profileIV.clipsToBounds = true
        return profileIV
    }()
    private var nicknameLabel: UILabel = {
       let nicknameLB = UILabel()
        nicknameLB.font = UIFont.boldSystemFont(ofSize: 16)
        nicknameLB.text = "닉네임"
        return nicknameLB
    }()
    private var messageLabel: UILabel = {
       let message = UILabel()
        message.font = UIFont.systemFont(ofSize: 18)
        message.text = "전달해온 메세지 내용은"
        return message
    }()
    private var timeStamp: UILabel = {
       let timeStamp = UILabel()
        timeStamp.font = UIFont.systemFont(ofSize: 14)
        timeStamp.text = "시간"
        return timeStamp
    }()
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        configureUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func configureUI() {
        guard let conversation = conversation else { return }
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(width: 56, height: 56)
        profileImageView.layer.cornerRadius = 28
        
        let stack = UIStackView(arrangedSubviews: [nicknameLabel, messageLabel])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        
        addSubview(stack)
        stack.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        let nickname = conversation.user.nickname
        let message = conversation.message.text
        let profileImage = conversation.user.profileImageUrl
        nicknameLabel.text = nickname
        messageLabel.text = message
        profileImageView.sd_setImage(with: profileImage)
        
    }
}


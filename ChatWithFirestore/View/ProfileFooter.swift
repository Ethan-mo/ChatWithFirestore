//
//  ProfileFooter.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/04/06.
//

import UIKit

protocol ProfileFooterDelegate: class {
    func logoutButtonTapped()
}
class ProfileFooter: UIView {
    // MARK: - Properties
    weak var delegate: ProfileFooterDelegate?
    private var Logoutbutton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Logout", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = .systemPink
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(handleLogoutBtn), for: .touchUpInside)
        return btn
    }()
    // MARK: - Lifeycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(Logoutbutton)
        Logoutbutton.anchor(left:leftAnchor, right: rightAnchor, paddingLeft: 32, paddingRight: 32)
        Logoutbutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        Logoutbutton.centerY(inView: self)
    }
    // MARK: - Selector
    @objc func handleLogoutBtn() {
        print("ProfileFooter에서 Logout버튼이 눌렸습니다.")
        delegate?.logoutButtonTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helper
}

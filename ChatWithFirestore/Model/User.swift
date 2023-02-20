//
//  User.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/14.
//

import Foundation

struct User {
    let uid: String
    let email: String
    let fullname: String
    let nickname: String
    let profileImageUrl: String?
    init(dictionary: [String : Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.nickname = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}

//
//  User.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/14.
//

import Foundation

class User {
    let fullname: String
    let nickname: String
    let profileImageUrl: URL?
    init(fullname: String, nickname: String, profileImageUrl: URL?) {
        self.fullname = fullname
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
    }
}

//
//  UserService.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/14.
//

import Foundation
import Firebase

struct UserService {
    static func fetchUsers(completion:@escaping([User])-> Void) {
        var userList = [User]()
        FS_USER.getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                
                userList.append(user)
            })
            completion(userList)
        }
    }
}

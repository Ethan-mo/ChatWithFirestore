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
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        FS_USER.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
}

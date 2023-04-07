//
//  UserService.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/14.
//

import Foundation
import Firebase

struct UserService {
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        FS_USER.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    static func fetchUsers(completion:@escaping([User])-> Void) {
        FS_USER.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.map({ User(dictionary: $0.data()) }) else { return }
            completion(users)
        }
    }

}

//
//  Service.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/03/02.
//
import Foundation
import Firebase
struct Service {
    static func fetchMessage(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let query = FS_MESSAGE.document(currentUid).collection(user.uid).order(by: "timestamp")
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = FS_MESSAGE.document(uid).collection("recent-messages").order(by: "timestamp")
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                if message.toID == uid {
                    UserService.fetchUser(withUid: message.fromID) { user in
                        let conversation = Conversation(user: user, message: message)
                        conversations.append(conversation)
                        completion(conversations)
                    }
                }else {
                    UserService.fetchUser(withUid: message.toID) { user in
                        let conversation = Conversation(user: user, message: message)
                        conversations.append(conversation)
                        completion(conversations)
                    }
                }
            })
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let data = ["text": message, "fromId": currentUid, "toId": user.uid, "timestamp": Timestamp(date: Date())] as [String : Any]
        FS_MESSAGE.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            if user.uid == currentUid {
                return
            }
            FS_MESSAGE.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            // 아래 코드가 정말 놀라운 점은, 지정된 경로의 데이터가 1개만 들어가게끔 설정 함으로써, 부가적인 다른 설정없이, 가장 최신 메세지가 저장된다는 것이다.
            // 고민해볼 점은, 이러한 recent-messages들 중에서 Timestamp를 불러오는 과정을 어떻게 해결하느냐가 중요하다.
            FS_MESSAGE.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
            FS_MESSAGE.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
        }
    }
}

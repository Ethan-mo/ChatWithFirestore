//
//  ChatController.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/22.
//

import UIKit

private let reuseIdentifier = "MessageCell"


class ChatController: UICollectionViewController {
    // MARK: - Properties
    private let user: User
    private var messages = [Message]()
    private var fromCurrentUser = false
    var delegate: ChatControllerDelegate?
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()

    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: ChatController가 실행되었습니다.")
        configureUI()
    }
    // 키보드와 함께 사용자 입력작업을 수행하는 뷰 컨트롤러에서 사용하는 것이다.
    // customInputView를 사용할 때, 사용하고자 한다.
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Selector
    // MARK: - API
    // MARK: - Helper
    
    func configureUI() {
        //collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.nickname, prefersLargeTitles: false)
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
    }

}

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.profileImageView.sd_setImage(with: user.profileImageUrl)
        return cell
    }
}

extension ChatController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}
// MARK: - CustomInputAccessoryViewDelegate
extension ChatController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        print("DEBUG: Message가 전송되었습니다. \(message)")
        fromCurrentUser.toggle()
        let tempMessage = Message(text: message, isFromCurrentUser: fromCurrentUser)
        messages.append(tempMessage)
        collectionView.reloadData()
    }
}

//
//  ConversationController.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/06.
//

import UIKit
import Firebase

private let reuserIdentifier: String = "ConversationCell"

final class ConversationController: UIViewController {
    // MARK: - Properties
    var user: User?
    private var tableView = UITableView()
    private var conversations = [Conversation]() {
        didSet{
            tableView.reloadData()
            configureUI()
        }
    }
    
    private lazy var addChat: UIButton = {
        let btn = UIButton(type: .system)
        btn.setDimensions(width: 60, height: 60)
        btn.layer.cornerRadius = 30
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .systemPurple
        btn.addTarget(self, action: #selector(addChatting), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        //logout()
        fetchConversation()
        configureUI()
        authenticateUser()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
        tableView.reloadData()
    }
    
    // MARK: - Selector
    @objc func showProfile() {
        print("DEBUG: 본인의 프로필 이미지를 눌렀습니다.")
        let controller = ProfileController(style: .insetGrouped)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
        
    }
    @objc func addChatting() {
        print("DEBUG: 채팅하자")
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    // MARK: - API
    
    func fetchConversation() {
        Service.fetchConversations { conversations in
            print("Conversation 데이터를 가져오는 것이 실행되었습니다.")
            self.conversations = conversations
            print("가져온 conversation정보는: \(conversations)")
        }
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG: 로그인 페이지로 변경됩니다.")
            presentLoginScreen()
        }else {
            print("DEBUG: 첫 페이지입니다.")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        }catch {
            print("DEBUG: 로그아웃에 실패하였습니다.")
        }
        print("DEBUG: 로그아웃에 성공")
        if Auth.auth().currentUser == nil {
            presentLoginScreen()
        }
    }
    
    // MARK: - Helpers
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        configureTableView()
        configureNavigation()
        view.addSubview(addChat)
        addChat.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
        
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuserIdentifier)
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func configureNavigation() {
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true) 
        
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
    }
    
    func showChatController(forUser user: User) {
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
extension ConversationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
    
}
extension ConversationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)
    }
    
}

extension ConversationController: NewMessageControllerDelegate {
    func moveToChatController(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        dismiss(animated: true)
        showChatController(forUser: user)
    }
}

extension ConversationController: ProfileControllerDelegate {
    func handleLogout() {
        logout()
    }
}

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
    private let tableView = UITableView()
    
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
        configureUI()
        authenticateUser()
    }
    
    // MARK: - Selector
    @objc func showProfile() {
        print("DEBUG: 눌렀습니다.")
        logout()
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuserIdentifier)
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
extension ConversationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifier, for: indexPath)
         cell.textLabel?.text = "Test"
        return cell
    }
    
}
extension ConversationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: 일단 눌러는 진다. ㅋ ")
    }
    
}

extension ConversationController: NewMessageControllerDelegate {
    func moveToChatController(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        controller.dismiss(animated: true)
        let chat = ChatController(user: user)
        navigationController?.pushViewController(chat, animated: true)
    }
}

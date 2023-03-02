//
//  NewMessageController.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/21.
//

import UIKit

protocol NewMessageControllerDelegate: class {
    func moveToChatController(_ controller: NewMessageController , wantsToStartChatWith user:User)
}

private let reuseIdentifier = "UserCell"

class NewMessageController: UITableViewController {
    // MARK: - Properties
    
    weak var delegate: NewMessageControllerDelegate?
    
    var userList = [User]() {
        didSet{
            tableView.reloadData()
            print("DEBUG: 테이블 리로딩")
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
    }
    
    // MARK: - Selector
    @objc func handleDismissal() {
        self.dismiss(animated: true)
    }
    // MARK: - API
    func fetchUsers() {
        UserService.fetchUsers { userList in
            self.userList = userList
            print("DEBUG: 출력완료")
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        configureNavigationBar(withTitle: "NewMessage", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        
    }
}
// MARK: - UITableViewDataSource
extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = userList[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userList[indexPath.row]
        delegate?.moveToChatController(self, wantsToStartChatWith: user)
    }
}

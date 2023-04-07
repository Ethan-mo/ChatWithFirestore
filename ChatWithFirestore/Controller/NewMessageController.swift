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
    private var filteredUsers = [User]()
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
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
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false // 기본적으로 설정하지 않아도 false로 설정된다.
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "대화를 진행할 사용자를 입력해주세요."
        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .systemPurple
            textField.backgroundColor = .white
        }
    }
}
// MARK: - UITableViewDataSource
extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : userList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : userList[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : userList[indexPath.row]
        delegate?.moveToChatController(self, wantsToStartChatWith: user)
    }
}

extension NewMessageController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = userList.filter({ user -> Bool in
            return user.nickname.contains(searchText) || user.fullname.contains(searchText)
        })
        print("DEBUG: Filtered users \(filteredUsers)")
        tableView.reloadData()
        
    }
}

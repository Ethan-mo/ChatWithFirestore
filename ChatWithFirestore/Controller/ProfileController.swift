//
//  ProfileController.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/04/05.
//

import UIKit
import Firebase

private let reuseIdentifier = "ProfileCell"

class ProfileController: UITableViewController {
    // MARK: - Properties
    var user: User? {
        didSet {
            print("ProfileController: User정보가 변경되었습니다.")
            headerView.user = user
        }
    }
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height: 360))
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        fetchUser()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    // MARK: - Selectors
    // MARK: - API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    // MARK: - Helper
    func configureUI() {
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never // 맨 위까지 뷰가 올라오도록...
        tableView.rowHeight = 64
        tableView.backgroundColor = .systemGroupedBackground
    }
}
extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator // 오른쪽에 버튼이 자동으로 생겼다.
        
        return cell
    }
}
extension ProfileController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { // 섹션을 만들어서, 하나의 섹션으로 cell을 구분시켰다.
        return UIView()
    }
}

extension ProfileController: ProfileHeaderDelegate {
    func dismissView() {
        self.dismiss(animated: true)
    }
}

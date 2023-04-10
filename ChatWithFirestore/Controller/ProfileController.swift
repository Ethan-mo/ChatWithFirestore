//
//  ProfileController.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/04/05.
//

import UIKit
import Firebase

private let reuseIdentifier = "ProfileCell"
protocol ProfileControllerDelegate: class {
    func handleLogout()
}
class ProfileController: UITableViewController {
    // MARK: - Properties
    var user: User? {
        didSet {
            print("ProfileController: User정보가 변경되었습니다.")
            headerView.user = user
        }
    }
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height: 360))
    private let footerView = ProfileFooter()
    weak var delegate: ProfileControllerDelegate?
    
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
        showLoader(true)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
            self.showLoader(false)
        }
        
    }
    // MARK: - Helper
    func configureUI() {
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
        footerView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never // 맨 위까지 뷰가 올라오도록...
        tableView.rowHeight = 64
        tableView.backgroundColor = .systemGroupedBackground
    }
}
// MARK: - UITableViewDataSource
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

// MARK: - UITableViewDelegate
extension ProfileController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else { return }
        print("현재 선택된 버튼은 :\(viewModel.description)")
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { // 섹션을 만들어서, 하나의 섹션으로 cell을 구분시켰다.
        return UIView()
    }
}

// MARK: - ProfileHeaderDelegate
extension ProfileController: ProfileHeaderDelegate {
    func dismissView() {
        self.dismiss(animated: true)
    }
}
// MARK: - ProfileFooterDelegate
extension ProfileController: ProfileFooterDelegate {
    func logoutButtonTapped() {
        let alert = UIAlertController(title: nil, message: "로그아웃을 하시겠습니까?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel))
        present(alert, animated: true)
                        
    }
}

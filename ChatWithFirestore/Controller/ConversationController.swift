//
//  ConversationController.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/06.
//

import UIKit

private let reuserIdentifier: String = "ConversationCell"

final class ConversationController: UIViewController {
    // MARK: - Properties
    private let tableView = UITableView()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        configureUI()
    }
    // MARK: - API
    
    // MARK: - Selector
    @objc func showProfile() {
        print("DEBUG: 눌렀습니다.")
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        configureTableView()
        configureNavigation()
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
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemPurple
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
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

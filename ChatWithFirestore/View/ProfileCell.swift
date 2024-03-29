//
//  ProfileCell.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/04/06.
//

import UIKit

class ProfileCell: UITableViewCell {
    // MARK: - Properties
    
    var viewModel: ProfileViewModel? {
        didSet {configure()}
    }
    private lazy var iconView: UIView = {
       let view = UIView()
        view.addSubview(iconImage)
        iconImage.centerY(inView: view)
        iconImage.centerX(inView: view)
        view.backgroundColor = .systemPurple
        view.setDimensions(width: 40, height: 40)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 28, height: 28)
        iv.tintColor = .white
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stack.spacing = 8
        stack.axis = .horizontal
        
        contentView.addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    func configure() {
        guard let viewModel = viewModel else { return }
        iconImage.image = UIImage(systemName: viewModel.iconImageName)
        titleLabel.text = viewModel.description
        
    }
}

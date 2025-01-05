//
//  RecentBookCell.swift
//  BookFindApp
//
//  Created by t2023-m0072 on 12/30/24.
//



import UIKit

class RecentBookCell: UITableViewCell {
    private let titleLabel = UILabel()

    func configure(with book: Book) {
        titleLabel.text = book.title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .darkGray
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}

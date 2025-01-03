//
//  BookCell.swift
//  BookFindApp
//
//  Created by t2023-m0072 on 1/3/25.
//
import UIKit
import SnapKit

class BookCell: UITableViewCell {
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8

        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)

        contentView.addSubview(priceLabel)
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = .gray

        thumbnailImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.width.height.equalTo(60)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.top)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }

        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }

    func configure(with book: Book) {
        titleLabel.text = book.title
        priceLabel.text = "\(book.price)원"

        if let url = URL(string: book.thumbnailURL) {
            loadImage(from: url)
        } else {
            thumbnailImageView.image = nil
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.thumbnailImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}

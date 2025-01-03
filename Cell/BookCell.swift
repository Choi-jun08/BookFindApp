//
//  BookCell.swift
//  BookSearchApp
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit
import SnapKit

class BookCell: UITableViewCell {
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
//    private let addButton = UIButton()

    // 버튼이 눌렸을 때 동작을 전달하기 위한 클로저
    var onAddButtonTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 레이아웃 설정
    private func setupLayout() {
        // 서브뷰 추가
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
//        contentView.addSubview(addButton)

        // 이미지 뷰 레이아웃 설정
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10) // 왼쪽 여백
            make.top.equalToSuperview().offset(10) // 상단 여백
            make.width.height.equalTo(60) // 크기
        }

        // 제목 레이블 레이아웃 설정
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.top) // 이미지 상단과 맞춤
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(10) // 이미지 오른쪽 여백
            make.trailing.equalToSuperview().offset(-10) // 버튼과의 간격 추가
        }
        titleLabel.numberOfLines = 0 // 제한 없이 여러 줄 표시 가능
        titleLabel.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈

        // 가격 레이블 레이아웃 설정
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5) // 제목 아래에 위치
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(10) // 이미지 오른쪽
            make.trailing.equalToSuperview().offset(-10) // 버튼과의 간격 추가
            make.bottom.equalToSuperview().offset(-10) // 아래 여백
        }

        // 버튼 레이아웃 설정
//        addButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().offset(-10) // 오른쪽 여백
//            make.centerY.equalToSuperview() // 수직 가운데 정렬
//            make.width.height.equalTo(40) // 크기 조정
//        }

        // 버튼 스타일 설정
//        addButton.setTitle("담기", for: .normal)
//        addButton.backgroundColor = .systemBlue
//        addButton.layer.cornerRadius = 20 // 버튼을 동그랗게
//        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }

    // 셀 데이터 설정
    func configure(with book: Book) {
        titleLabel.text = book.title
        priceLabel.text = "\(book.price)원"

        // 이미지 URL 로드
        if let url = URL(string: book.thumbnailURL) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }

    // Add 버튼 동작
    @objc private func didTapAddButton() {
        onAddButtonTapped?()
    }
}

//
//  BookSearchViewController.swift
//  BookFindApp
//
//  Created by t2023-m0072 on 1/3/25.
//

import UIKit
import SnapKit

class BookSearchViewController: UIViewController {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        return searchBar
    }()

    private let recentBooksLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 본 책"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "책 검색"

        setupLayout()
    }

    private func setupLayout() {
        // SearchBar와 Label 추가
        view.addSubview(searchBar)
        view.addSubview(recentBooksLabel)

        // SnapKit으로 레이아웃 설정
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        recentBooksLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
        }
    }
}

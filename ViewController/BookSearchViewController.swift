//
//  BookSearchViewController.swift
//  BookFindApp
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit
import SnapKit

class BookSearchViewController: UIViewController {
    private let viewModel = BookSearchViewModel()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        return searchBar
    }()

    private let resultsLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.isHidden = true // 초기에는 숨김
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BookCell.self, forCellReuseIdentifier: "BookCell") // 커스텀 셀 등록
        tableView.separatorStyle = .none // 셀 간 구분선 제거
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "책 검색"

        setupLayout()
        setupTableView()
        setupSearchBar()
        bindViewModel()
    }

    private func setupLayout() {
        // UI 요소 추가
        view.addSubview(searchBar)
        view.addSubview(resultsLabel)
        view.addSubview(tableView)

        // SnapKit으로 레이아웃 설정
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        resultsLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(resultsLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupSearchBar() {
        searchBar.delegate = self
    }

    private func bindViewModel() {
        viewModel.onBooksUpdated = { [weak self] in
            guard let self = self else { return }
            self.resultsLabel.isHidden = self.viewModel.books.isEmpty // 결과 없으면 숨김
            self.tableView.reloadData()
        }
    }
}

// MARK: - UISearchBarDelegate
extension BookSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBooks(keyword: searchText)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension BookSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell else {
            return UITableViewCell()
        }
        let book = viewModel.books[indexPath.row]
        cell.configure(with: book)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = viewModel.books[indexPath.row]
        print("Selected book: \(book.title)")
    }
}

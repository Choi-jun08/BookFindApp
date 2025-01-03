//
//  BookSearchViewController.swift
//  BookFindApp
//  Created by t2023-m0072 on 12/30/24.
//

// BookSearchViewController.swift

import UIKit
import SnapKit

class BookSearchViewController: UIViewController {
    private let viewModel = BookSearchViewModel()
    private let recentBooksViewModel = RecentBooksViewModel()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        return searchBar
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BookCell.self, forCellReuseIdentifier: "BookCell")
        tableView.register(RecentBookCell.self, forCellReuseIdentifier: "RecentBookCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "책 검색"

        setupLayout()
        setupTableView()
        setupSearchBar()
        bindViewModels()
    }

    private func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(tableView)

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100 // 검색 결과 기본 높이
    }

    private func setupSearchBar() {
        searchBar.delegate = self
    }

    private func bindViewModels() {
        viewModel.onBooksUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        recentBooksViewModel.onRecentBooksUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBooks(keyword: searchText)
    }
}

extension BookSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return recentBooksViewModel.recentBooks.isEmpty ? 1 : 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && !recentBooksViewModel.recentBooks.isEmpty {
            return recentBooksViewModel.recentBooks.count
        }
        return viewModel.books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && !recentBooksViewModel.recentBooks.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentBookCell", for: indexPath) as! RecentBookCell
            let recentBook = recentBooksViewModel.recentBooks[indexPath.row]
            cell.configure(with: recentBook)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
            let book = viewModel.books[indexPath.row]
            cell.configure(with: book)
            cell.onAddButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.recentBooksViewModel.addRecentBook(book) // 최근 본 책에 추가
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book: Book
        if indexPath.section == 0 && !recentBooksViewModel.recentBooks.isEmpty {
            book = recentBooksViewModel.recentBooks[indexPath.row]
        } else {
            book = viewModel.books[indexPath.row]
            recentBooksViewModel.addRecentBook(book)
        }
        let detailVC = BookDetailViewController(book: book)
        detailVC.modalPresentationStyle = .overFullScreen
        present(detailVC, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && !recentBooksViewModel.recentBooks.isEmpty {
            return 50 // 최근 본 책 섹션의 행 높이
        }
        return 100 // 검색 결과 섹션의 행 높이
    }
}

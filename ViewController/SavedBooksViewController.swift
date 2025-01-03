//
//  SavedBooksViewController.swift
//  BookFindApp
//
//  Created by t2023-m0072 on 1/3/25.
//

import UIKit
import SnapKit

class SavedBooksViewController: UIViewController {
    private let viewModel = SavedBooksViewModel() // ViewModel 연결

    private let savedBooksLabel: UILabel = {
        let label = UILabel()
        label.text = "담은 책"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "담은 책"

        setupLayout()
        setupTableView()
        bindViewModel()
    }

    private func setupLayout() {
        // Label과 TableView 추가
        view.addSubview(savedBooksLabel)
        view.addSubview(tableView)

        // SnapKit으로 레이아웃 설정
        savedBooksLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(10)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(savedBooksLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func bindViewModel() {
        // ViewModel에서 데이터가 업데이트되면 테이블뷰를 리로드
        viewModel.onSavedBooksUpdated = { [weak self] in
            self?.tableView.reloadData()
        }

        // 예시 데이터를 추가 
        viewModel.addBook(Book(title: "세이노의 가르침", author: "세이노", price: 14000, thumbnailURL: "", description: "삶의 지혜를 나누는 책"))
    }
}

extension SavedBooksViewController: UITableViewDataSource, UITableViewDelegate {
    // 섹션당 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.savedBooks.count
    }

    // 각 셀의 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        let book = viewModel.savedBooks[indexPath.row]
        cell.textLabel?.text = "\(book.title) -\(book.price)원"
        return cell
    }

    // 셀 선택 시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = viewModel.savedBooks[indexPath.row]
        print("Selected book: \(book.title)")
    }
}

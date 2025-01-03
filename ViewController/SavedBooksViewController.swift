import UIKit
import SnapKit

class SavedBooksViewController: UIViewController {
    private let tableView = UITableView()
    let viewModel = SavedBooksViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "담은 책"

        setupNavigationBar()
        setupTableView()
        bindViewModel()
        viewModel.fetchSavedBooks()
    }

    private func setupNavigationBar() {
        let deleteAllButton = UIBarButtonItem(title: "전체 삭제", style: .plain, target: self, action: #selector(didTapDeleteAllButton))
        navigationItem.leftBarButtonItem = deleteAllButton

        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(didTapAddButton))
        navigationItem.rightBarButtonItem = addButton
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SavedBookCell")
    }

    private func bindViewModel() {
        viewModel.onSavedBooksUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func reloadSavedBooks() {
        viewModel.fetchSavedBooks()
    }

    @objc private func didTapDeleteAllButton() {
        let alert = UIAlertController(title: "전체 삭제", message: "모든 책을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteAllBooks()
        }))
        present(alert, animated: true)
    }

    @objc private func didTapAddButton() {
        guard let tabBarController = self.tabBarController else { return }
        tabBarController.selectedIndex = 0
    }
}

extension SavedBooksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.savedBooks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedBookCell", for: indexPath)
        let book = viewModel.savedBooks[indexPath.row]
        cell.textLabel?.text = "\(book.title ?? "") - \(book.price)원"
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteBook(at: indexPath.row)
        }
    }
}


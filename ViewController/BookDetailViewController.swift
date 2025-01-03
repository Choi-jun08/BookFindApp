//
//  BookDetailViewController.swift
//  BookFindApp
//
//  Created by t2023-m0072 on 1/3/25.
//

import UIKit
import SnapKit
import CoreData

class BookDetailViewController: UIViewController {
    private let book: Book

    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    private let saveButton = UIButton()
    private let closeButton = UIButton()

    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        configure(with: book)
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(priceLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(thumbnailImageView)
        view.addSubview(saveButton)
        view.addSubview(closeButton)

        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view.snp.centerX).offset(-10)
            make.height.equalTo(50)
        }

        closeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.leading.equalTo(view.snp.centerX).offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }

        saveButton.setTitle("담기", for: .normal)
        saveButton.backgroundColor = .systemGreen
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)

        closeButton.setTitle("X", for: .normal)
        closeButton.backgroundColor = .systemGray
        closeButton.layer.cornerRadius = 10
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }

    private func configure(with book: Book) {
        titleLabel.text = book.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center

        authorLabel.text = "저자: \(book.author)"
        authorLabel.font = UIFont.systemFont(ofSize: 16)
        authorLabel.textAlignment = .center

        priceLabel.text = "\(book.price)원"
        priceLabel.font = UIFont.systemFont(ofSize: 16)
        priceLabel.textAlignment = .center

        descriptionLabel.text = book.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center

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

    @objc private func didTapSaveButton() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Unable to access AppDelegate")
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        let savedBook = SavedBook(context: context)
        savedBook.title = book.title
        savedBook.author = book.author
        savedBook.price = Int32(book.price)
        savedBook.thumbnailURL = book.thumbnailURL
        savedBook.descriptionText = book.description

        do {
            try context.save()
            print("Book saved successfully: \(book.title)")

            if let tabBarController = self.presentingViewController as? UITabBarController,
               let savedBooksVC = (tabBarController.viewControllers?[1] as? UINavigationController)?.topViewController as? SavedBooksViewController {
                savedBooksVC.reloadSavedBooks() // ViewModel을 통해 데이터 새로고침
            }

            dismiss(animated: true, completion: nil)
        } catch {
            print("Failed to save book: \(error.localizedDescription)")
        }
    }

    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

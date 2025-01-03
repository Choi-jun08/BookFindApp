//
//  RecentBooksViewModel.swift
//  BookFindApp
//
//  Created by t2023-m0072 on 1/3/25.
//

import Foundation

class RecentBooksViewModel {
    private(set) var recentBooks: [Book] = [] {
        didSet {
            onRecentBooksUpdated?()
        }
    }

    var onRecentBooksUpdated: (() -> Void)?

    func addRecentBook(_ book: Book) {
        if let index = recentBooks.firstIndex(where: { $0.title == book.title }) {
            recentBooks.remove(at: index) // 중복 제거
        }
        recentBooks.insert(book, at: 0) // 최신 순으로 추가
        if recentBooks.count > 10 {
            recentBooks.removeLast() // 최대 10권 유지
        }
    }
}

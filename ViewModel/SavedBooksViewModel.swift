//
//  SavedBooksViewModel.swift
//  BookFindApp
//
//  Created by t2023-m0072 on 1/3/25.
//

import Foundation

class SavedBooksViewModel {
    private(set) var savedBooks: [Book] = []

    // 데이터가 업데이트되었음을 알리는 클로저
    var onSavedBooksUpdated: (() -> Void)?

    // 책 추가
    func addBook(_ book: Book) {
        savedBooks.append(book)
        onSavedBooksUpdated?() // 데이터가 변경되었음을 알림
    }

    // 책 삭제
    func removeBook(at index: Int) {
        guard index < savedBooks.count else { return }
        savedBooks.remove(at: index)
        onSavedBooksUpdated?() // 데이터가 변경되었음을 알림
    }
}

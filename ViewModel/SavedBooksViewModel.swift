
//
//  SavedBooksViewModel.swift
//  BookSearchApp
//
//  Created by t2023-m0072 on 12/30/24.
//

import Foundation
import CoreData
import UIKit

class SavedBooksViewModel {
    private(set) var savedBooks: [SavedBook] = [] // 담은 책 리스트

    // 데이터 업데이트 알림 클로저
    var onSavedBooksUpdated: (() -> Void)?

    // Core Data Context 접근
    private let context: NSManagedObjectContext

    // 초기화
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
        fetchSavedBooks()
    }

    // 책 추가 메서드
    func addBook(_ book: Book) {
        let savedBook = SavedBook(context: context)
        savedBook.title = book.title
        savedBook.author = book.author
        savedBook.price = Int32(book.price)
        savedBook.thumbnailURL = book.thumbnailURL
        savedBook.descriptionText = book.description

        do {
            try context.save()
            savedBooks.append(savedBook)
            onSavedBooksUpdated?() // 데이터 변경 알림
        } catch {
            print("Failed to add book: \(error.localizedDescription)")
        }
    }

    // 책 삭제 메서드
    func deleteBook(at index: Int) {
        guard index < savedBooks.count else { return }
        let bookToDelete = savedBooks[index]
        context.delete(bookToDelete)

        do {
            try context.save()
            savedBooks.remove(at: index)
            onSavedBooksUpdated?()
        } catch {
            print("Failed to delete book: \(error.localizedDescription)")
        }
    }

    // 모든 책 삭제 메서드
    func deleteAllBooks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SavedBook.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
            savedBooks.removeAll()
            onSavedBooksUpdated?()
        } catch {
            print("Failed to delete all books: \(error.localizedDescription)")
        }
    }

    // Core Data에서 책 가져오기
    func fetchSavedBooks() {
        let fetchRequest: NSFetchRequest<SavedBook> = SavedBook.fetchRequest()

        do {
            savedBooks = try context.fetch(fetchRequest)
            onSavedBooksUpdated?()
        } catch {
            print("Failed to fetch saved books: \(error.localizedDescription)")
        }
    }
}

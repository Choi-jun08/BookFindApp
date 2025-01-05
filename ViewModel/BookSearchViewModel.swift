//
//  BookSearchViewModel.swift
//  BookFindApp
//
//  Created by t2023-m0072 on 12/30/24.
//
import Foundation

class BookSearchViewModel {
    private let apiKey = "6b50e46215505df5bbfe6ab7f9e5a9d5"
    private let apiURL = "https://dapi.kakao.com/v3/search/book"
    
    private(set) var books: [Book] = []

    var onBooksUpdated: (() -> Void)?

    // 책 검색
    func searchBooks(keyword: String) {
        guard !keyword.isEmpty else {
            books = []
            onBooksUpdated?()
            return
        }

        // API URL 생성
        let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "\(apiURL)?query=\(query)") else { return }

        // URLRequest 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")

        // API 호출
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                // JSON 디코딩
                let decodedResponse = try JSONDecoder().decode(KakaoBookResponse.self, from: data)
                self.books = decodedResponse.documents.map { document in
                    Book(
                        title: document.title,
                        author: document.authors.joined(separator: ", "),
                        price: document.price,
                        thumbnailURL: document.thumbnail,
                        description: document.contents
                    )
                }
                DispatchQueue.main.async {
                    self.onBooksUpdated?()
                }
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}

// Kakao API 응답 구조
struct KakaoBookResponse: Codable {
    let documents: [KakaoBookDocument]
}

struct KakaoBookDocument: Codable {
    let title: String
    let authors: [String]
    let price: Int
    let thumbnail: String
    let contents: String
}

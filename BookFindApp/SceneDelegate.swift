//
//  SceneDelegate.swift
//  BookFindApp
//
//  Created by t2023-m0072 on 1/3/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // UIWindow 생성
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white

        // TabBarController 설정
        let tabBarController = UITabBarController()

        // 탭에 ViewController 추가
        let bookSearchVC = UINavigationController(rootViewController: BookSearchViewController())
        bookSearchVC.tabBarItem = UITabBarItem(title: "책 검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        let savedBooksVC = UINavigationController(rootViewController: SavedBooksViewController())
        savedBooksVC.tabBarItem = UITabBarItem(title: "담은 책", image: UIImage(systemName: "books.vertical"), tag: 1)

        tabBarController.viewControllers = [bookSearchVC, savedBooksVC]

        // UIWindow의 rootViewController 설정
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

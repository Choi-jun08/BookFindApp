//  AppDelegate.swift
//  BookSearchApp
//
//  Created by t2023-m0072 on 12/30/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // UIWindow 생성
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white

        // TabBarController 설정
        let tabBarController = UITabBarController()

        // 탭에 ViewController 추가
        let bookSearchVC = UINavigationController(rootViewController: BookSearchViewController())
        bookSearchVC.tabBarItem = UITabBarItem(title: "책 검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        let savedBooksVC = UINavigationController(rootViewController: SavedBooksViewController())
        savedBooksVC.tabBarItem = UITabBarItem(title: "담은 책", image: UIImage(systemName: "books.vertical"), tag: 1)

        tabBarController.viewControllers = [bookSearchVC, savedBooksVC]

        // UIWindow에 rootViewController 설정
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }
}

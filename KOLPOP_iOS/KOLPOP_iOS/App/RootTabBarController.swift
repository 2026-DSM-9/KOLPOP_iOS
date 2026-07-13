//
//  RootTabBarController.swift
//  KOLPOP_iOS
//

import UIKit

final class RootTabBarController: UITabBarController {

    enum Tab: Int {
        case home
        case map
        case ai
        case chat
        case mypage
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        let home = makeNav(
            root: HomeViewController(),
            title: "홈",
            iconName: "home"
        )
        let map = makeNav(
            root: SearchViewController(),
            title: "지도",
            iconName: "location"
        )
        let ai = makeNav(
            root: AIViewController(),
            title: "AI 파트너",
            iconName: "AI"
        )
        let chat = makeNav(
            root: ChatViewController(),
            title: "채팅",
            iconName: "chat"
        )
        let mypage = makeNav(
            root: MypageViewController(),
            title: "마이",
            iconName: "person"
        )

        viewControllers = [home, map, ai, chat, mypage]
    }

    private func makeNav(root: UIViewController, title: String, iconName: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: root)
        let image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        nav.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
        return nav
    }

    private func setupAppearance() {
        tabBar.tintColor = UIColor(named: "00AEEF")
        tabBar.unselectedItemTintColor = UIColor(named: "A3A4A5")

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

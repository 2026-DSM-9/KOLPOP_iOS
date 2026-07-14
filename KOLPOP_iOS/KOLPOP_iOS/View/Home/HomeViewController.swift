//
//  HomeViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class HomeViewController: UIViewController {

    private enum Section: Int, CaseIterable {
        case banner
        case quickMenu
        case popular
    }

    private let popularListings = [ // 예시값
        PopularListing(imageURL: nil, title: "대덕소프트웨어마이스터고", address: "대전광역시 가정북로 72", sizeInfo: "200평 / 1층", price: "주 80만원", likeCount: 486),
        PopularListing(imageURL: nil, title: "대덕소프트웨어마이스터고", address: "대전광역시 가정북로 72", sizeInfo: "200평 / 1층", price: "주 80만원", likeCount: 486),
        PopularListing(imageURL: nil, title: "대덕소프트웨어마이스터고", address: "대전광역시 가정북로 72", sizeInfo: "200평 / 1층", price: "주 80만원", likeCount: 486)
    ]

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).then {
        $0.backgroundColor = UIColor(named: "FFFFFF")
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(FestivalBannerCell.self, forCellWithReuseIdentifier: FestivalBannerCell.reuseIdentifier)
        $0.register(QuickMenuCell.self, forCellWithReuseIdentifier: QuickMenuCell.reuseIdentifier)
        $0.register(PopularListingCell.self, forCellWithReuseIdentifier: PopularListingCell.reuseIdentifier)
        $0.register(
            HomeSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        let titleLabel = UILabel().then {
            $0.text = "콜팝"
            $0.font = .paperlogy(.semiBold, size: 24)
            $0.textColor = UIColor(named: "0F1010")
        }
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .banner:
                return self?.makeBannerSection()
            case .quickMenu:
                return self?.makeQuickMenuSection()
            case .popular:
                return self?.makePopularSection()
            }
        }
    }

    private func makeBannerSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(210)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 24, trailing: 20)
        return section
    }

    private func makeQuickMenuSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(12)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 32, trailing: 20)
        return section
    }

    private func makePopularSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(224), heightDimension: .absolute(300)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 32, trailing: 20)
        section.boundarySupplementaryItems = [makeHeader(height: 36)]
        return section
    }

    private func makeHeader(height: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

extension HomeViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .banner: return 1
        case .quickMenu: return 2
        case .popular: return popularListings.count
        case .none: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FestivalBannerCell.reuseIdentifier, for: indexPath) as! FestivalBannerCell
            return cell

        case .quickMenu:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickMenuCell.reuseIdentifier, for: indexPath) as! QuickMenuCell
            cell.configure(style: indexPath.item == 0 ? .calendar : .aiPartner)
            return cell

        case .popular:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularListingCell.reuseIdentifier, for: indexPath) as! PopularListingCell
            cell.configure(with: popularListings[indexPath.item])
            return cell

        case .none:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as! HomeSectionHeaderView

        switch Section(rawValue: indexPath.section) {
        case .popular:
            header.configure(title: "🔥 인기공고", subtitle: nil)
        default:
            break
        }
        return header
    }
}

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        switch Section(rawValue: indexPath.section) {
        case .banner:
            navigationController?.pushViewController(FestivalListViewController(), animated: true)

        case .quickMenu:
            if indexPath.item == 0 {
                navigationController?.pushViewController(FestivalCalendarViewController(), animated: true)
            } else {
                tabBarController?.selectedIndex = RootTabBarController.Tab.ai.rawValue
            }

        case .popular, .none:
            break
        }
    }
}

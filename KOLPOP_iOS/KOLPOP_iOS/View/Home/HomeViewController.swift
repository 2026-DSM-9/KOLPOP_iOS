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
        case category
        case popular
    }

    private let categories = [
        PopupCategory(title: "카페"),
        PopupCategory(title: "리테일"),
        PopupCategory(title: "F&B"),
        PopupCategory(title: "브랜드 팝업")
    ]

    private var selectedCategoryIndex = 1

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
        $0.allowsMultipleSelection = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(FestivalBannerCell.self, forCellWithReuseIdentifier: FestivalBannerCell.reuseIdentifier)
        $0.register(QuickMenuCell.self, forCellWithReuseIdentifier: QuickMenuCell.reuseIdentifier)
        $0.register(CategoryChipCell.self, forCellWithReuseIdentifier: CategoryChipCell.reuseIdentifier)
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
        preselectDefaultCategory()
    }

    private func preselectDefaultCategory() {
        let indexPath = IndexPath(item: selectedCategoryIndex, section: Section.category.rawValue)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        let titleLabel = UILabel().then {
            $0.text = "콜팝"
            $0.font = .systemFont(ofSize: 24, weight: .heavy)
            $0.textColor = UIColor(named: "1A1C1E")
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
            case .category:
                return self?.makeCategorySection()
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

    private func makeCategorySection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(90), heightDimension: .absolute(40))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(90), heightDimension: .absolute(40)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 32, trailing: 20)
        section.boundarySupplementaryItems = [makeHeader(height: 66)]
        return section
    }

    private func makePopularSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(260)),
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
        case .category: return categories.count
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

        case .category:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryChipCell.reuseIdentifier, for: indexPath) as! CategoryChipCell
            cell.configure(title: categories[indexPath.item].title)
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
        case .category:
            header.configure(title: "어떤 팝업을 여시나요?", subtitle: "카테고리로 매물을 골라보세요")
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
        guard Section(rawValue: indexPath.section) == .category else { return }
        selectedCategoryIndex = indexPath.item
    }
}

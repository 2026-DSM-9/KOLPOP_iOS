//
//  PopularListingCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit

final class PopularListingCell: UICollectionViewCell {

    static let reuseIdentifier = "PopularListingCell"

    private let cardView = ListingCardView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(with listing: PopularListing) {
        cardView.configure(with: listing)
    }
}

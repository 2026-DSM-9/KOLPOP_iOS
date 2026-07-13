//
//  BuildingListingCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit

final class BuildingListingCell: UITableViewCell {

    static let reuseIdentifier = "BuildingListingCell"

    private let cardView = ListingCardView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    func configure(with listing: PopularListing) {
        cardView.configure(with: listing)
    }
}

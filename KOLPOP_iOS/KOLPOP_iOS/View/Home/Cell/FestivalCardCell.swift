//
//  FestivalCardCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit

final class FestivalCardCell: UITableViewCell {

    static let reuseIdentifier = "FestivalCardCell"

    private let cardView = FestivalInfoCardView(descriptionNumberOfLines: 1)

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
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        }
    }

    func configure(with festival: Festival, nearbyVacantBuildingCount: Int) {
        cardView.configure(with: festival, nearbyVacantBuildingCount: nearbyVacantBuildingCount)
    }
}

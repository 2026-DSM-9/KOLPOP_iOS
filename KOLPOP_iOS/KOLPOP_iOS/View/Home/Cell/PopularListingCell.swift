//
//  PopularListingCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then
import NukeExtensions

final class PopularListingCell: UICollectionViewCell {

    static let reuseIdentifier = "PopularListingCell"

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.backgroundColor = UIColor(named: "E8E8E8")
    }

    private let likeBadge = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        $0.layer.cornerRadius = 12
    }

    private let likeIcon = UIImageView(image: UIImage(systemName: "heart")).then {
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }

    private let likeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .white
    }

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = UIColor(named: "1A1C1E")
        $0.numberOfLines = 1
    }

    private let addressLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor(named: "A3A4A5")
        $0.numberOfLines = 1
    }

    private let sizeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = UIColor(named: "767778")
    }

    private let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textColor = UIColor(named: "00AEEF")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        likeBadge.addSubview(likeIcon)
        likeBadge.addSubview(likeLabel)
        [thumbnailImageView, likeBadge, titleLabel, addressLabel, sizeLabel, priceLabel].forEach {
            contentView.addSubview($0)
        }

        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(thumbnailImageView.snp.width).multipliedBy(0.8)
        }

        likeBadge.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(thumbnailImageView).offset(-10)
        }
        likeIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        likeLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeIcon.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
        }
        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(sizeLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func configure(with listing: PopularListing) {
        if let imageURL = listing.imageURL {
            NukeExtensions.loadImage(with: imageURL, into: thumbnailImageView)
        } else {
            thumbnailImageView.image = nil
        }
        titleLabel.text = listing.title
        addressLabel.text = listing.address
        sizeLabel.text = listing.sizeInfo
        priceLabel.text = listing.price
        likeLabel.text = "\(listing.likeCount)"
    }
}

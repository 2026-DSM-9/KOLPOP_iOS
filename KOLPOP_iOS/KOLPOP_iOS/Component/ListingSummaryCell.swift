//
//  ListingSummaryCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then
import NukeExtensions

final class ListingSummaryCell: UITableViewCell {

    static let reuseIdentifier = "ListingSummaryCell"

    var onInquireTapped: (() -> Void)?
    var onDetailTapped: (() -> Void)?

    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "E8E8E8")?.cgColor
    }

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.backgroundColor = UIColor(named: "E8E8E8")
    }

    private let titleLabel = UILabel().then {
        $0.font = .paperlogy(.semiBold, size: 16)
        $0.textColor = UIColor(named: "0F1010")
        $0.numberOfLines = 1
    }

    private let priceLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 15)
        $0.textColor = UIColor(named: "00AEEF")
    }

    private let addressLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 13)
        $0.textColor = UIColor(named: "A3A4A5")
        $0.numberOfLines = 1
    }

    private let sizeLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 12)
        $0.textColor = UIColor(named: "767778")
    }

    private let categoryBadge = UIView().then {
        $0.backgroundColor = UIColor(named: "F8F8F8")
        $0.layer.cornerRadius = 8
    }

    private let categoryLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 11)
        $0.textColor = UIColor(named: "767778")
    }

    private let likeIcon = UIImageView(image: UIImage(systemName: "heart")).then {
        $0.tintColor = UIColor(named: "A3A4A5")
        $0.contentMode = .scaleAspectFit
    }

    private let likeLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 12)
        $0.textColor = UIColor(named: "A3A4A5")
    }

    private let inquireButton = UIButton(type: .system).then {
        $0.setTitle("바로 문의하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .paperlogy(.semiBold, size: 14)
        $0.backgroundColor = UIColor(named: "00AEEF")
        $0.layer.cornerRadius = 10
    }

    private let detailButton = UIButton(type: .system).then {
        $0.setTitle("상세보기", for: .normal)
        $0.setTitleColor(UIColor(named: "00AEEF"), for: .normal)
        $0.titleLabel?.font = .paperlogy(.semiBold, size: 14)
        $0.backgroundColor = UIColor(named: "BFEBFB")
        $0.layer.cornerRadius = 10
    }

    private lazy var actionStackView = UIStackView(arrangedSubviews: [inquireButton, detailButton]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }

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

        categoryBadge.addSubview(categoryLabel)
        [thumbnailImageView, titleLabel, priceLabel, addressLabel, sizeLabel, categoryBadge, likeIcon, likeLabel, actionStackView].forEach {
            containerView.addSubview($0)
        }
        contentView.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20))
        }

        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.width.height.equalTo(80)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-8)
        }
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-12)
        }
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
        }
        categoryBadge.snp.makeConstraints { make in
            make.centerY.equalTo(sizeLabel)
            make.leading.equalTo(sizeLabel.snp.trailing).offset(8)
        }
        categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8))
        }

        likeIcon.snp.makeConstraints { make in
            make.centerY.equalTo(sizeLabel)
            make.trailing.equalToSuperview().offset(-12)
            make.width.height.equalTo(14)
        }
        likeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sizeLabel)
            make.trailing.equalTo(likeIcon.snp.leading).offset(-4)
        }

        actionStackView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(38)
        }

        inquireButton.addTarget(self, action: #selector(inquireTapped), for: .touchUpInside)
        detailButton.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
    }

    func configure(with listing: ListingSummary, isSelected: Bool, isLiked: Bool = false) {
        likeIcon.image = UIImage(systemName: isLiked ? "heart.fill" : "heart")
        likeIcon.tintColor = UIColor(named: isLiked ? "EA8C21" : "A3A4A5")

        if let imageURL = listing.imageURL {
            NukeExtensions.loadImage(with: imageURL, into: thumbnailImageView)
        } else {
            thumbnailImageView.image = nil
        }
        titleLabel.text = listing.title
        priceLabel.text = listing.price
        addressLabel.text = listing.address
        sizeLabel.text = listing.sizeInfo
        categoryLabel.text = listing.category
        likeLabel.text = "\(listing.likeCount)"

        actionStackView.isHidden = !isSelected
        containerView.layer.borderColor = isSelected
            ? UIColor(named: "00AEEF")?.cgColor
            : UIColor(named: "E8E8E8")?.cgColor
        containerView.layer.borderWidth = isSelected ? 2 : 1

        actionStackView.snp.updateConstraints { make in
            make.height.equalTo(isSelected ? 38 : 0)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onInquireTapped = nil
        onDetailTapped = nil
    }

    @objc private func inquireTapped() { onInquireTapped?() }
    @objc private func detailTapped() { onDetailTapped?() }
}

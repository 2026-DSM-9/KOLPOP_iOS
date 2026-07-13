//
//  CategoryChipCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class CategoryChipCell: UICollectionViewCell {

    static let reuseIdentifier = "CategoryChipCell"

    private let titleLabel = UILabel().then {
        $0.font = .paperlogy(.semiBold, size: 15)
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        applyStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.layer.cornerRadius = 20

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
    }

    override var isSelected: Bool {
        didSet { applyStyle() }
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    private func applyStyle() {
        if isSelected {
            contentView.backgroundColor = UIColor(named: "0F1010")
            contentView.layer.borderWidth = 0
            titleLabel.textColor = .white
        } else {
            contentView.backgroundColor = .white
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor(named: "E8E8E8")?.cgColor
            titleLabel.textColor = UIColor(named: "1A1C1E")
        }
    }
}

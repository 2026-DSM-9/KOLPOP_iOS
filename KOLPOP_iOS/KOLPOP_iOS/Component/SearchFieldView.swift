//
//  SearchFieldView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class SearchFieldView: UIView {

    let textField = UITextField().then {
        $0.font = .paperlogy(.regular, size: 15)
        $0.textColor = UIColor(named: "1A1C1E")
        $0.returnKeyType = .search
        $0.clearButtonMode = .whileEditing
    }

    private let iconImageView = UIImageView(image: UIImage(systemName: "magnifyingglass")).then {
        $0.tintColor = UIColor(named: "A3A4A5")
        $0.contentMode = .scaleAspectFit
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = UIColor(named: "F8F8F8")
        layer.cornerRadius = 14

        addSubview(iconImageView)
        addSubview(textField)

        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview().inset(14)
        }
    }

    func setPlaceholder(_ text: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor(named: "A3A4A5") ?? .gray,
                .font: UIFont.paperlogy(.regular, size: 15)
            ]
        )
    }
}

//
//  LabeledTextFieldView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class LabeledTextFieldView: UIView {

    let textField = UITextField().then {
        $0.font = .paperlogy(.medium, size: 16)
        $0.textColor = UIColor(named: "1A1C1E")
    }

    private let titleLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 14)
        $0.textColor = UIColor(named: "A3A4A5")
    }

    private let fieldBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 24
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "E8E8E8")?.cgColor
    }

    init(title: String, placeholder: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupLayout()
        setPlaceholder(placeholder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        fieldBackgroundView.addSubview(textField)
        [titleLabel, fieldBackgroundView].forEach { addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        fieldBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(56)
        }
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20))
        }
    }

    private func setPlaceholder(_ text: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor(named: "A3A4A5") ?? .gray,
                .font: UIFont.paperlogy(.medium, size: 16)
            ]
        )
    }
}

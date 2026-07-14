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

    private let secureToggleButton = UIButton(type: .system).then {
        $0.tintColor = UIColor(named: "A3A4A5")
    }

    private let isSecureField: Bool

    init(title: String, placeholder: String, isSecureField: Bool = false) {
        self.isSecureField = isSecureField
        super.init(frame: .zero)
        titleLabel.text = title
        textField.isSecureTextEntry = isSecureField
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

        if isSecureField {
            fieldBackgroundView.addSubview(secureToggleButton)
            updateSecureToggleIcon()
            secureToggleButton.addTarget(self, action: #selector(secureToggleTapped), for: .touchUpInside)

            secureToggleButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-20)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(22)
            }
            textField.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(16)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalTo(secureToggleButton.snp.leading).offset(-8)
            }
        } else {
            textField.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20))
            }
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

    @objc private func secureToggleTapped() {
        textField.isSecureTextEntry.toggle()
        updateSecureToggleIcon()
    }

    private func updateSecureToggleIcon() {
        let imageName = textField.isSecureTextEntry ? "eye.slash" : "eye"
        secureToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

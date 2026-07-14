//
//  ChatInputBarView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class ChatInputBarView: UIView {

    var onSendTapped: ((String) -> Void)?
    var onAttachmentTapped: (() -> Void)?

    let textField = UITextField().then {
        $0.font = .paperlogy(.regular, size: 15)
        $0.textColor = UIColor(named: "1A1C1E")
        $0.returnKeyType = .send
    }

    private let fieldBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(named: "F8F8F8")
        $0.layer.cornerRadius = 14
    }

    private let sendButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(named: "00AEEF")
        $0.layer.cornerRadius = 22
        $0.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        $0.tintColor = .white
    }

    private let attachmentButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(named: "F8F8F8")
        $0.layer.cornerRadius = 22
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = UIColor(named: "1A1C1E")
    }

    private let showsAttachmentButton: Bool

    init(showsAttachmentButton: Bool = false) {
        self.showsAttachmentButton = showsAttachmentButton
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        fieldBackgroundView.addSubview(textField)
        [attachmentButton, fieldBackgroundView, sendButton].forEach { addSubview($0) }

        attachmentButton.isHidden = !showsAttachmentButton

        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }

        if showsAttachmentButton {
            attachmentButton.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.height.equalTo(44)
            }
            fieldBackgroundView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.equalTo(attachmentButton.snp.trailing).offset(8)
                make.trailing.equalTo(sendButton.snp.leading).offset(-12)
            }
        } else {
            fieldBackgroundView.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
                make.trailing.equalTo(sendButton.snp.leading).offset(-12)
            }
        }

        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16))
        }

        textField.delegate = self
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        attachmentButton.addTarget(self, action: #selector(attachmentTapped), for: .touchUpInside)
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

    func clear() {
        textField.text = nil
    }

    @objc private func sendTapped() {
        guard let text = textField.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        onSendTapped?(text)
    }

    @objc private func attachmentTapped() {
        onAttachmentTapped?()
    }
}

extension ChatInputBarView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped()
        return true
    }
}

//
//  AIMessageCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class AIMessageCell: UITableViewCell {

    static let reuseIdentifier = "AIMessageCell"

    var onCopyTapped: (() -> Void)?

    private let iconBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(named: "00AEEF")
        $0.layer.cornerRadius = 16
    }

    private let iconImageView = UIImageView(image: UIImage(systemName: "sparkles")).then {
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }

    private let nameLabel = UILabel().then {
        $0.text = "AI 파트너"
        $0.font = .paperlogy(.bold, size: 16)
        $0.textColor = UIColor(named: "00AEEF")
    }

    private let bubbleView = UIView().then {
        $0.backgroundColor = UIColor(named: "F8F8F8")
        $0.layer.cornerRadius = 16
    }

    private let messageLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 15)
        $0.textColor = UIColor(named: "1A1C1E")
        $0.numberOfLines = 0
    }

    private let typingIndicatorView = TypingIndicatorView()

    private let copyButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        $0.setTitle(" 복사하기", for: .normal)
        $0.tintColor = UIColor(named: "00AEEF")
        $0.setTitleColor(UIColor(named: "00AEEF"), for: .normal)
        $0.titleLabel?.font = .paperlogy(.medium, size: 14)
        $0.contentHorizontalAlignment = .leading
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

        iconBackgroundView.addSubview(iconImageView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(typingIndicatorView)
        [iconBackgroundView, nameLabel, bubbleView, copyButton].forEach {
            contentView.addSubview($0)
        }

        iconBackgroundView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(32)
        }
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(16)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconBackgroundView)
            make.leading.equalTo(iconBackgroundView.snp.trailing).offset(8)
        }

        bubbleView.snp.makeConstraints { make in
            make.top.equalTo(iconBackgroundView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-60)
        }
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        typingIndicatorView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(36)
            make.height.equalTo(8)
        }

        copyButton.snp.makeConstraints { make in
            make.top.equalTo(bubbleView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(20)
        }

        copyButton.addTarget(self, action: #selector(copyTapped), for: .touchUpInside)
    }

    func configure(with message: ChatMessage) {
        messageLabel.text = message.text
        messageLabel.isHidden = message.isTyping
        typingIndicatorView.isHidden = !message.isTyping
        copyButton.isHidden = !message.showCopyButton

        copyButton.snp.remakeConstraints { make in
            if message.showCopyButton {
                make.top.equalTo(bubbleView.snp.bottom).offset(8)
                make.height.equalTo(20)
            } else {
                make.top.equalTo(bubbleView.snp.bottom)
                make.height.equalTo(0)
            }
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-12)
        }

        if message.isTyping {
            typingIndicatorView.startAnimating()
        } else {
            typingIndicatorView.stopAnimating()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        typingIndicatorView.stopAnimating()
        onCopyTapped = nil
    }

    @objc private func copyTapped() {
        onCopyTapped?()
    }
}

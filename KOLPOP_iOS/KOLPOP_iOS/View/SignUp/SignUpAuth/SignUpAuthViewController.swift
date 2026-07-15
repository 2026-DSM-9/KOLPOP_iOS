//
//  SignUpAuthViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class SignUpAuthViewController: UIViewController {

    private let authService = AuthService()
    private var isSendingCode = false
    private var isVerifyingCode = false

    private let backButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = UIColor(named: "0F1010")
    }

    private let brandHeaderView = SignUpBrandHeaderView()

    private let phoneField = LabeledTextFieldView(title: "전화번호", placeholder: "전화번호를 입력해주세요").then {
        $0.textField.keyboardType = .numberPad
    }

    private let sendCodeButton = UIButton(type: .system).then {
        $0.setTitle("인증 코드 발송", for: .normal)
        $0.titleLabel?.font = .paperlogy(.medium, size: 14)
        $0.layer.cornerRadius = 16
        $0.isEnabled = false
    }

    private let codeField = LabeledTextFieldView(title: "인증코드", placeholder: "인증코드를 입력해주세요").then {
        $0.textField.keyboardType = .numberPad
    }

    private let statusLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 15)
        $0.textColor = .systemRed
        $0.textAlignment = .center
        $0.isHidden = true
    }

    private let nextButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .paperlogy(.bold, size: 16)
        $0.layer.cornerRadius = 26
        $0.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupLayout()
        setupActions()
        updateSendCodeButtonStyle()
        updateNextButtonStyle()
        dismissKeyboardOnTap()
    }

    private func setupLayout() {
        [backButton, brandHeaderView, phoneField, sendCodeButton, codeField, statusLabel, nextButton].forEach {
            view.addSubview($0)
        }

        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(24)
        }
        brandHeaderView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        phoneField.snp.makeConstraints { make in
            make.top.equalTo(brandHeaderView.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        sendCodeButton.snp.makeConstraints { make in
            make.top.equalTo(phoneField.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-32)
            make.width.equalTo(113)
            make.height.equalTo(32)
        }
        codeField.snp.makeConstraints { make in
            make.top.equalTo(sendCodeButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(codeField.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(52)
        }
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        sendCodeButton.addTarget(self, action: #selector(sendCodeTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        phoneField.textField.addTarget(self, action: #selector(fieldsDidChange), for: .editingChanged)
        codeField.textField.addTarget(self, action: #selector(fieldsDidChange), for: .editingChanged)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func fieldsDidChange() {
        isSendingCode = false
        isVerifyingCode = false
        statusLabel.isHidden = true
        updateSendCodeButtonStyle()
        updateNextButtonStyle()
    }

    private func updateSendCodeButtonStyle() {
        let isPhoneFilled = !(phoneField.textField.text ?? "").isEmpty
        let isEnabled = isPhoneFilled && !isSendingCode
        sendCodeButton.isEnabled = isEnabled
        sendCodeButton.backgroundColor = UIColor(named: isEnabled ? "BFEBFB" : "F8F8F8")
        sendCodeButton.setTitleColor(UIColor(named: isEnabled ? "00688F" : "767778"), for: .normal)
    }

    private func updateNextButtonStyle() {
        let isPhoneFilled = !(phoneField.textField.text ?? "").isEmpty
        let isCodeFilled = !(codeField.textField.text ?? "").isEmpty
        let isReady = isPhoneFilled && isCodeFilled && !isVerifyingCode
        nextButton.isEnabled = isReady
        nextButton.backgroundColor = UIColor(named: isReady ? "33BEF2" : "99DFF9")
    }

    @objc private func sendCodeTapped() {
        guard let phone = phoneField.textField.text, !phone.isEmpty else { return }

        isSendingCode = true
        updateSendCodeButtonStyle()
        statusLabel.text = "인증번호를 발송 중입니다"
        statusLabel.textColor = UIColor(named: "767778")
        statusLabel.isHidden = false

        authService.sendVerificationCode(phone: phone) { [weak self] result in
            DispatchQueue.main.async {
                guard let self, self.phoneField.textField.text == phone else { return }

                self.isSendingCode = false
                switch result {
                case .success(true):
                    self.statusLabel.text = "인증번호를 발송했습니다"
                    self.statusLabel.textColor = .systemGreen
                case .success(false), .failure:
                    self.statusLabel.text = "인증번호 발송에 실패했습니다"
                    self.statusLabel.textColor = .systemRed
                }
                self.updateSendCodeButtonStyle()
            }
        }
    }

    @objc private func nextTapped() {
        guard
            let phone = phoneField.textField.text, !phone.isEmpty,
            let code = codeField.textField.text, !code.isEmpty
        else { return }

        isVerifyingCode = true
        updateNextButtonStyle()
        statusLabel.text = "인증번호를 확인 중입니다"
        statusLabel.textColor = UIColor(named: "767778")
        statusLabel.isHidden = false

        authService.verifyVerificationCode(phone: phone, code: code) { [weak self] result in
            DispatchQueue.main.async {
                guard
                    let self,
                    self.phoneField.textField.text == phone,
                    self.codeField.textField.text == code
                else { return }

                self.isVerifyingCode = false
                switch result {
                case .success(true):
                    self.navigationController?.pushViewController(
                        SignUpInfoViewController(verifiedPhone: phone),
                        animated: true
                    )
                case .success(false), .failure:
                    self.statusLabel.text = "인증코드를 확인해주세요"
                    self.statusLabel.textColor = .systemRed
                }
                self.updateNextButtonStyle()
            }
        }
    }
}

//
//  ProfileEditViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class ProfileEditViewController: UIViewController {

    // TODO: 실제 인증 API 연동 전까지는 이 코드로만 인증에 성공한 것으로 처리한다.
    private static let mockValidVerificationCode = "123456"

    private let profile: UserProfile
    private let onSave: (UserProfile) -> Void

    private var isCodeSent = false

    private let nameField = LabeledTextFieldView(title: "실명", placeholder: "이름을 입력해주세요")
    private let phoneField = LabeledTextFieldView(title: "전화번호", placeholder: "전화번호를 입력해주세요")
    private let codeField = LabeledTextFieldView(title: "인증코드", placeholder: "인증코드를 입력해주세요")

    private let sendCodeButton = UIButton(type: .system).then {
        $0.setTitle("인증 코드 발송", for: .normal)
        $0.setTitleColor(UIColor(named: "1A1C1E"), for: .normal)
        $0.titleLabel?.font = .paperlogy(.semiBold, size: 14)
        $0.backgroundColor = UIColor(named: "F8F8F8")
        $0.layer.cornerRadius = 18
    }

    private let statusLabel = UILabel().then {
        $0.font = .paperlogy(.semiBold, size: 15)
        $0.textAlignment = .center
        $0.isHidden = true
    }

    private let submitButton = UIButton(type: .system).then {
        $0.setTitle("수정하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .paperlogy(.semiBold, size: 17)
        $0.backgroundColor = UIColor(named: "00AEEF")
        $0.layer.cornerRadius = 27
    }

    init(profile: UserProfile, onSave: @escaping (UserProfile) -> Void) {
        self.profile = profile
        self.onSave = onSave
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "프로필 수정"
        setupLayout()

        nameField.textField.text = profile.name

        sendCodeButton.addTarget(self, action: #selector(sendCodeTapped), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 마이페이지가 탭 내비게이션 바를 숨겨두기 때문에 이 화면에서는 다시 보여준다.
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupLayout() {
        [nameField, phoneField, sendCodeButton, codeField, statusLabel, submitButton].forEach {
            view.addSubview($0)
        }

        nameField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        phoneField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        sendCodeButton.snp.makeConstraints { make in
            make.top.equalTo(phoneField.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(36)
            make.width.greaterThanOrEqualTo(110)
        }
        codeField.snp.makeConstraints { make in
            make.top.equalTo(sendCodeButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(codeField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
        }
    }

    @objc private func sendCodeTapped() {
        guard let phone = phoneField.textField.text, !phone.isEmpty else { return }
        // TODO: 실제 인증 코드 발송 API 연동 예정
        isCodeSent = true
        statusLabel.isHidden = true
    }

    @objc private func submitTapped() {
        guard codeField.textField.text == Self.mockValidVerificationCode else {
            showStatus(text: "인증코드를 확인해주세요", isSuccess: false)
            return
        }

        var updatedProfile = profile
        if let name = nameField.textField.text, !name.isEmpty {
            updatedProfile.name = name
        }
        if let phone = phoneField.textField.text, !phone.isEmpty {
            updatedProfile.phoneNumber = phone
        }

        // TODO: 실제 회원정보 수정 API 연동 예정
        onSave(updatedProfile)
        showStatus(text: "수정이 완료되었어요", isSuccess: true)
    }

    private func showStatus(text: String, isSuccess: Bool) {
        statusLabel.text = text
        statusLabel.textColor = isSuccess ? .systemGreen : .systemRed
        statusLabel.isHidden = false
    }
}

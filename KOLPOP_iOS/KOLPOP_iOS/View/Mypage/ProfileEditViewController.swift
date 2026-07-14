//
//  ProfileEditViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class ProfileEditViewController: UIViewController {

    private let authService = AuthService()
    private let myPageService = MyPageService()

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

    private let loadingOverlayView = LoadingOverlayView(message: "처리 중이에요")

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
        [nameField, phoneField, sendCodeButton, codeField, statusLabel, submitButton, loadingOverlayView].forEach {
            view.addSubview($0)
        }

        loadingOverlayView.isHidden = true
        loadingOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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

        loadingOverlayView.isHidden = false
        authService.sendVerificationCode(phone: phone) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.loadingOverlayView.isHidden = true
                switch result {
                case .success:
                    self.isCodeSent = true
                    self.statusLabel.isHidden = true
                case .failure(let error):
                    print("인증코드 발송 실패: \(error)")
                    self.showStatus(text: "인증코드 발송에 실패했어요", isSuccess: false)
                }
            }
        }
    }

    @objc private func submitTapped() {
        guard let phone = phoneField.textField.text, !phone.isEmpty else { return }
        guard let code = codeField.textField.text, !code.isEmpty else {
            showStatus(text: "인증코드를 입력해주세요", isSuccess: false)
            return
        }

        loadingOverlayView.isHidden = false
        authService.verifyVerificationCode(phone: phone, code: code) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.submitProfileUpdate(phone: phone)
                case .failure(let error):
                    self.loadingOverlayView.isHidden = true
                    print("인증코드 확인 실패: \(error)")
                    self.showStatus(text: "인증코드를 확인해주세요", isSuccess: false)
                }
            }
        }
    }

    private func submitProfileUpdate(phone: String) {
        let name = nameField.textField.text?.isEmpty == false ? nameField.textField.text! : profile.name

        myPageService.updateMyPage(name: name, email: profile.email, phone: phone, introduction: profile.introduction) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.loadingOverlayView.isHidden = true
                switch result {
                case .success(let myPage):
                    let updatedProfile = UserProfile(name: myPage.name, phoneNumber: myPage.phone, email: myPage.email, introduction: myPage.introduction)
                    self.onSave(updatedProfile)
                    self.showStatus(text: "수정이 완료되었어요", isSuccess: true)
                case .failure(let error):
                    print("회원정보 수정 실패: \(error)")
                    self.showStatus(text: "수정에 실패했어요", isSuccess: false)
                }
            }
        }
    }

    private func showStatus(text: String, isSuccess: Bool) {
        statusLabel.text = text
        statusLabel.textColor = isSuccess ? .systemGreen : .systemRed
        statusLabel.isHidden = false
    }
}

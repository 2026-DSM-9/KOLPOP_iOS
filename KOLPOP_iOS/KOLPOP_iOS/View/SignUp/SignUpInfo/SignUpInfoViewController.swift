//
//  SignUpInfoViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class SignUpInfoViewController: UIViewController {

    private let authService = AuthService()
    private let verifiedPhone: String

    // TODO: 실제 아이디 중복확인 API 연동 전까지는 이 값만 중복으로 처리한다.
    private static let mockDuplicateID = "circle08"

    private let backButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = UIColor(named: "0F1010")
    }

    private let brandHeaderView = SignUpBrandHeaderView()

    private let nameField = LabeledTextFieldView(title: "실명", placeholder: "실명을 입력해주세요")

    private let idField = LabeledTextFieldView(title: "아이디", placeholder: "아이디을 입력해주세요")

    private let idCheckButton = UIButton(type: .system).then {
        $0.setTitle("중복확인", for: .normal)
        $0.titleLabel?.font = .paperlogy(.medium, size: 14)
        $0.layer.cornerRadius = 16
        $0.isEnabled = false
    }

    private let idFeedbackLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 14)
        $0.textAlignment = .right
        $0.isHidden = true
    }

    private let passwordField = LabeledTextFieldView(title: "비밀번호", placeholder: "비밀번호를 입력해주세요", isSecureField: true)

    private let passwordRuleLabel = UILabel().then {
        $0.text = "비밀번호 형식은~"
        $0.font = .paperlogy(.medium, size: 13)
        $0.textColor = UIColor(named: "00AEEF")
    }

    private let passwordCheckField = LabeledTextFieldView(title: "비밀번호 확인", placeholder: "비밀번호를 한 번 더 입력해주세요", isSecureField: true)

    private let errorLabel = UILabel().then {
        $0.text = "정보를 확인해주세요"
        $0.font = .paperlogy(.medium, size: 15)
        $0.textColor = .systemRed
        $0.textAlignment = .center
        $0.isHidden = true
    }

    private let signUpButton = UIButton(type: .system).then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .paperlogy(.bold, size: 16)
        $0.layer.cornerRadius = 26
        $0.isEnabled = false
    }

    private var isIDVerifiedAvailable = false

    init(verifiedPhone: String) {
        self.verifiedPhone = verifiedPhone
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupLayout()
        setupActions()
        updateIDCheckButtonStyle()
        updateSignUpButtonStyle()
    }

    private func setupLayout() {
        let scrollView = UIScrollView()
        let contentView = UIView()

        [backButton, scrollView].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)

        [brandHeaderView, nameField, idField, idCheckButton, idFeedbackLabel,
         passwordField, passwordRuleLabel, passwordCheckField, errorLabel, signUpButton].forEach {
            contentView.addSubview($0)
        }

        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(24)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        brandHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        nameField.snp.makeConstraints { make in
            make.top.equalTo(brandHeaderView.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        idField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        idCheckButton.snp.makeConstraints { make in
            make.top.equalTo(idField.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-32)
            make.width.equalTo(82)
            make.height.equalTo(32)
        }
        idFeedbackLabel.snp.makeConstraints { make in
            make.centerY.equalTo(idCheckButton)
            make.trailing.equalTo(idCheckButton.snp.leading).offset(-12)
            make.leading.greaterThanOrEqualToSuperview().offset(32)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(idCheckButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        passwordRuleLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(32)
        }
        passwordCheckField.snp.makeConstraints { make in
            make.top.equalTo(passwordRuleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordCheckField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-40)
        }
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        idCheckButton.addTarget(self, action: #selector(idCheckTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)

        [nameField, idField, passwordField, passwordCheckField].forEach {
            $0.textField.addTarget(self, action: #selector(fieldsDidChange), for: .editingChanged)
        }
        idField.textField.addTarget(self, action: #selector(idFieldDidChange), for: .editingChanged)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func idFieldDidChange() {
        isIDVerifiedAvailable = false
        idFeedbackLabel.isHidden = true
        updateIDCheckButtonStyle()
    }

    @objc private func fieldsDidChange() {
        errorLabel.isHidden = true
        updateSignUpButtonStyle()
    }

    private func updateIDCheckButtonStyle() {
        let isIDFilled = !(idField.textField.text ?? "").isEmpty
        idCheckButton.isEnabled = isIDFilled
        idCheckButton.backgroundColor = UIColor(named: isIDFilled ? "BFEBFB" : "F8F8F8")
        idCheckButton.setTitleColor(UIColor(named: isIDFilled ? "00688F" : "767778"), for: .normal)
    }

    private func updateSignUpButtonStyle() {
        let isReady = ![nameField, idField, passwordField, passwordCheckField]
            .map { $0.textField.text ?? "" }
            .contains(where: \.isEmpty)
        signUpButton.isEnabled = isReady
        signUpButton.backgroundColor = UIColor(named: isReady ? "33BEF2" : "99DFF9")
    }

    @objc private func idCheckTapped() {
        // TODO: 실제 아이디 중복확인 API 연동 예정
        idFeedbackLabel.isHidden = false
        if idField.textField.text == Self.mockDuplicateID {
            idFeedbackLabel.text = "중복된 아이디 입니다"
            idFeedbackLabel.textColor = .systemRed
            isIDVerifiedAvailable = false
        } else {
            idFeedbackLabel.text = "사용 가능한 아이디 입니다"
            idFeedbackLabel.textColor = .systemGreen
            isIDVerifiedAvailable = true
        }
    }

    @objc private func signUpTapped() {
        guard
            let name = nameField.textField.text, !name.isEmpty,
            let nickname = idField.textField.text, !nickname.isEmpty,
            let password = passwordField.textField.text, !password.isEmpty,
            let passwordConfirm = passwordCheckField.textField.text, !passwordConfirm.isEmpty,
            password == passwordConfirm,
            isIDVerifiedAvailable
        else {
            errorLabel.isHidden = false
            return
        }

        authService.signup(nickname: nickname, name: name, password: password, passwordConfirm: passwordConfirm, phone: verifiedPhone) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.moveToMainScreen()
                case .failure:
                    self.errorLabel.isHidden = false
                }
            }
        }
    }

    private func moveToMainScreen() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
        else { return }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = RootTabBarController()
        }
    }
}

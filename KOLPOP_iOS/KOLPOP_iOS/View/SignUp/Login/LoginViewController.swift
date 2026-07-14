//
//  LoginViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class LoginViewController: UIViewController {

    // TODO: 실제 로그인 API 연동 전까지는 이 계정으로만 로그인에 성공한 것으로 처리한다.
    private static let mockValidID = "circle08"
    private static let mockValidPassword = "circlecircle"

    private let brandHeaderView = SignUpBrandHeaderView()

    private let idField = LabeledTextFieldView(title: "아이디", placeholder: "아이디를 입력해주세요")

    private let passwordField = LabeledTextFieldView(title: "비밀번호", placeholder: "비밀번호를 입력해주세요", isSecureField: true)

    private let errorLabel = UILabel().then {
        $0.text = "아이디와 비밀번호를 확인해주세요"
        $0.font = .paperlogy(.medium, size: 15)
        $0.textColor = .systemRed
        $0.textAlignment = .center
        $0.isHidden = true
    }

    private let loginButton = UIButton(type: .system).then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .paperlogy(.bold, size: 16)
        $0.layer.cornerRadius = 26
        $0.isEnabled = false
    }

    private let signUpLinkButton = UIButton(type: .system).then {
        let attributed = NSAttributedString(
            string: "회원가입",
            attributes: [
                .font: UIFont.paperlogy(.medium, size: 15),
                .foregroundColor: UIColor(named: "A3A4A5") ?? .gray,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        $0.setAttributedTitle(attributed, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupActions()
        updateLoginButtonStyle()
    }

    private func setupLayout() {
        [brandHeaderView, idField, passwordField, errorLabel, loginButton, signUpLinkButton].forEach {
            view.addSubview($0)
        }

        brandHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(180)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        idField.snp.makeConstraints { make in
            make.top.equalTo(brandHeaderView.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(idField.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(52)
        }
        signUpLinkButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signUpLinkButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        idField.textField.addTarget(self, action: #selector(fieldsDidChange), for: .editingChanged)
        passwordField.textField.addTarget(self, action: #selector(fieldsDidChange), for: .editingChanged)
    }

    @objc private func fieldsDidChange() {
        errorLabel.isHidden = true
        updateLoginButtonStyle()
    }

    private func updateLoginButtonStyle() {
        let isReady = !(idField.textField.text ?? "").isEmpty && !(passwordField.textField.text ?? "").isEmpty
        loginButton.isEnabled = isReady
        loginButton.backgroundColor = UIColor(named: isReady ? "33BEF2" : "99DFF9")
    }

    @objc private func loginTapped() {
        // TODO: 실제 로그인 API 연동 예정
        guard
            idField.textField.text == Self.mockValidID,
            passwordField.textField.text == Self.mockValidPassword
        else {
            errorLabel.isHidden = false
            return
        }

        moveToMainScreen()
    }

    @objc private func signUpTapped() {
        navigationController?.pushViewController(SignUpAuthViewController(), animated: true)
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

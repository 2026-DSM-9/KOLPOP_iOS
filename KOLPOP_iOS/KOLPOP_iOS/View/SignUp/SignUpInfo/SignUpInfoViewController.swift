import UIKit
import SnapKit
import Then

final class SignUpInfoViewController: UIViewController {
    
    private let authService = AuthService()
    var verifiedPhone: String = "010-1234-5678" // 이전 화면에서 받아올 전화번호 데이터 데이터 예시
    
    private let nameTextField = UITextField().then {
        $0.textColor = UIColor(named: "0F1010")
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.attributedPlaceholder = NSAttributedString(
            string: "실명을 입력해주세요",
            attributes: [.foregroundColor: UIColor(named: "D9D9D9")!]
        )
        $0.layer.borderColor = UIColor(named: "D9D9D9")!.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 25
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 52))
        $0.leftView = paddingView
        $0.leftViewMode = .always
    }
    
    private let idTextField = UITextField().then {
        $0.textColor = UIColor(named: "0F1010")
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.attributedPlaceholder = NSAttributedString(
            string: "아이디를 입력해주세요",
            attributes: [.foregroundColor: UIColor(named: "D9D9D9")!]
        )
        $0.layer.borderColor = UIColor(named: "D9D9D9")!.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 25
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 52))
        $0.leftView = paddingView
        $0.leftViewMode = .always
    }
    
    private let idCheckButton = UIButton().then {
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(UIColor(named: "767778"), for: .normal)
        $0.backgroundColor = UIColor(named: "F8F8F8")
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.layer.cornerRadius = 16
        $0.isEnabled = false
    }
    
    // 중복확인 피드백 라벨 (가이드 이미지의 '사용 가능한 아이디 입니다' / '중복된 아이디 입니다')
    private let idFeedbackLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.isHidden = true
    }
    
    private let passwordTextField = UITextField().then {
        $0.textColor = UIColor(named: "0F1010")
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.attributedPlaceholder = NSAttributedString(
            string: "비밀번호를 입력해주세요",
            attributes: [.foregroundColor: UIColor(named: "D9D9D9")!]
        )
        $0.layer.borderColor = UIColor(named: "D9D9D9")!.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 25
        $0.isSecureTextEntry = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 52))
        $0.leftView = paddingView
        $0.leftViewMode = .always
    }
    
    private let passwordTextFieldIcon = UIButton().then {
        $0.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        $0.tintColor = UIColor(named: "D9D9D9")
    }
    
    private let passwordCheckTextField = UITextField().then {
        $0.textColor = UIColor(named: "0F1010")
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.attributedPlaceholder = NSAttributedString(
            string: "비밀번호를 한 번 더 입력해주세요",
            attributes: [.foregroundColor: UIColor(named: "D9D9D9")!]
        )
        $0.layer.borderColor = UIColor(named: "D9D9D9")!.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 25
        $0.isSecureTextEntry = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 52))
        $0.leftView = paddingView
        $0.leftViewMode = .always
    }
    
    private let passwordCheckTextFieldIcon = UIButton().then {
        $0.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        $0.tintColor = UIColor(named: "D9D9D9")
    }
    
    // 정보를 확인해 주세요 라벨 (가이드 이미지의 하단 빨간색 에러 메시지)
    private let errorWarningLabel = UILabel().then {
        $0.text = "정보를 확인해주세요"
        $0.textColor = UIColor(named: "FF5757") ?? .red
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    private let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "99DFF9")
        $0.layer.cornerRadius = 25
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.isEnabled = false
    }
    
    @objc func arrowTapped() {
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @objc private func textFieldDidChange() {
        let isNameNotEmpty = !(nameTextField.text?.isEmpty ?? true)
        let isIdNotEmpty = !(idTextField.text?.isEmpty ?? true)
        let isPasswordNotEmpty = !(passwordTextField.text?.isEmpty ?? true)
        let isPasswordCheckNotEmpty = !(passwordCheckTextField.text?.isEmpty ?? true)
        
        // 아이디 입력 여부에 따른 중복확인 버튼 변경
        if isIdNotEmpty {
            idCheckButton.backgroundColor = UIColor(named: "BFEBFB")
            idCheckButton.setTitleColor(UIColor(named: "00688F"), for: .normal)
            idCheckButton.isEnabled = true
        } else {
            idCheckButton.backgroundColor = UIColor(named: "F8F8F8")
            idCheckButton.setTitleColor(UIColor(named: "767778"), for: .normal)
            idCheckButton.isEnabled = false
            idFeedbackLabel.isHidden = true
        }
        
        // 모든 필드가 채워졌을 때 회원가입 버튼 색상 변경 및 활성화
        if isNameNotEmpty && isIdNotEmpty && isPasswordNotEmpty && isPasswordCheckNotEmpty {
            signUpButton.backgroundColor = UIColor(named: "33BEF2")
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor(named: "99DFF9")
            signUpButton.isEnabled = false
        }
    }
    
    @objc private func idCheckButtonTapped() {
        // 임시 중복 확인 토글 로직 (실제 사용 시 서버 통신이나 데이터 체크 배치)
        idFeedbackLabel.isHidden = false
        if idTextField.text == "circle08" {
            // 예시: 이미 존재하는 아이디인 경우 (가이드 5번 화면)
            idFeedbackLabel.text = "중복된 아이디 입니다"
            idFeedbackLabel.textColor = UIColor(named: "FF5757") ?? .red
            errorWarningLabel.isHidden = false // 하단 에러 띄우기
        } else {
            // 예시: 사용 가능한 아이디인 경우 (가이드 6번 화면)
            idFeedbackLabel.text = "사용 가능한 아이디 입니다"
            idFeedbackLabel.textColor = UIColor(named: "4CDC5F") ?? .green
            errorWarningLabel.isHidden = true
        }
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        if sender == passwordTextFieldIcon {
            passwordTextField.isSecureTextEntry.toggle()
            let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
            passwordTextFieldIcon.setImage(UIImage(systemName: imageName), for: .normal)
        } else if sender == passwordCheckTextFieldIcon {
            passwordCheckTextField.isSecureTextEntry.toggle()
            let imageName = passwordCheckTextField.isSecureTextEntry ? "eye.slash" : "eye"
            passwordCheckTextFieldIcon.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    @objc private func signUpButtonTapped() {
            guard let nickname = idTextField.text,
                  let name = nameTextField.text,
                  let password = passwordTextField.text,
                  let passwordConfirm = passwordCheckTextField.text else { return }
            
            if password != passwordConfirm {
                errorWarningLabel.isHidden = false
                return
            }
            
            // Moya 서비스 호출
            authService.signup(nickname: nickname, name: name, password: password, passwordConfirm: passwordConfirm, phone: verifiedPhone) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    print("회원가입 성공! 메인 홈 화면으로 이동합니다.")
                    
                    // 1. 메인 탭바 컨트롤러 생성
                    let mainTabBarVC = RootTabBarController()
                    
                    // 2. 현재 앱의 연결된 Window 찾기 (iOS 13+ SceneDelegate 대응)
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        
                        // 3. 루트 뷰 컨트롤러를 메인 탭바로 교체하며 부드러운 전환 효과 주기
                        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            window.rootViewController = mainTabBarVC
                            window.makeKeyAndVisible()
                        }, completion: nil)
                    }
                    
                case .failure(let error):
                    print("회원가입 실패: \(error.localizedDescription)")
                    self.errorWarningLabel.isHidden = false
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        idTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordCheckTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        idCheckButton.addTarget(self, action: #selector(idCheckButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        passwordTextFieldIcon.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        passwordCheckTextFieldIcon.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let arrow = UIButton().then {
            $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            $0.tintColor = UIColor(named: "0F1010")
            $0.addTarget(self, action: #selector(arrowTapped), for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(24)
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
                $0.leading.equalToSuperview().inset(24)
            }
        }
        
        let titleLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 32, weight: .bold)
            $0.textColor = UIColor(named: "0F1010")
            $0.text = "콜팝"
        }
        let subTitleLabel = UILabel().then {
            $0.text = "빈 건물 찾아 팝업 열기"
            $0.textColor = UIColor(named: "C6C6C7")
            $0.font = .systemFont(ofSize: 20, weight: .bold)
        }
        
        let nameTitle = UILabel().then {
            $0.text = "실명"
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = UIColor(named: "A3A4A5")
        }
        
        let idTitle = UILabel().then {
            $0.text = "아이디"
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = UIColor(named: "A3A4A5")
        }
        
        let passwordTitle = UILabel().then {
            $0.text = "비밀번호"
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = UIColor(named: "A3A4A5")
        }
        let passwordRullText = UILabel().then {
            $0.text = "비밀번호 형식은 ~"
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = UIColor(named: "00AEEF")
        }
        
        let passwordCheckTitle = UILabel().then {
            $0.text = "비밀번호 확인"
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = UIColor(named: "A3A4A5")
        }
        
        let scrollView = UIScrollView()
        let titleView = UIView().then {
            $0.addSubview(titleLabel)
            $0.addSubview(subTitleLabel)
            
            titleLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().inset(36)
                $0.height.equalTo(38)
            }
            subTitleLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(titleLabel.snp.bottom).offset(4)
                $0.height.equalTo(24)
                $0.bottom.equalToSuperview()
            }
        }
        let nameView = UIView().then {
            $0.addSubview(nameTitle)
            $0.addSubview(nameTextField)
            nameTitle.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(32)
                $0.top.equalToSuperview()
                $0.height.equalTo(19)
            }
            nameTextField.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(32)
                $0.top.equalTo(nameTitle.snp.bottom).offset(12)
                $0.height.equalTo(52)
                $0.bottom.equalToSuperview()
            }
        }
        let idView = UIView().then {
            $0.addSubview(idTitle)
            $0.addSubview(idTextField)
            $0.addSubview(idCheckButton)
            $0.addSubview(idFeedbackLabel)
            
            idTitle.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().inset(32)
                $0.height.equalTo(19)
            }
            idTextField.snp.makeConstraints {
                $0.height.equalTo(52)
                $0.leading.trailing.equalToSuperview().inset(32)
                $0.top.equalTo(idTitle.snp.bottom).offset(12)
            }
            idCheckButton.snp.makeConstraints {
                $0.top.equalTo(idTextField.snp.bottom).offset(12)
                $0.trailing.equalToSuperview().inset(32)
                $0.width.equalTo(82)
                $0.height.equalTo(32)
            }
            idFeedbackLabel.snp.makeConstraints {
                $0.top.equalTo(idCheckButton.snp.bottom).offset(8)
                $0.trailing.equalToSuperview().inset(32)
                $0.bottom.equalToSuperview()
            }
        }
        let passwordView = UIView().then {
            $0.addSubview(passwordTitle)
            $0.addSubview(passwordTextField)
            $0.addSubview(passwordRullText)
            $0.addSubview(passwordTextFieldIcon)
            
            passwordTitle.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().inset(32)
                $0.height.equalTo(19)
            }
            passwordTextField.snp.makeConstraints {
                $0.height.equalTo(52)
                $0.leading.trailing.equalToSuperview().inset(32)
                $0.top.equalTo(passwordTitle.snp.bottom).offset(12)
            }
            passwordRullText.snp.makeConstraints {
                $0.top.equalTo(passwordTextField.snp.bottom).offset(12)
                $0.height.equalTo(16)
                $0.bottom.equalToSuperview()
                $0.leading.equalToSuperview().inset(32)
            }
            passwordTextFieldIcon.snp.makeConstraints {
                $0.centerY.equalTo(passwordTextField)
                $0.trailing.equalTo(passwordTextField).inset(18)
                $0.height.width.equalTo(21)
            }
        }
        let passwordCheckView = UIView().then {
            $0.addSubview(passwordCheckTitle)
            $0.addSubview(passwordCheckTextField)
            $0.addSubview(passwordCheckTextFieldIcon)
            
            passwordCheckTitle.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().inset(32)
                $0.height.equalTo(19)
            }
            passwordCheckTextField.snp.makeConstraints {
                $0.height.equalTo(52)
                $0.leading.trailing.equalToSuperview().inset(32)
                $0.top.equalTo(passwordCheckTitle.snp.bottom).offset(12)
                $0.bottom.equalToSuperview()
            }
            passwordCheckTextFieldIcon.snp.makeConstraints {
                $0.centerY.equalTo(passwordCheckTextField)
                $0.trailing.equalTo(passwordCheckTextField).inset(18)
                $0.height.width.equalTo(21)
            }
        }
        let signUpButtonView = UIView().then {
            $0.addSubview(errorWarningLabel)
            $0.addSubview(signUpButton)
            
            errorWarningLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.leading.trailing.equalToSuperview().inset(32)
            }
            signUpButton.snp.makeConstraints {
                $0.top.equalTo(errorWarningLabel.snp.bottom).offset(20)
                $0.height.equalTo(52)
                $0.leading.trailing.equalToSuperview().inset(32)
                $0.bottom.equalToSuperview().inset(40)
            }
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleView, nameView, idView, passwordView, passwordCheckView, signUpButtonView]).then {
            $0.axis = .vertical
            $0.spacing = 36
            $0.distribution = .fill
            $0.alignment = .fill
        }
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(arrow.snp.bottom).offset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
}

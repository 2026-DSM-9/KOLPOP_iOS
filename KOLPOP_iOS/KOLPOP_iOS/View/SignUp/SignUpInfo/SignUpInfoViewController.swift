import UIKit
import SnapKit
import Then

class SignUpInfoViewController : UIViewController {
    @objc func arrowTapped() {
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        let nameTextField = UITextField().then {
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
        
        let idTitle = UILabel().then {
            $0.text = "아이디"
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = UIColor(named: "A3A4A5")
        }
        let idTextField = UITextField().then {
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
        let idCheckButton = UIButton().then {
            $0.setTitle("중복확인", for: .normal)
            $0.setTitleColor(UIColor(named: "767778"), for: .normal)
            $0.backgroundColor = UIColor(named: "F8F8F8")
            $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            $0.layer.cornerRadius = 16
        }
        
        let passwordTitle = UILabel().then {
            $0.text = "비밀번호"
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = UIColor(named: "A3A4A5")
        }
        let passwordTextField = UITextField().then {
            $0.textColor = UIColor(named: "0F1010")
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.attributedPlaceholder = NSAttributedString(
                string: "비밀번호를 입력해주세요",
                attributes: [.foregroundColor: UIColor(named: "D9D9D9")!]
            )
            $0.layer.borderColor = UIColor(named: "D9D9D9")!.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 25
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 52))
            $0.leftView = paddingView
            $0.leftViewMode = .always
        }
        let passwordRullText = UILabel().then {
            $0.text = "비밀번호 형식은 ~"
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = UIColor(named: "00AEEF")
        }
        let passwordTextFieldIcon = UIButton().then {
            $0.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            $0.tintColor = UIColor(named: "D9D9D9")
        }
        
        let passwordCheckTitle = UILabel().then {
            $0.text = "비밀번호 확인"
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = UIColor(named: "A3A4A5")
        }
        let passwordCheckTextField = UITextField().then {
            $0.textColor = UIColor(named: "0F1010")
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.attributedPlaceholder = NSAttributedString(
                string: "비밀번호를 한 번 더 입력해주세요",
                attributes: [.foregroundColor: UIColor(named: "D9D9D9")!]
            )
            $0.layer.borderColor = UIColor(named: "D9D9D9")!.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 25
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 52))
            $0.leftView = paddingView
            $0.leftViewMode = .always
        }
        let passwordCheckTextFieldIcon = UIButton().then {
            $0.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            $0.tintColor = UIColor(named: "D9D9D9")
        }
        
        let signUpButton = UIButton().then {
            $0.setTitle("회원가입", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = UIColor(named: "99DFF9")
            $0.layer.cornerRadius = 25
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
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
            $0.addSubview(signUpButton)
            signUpButton.snp.makeConstraints {
                $0.top.equalToSuperview() // ⭐️ 상단 고정 추가
                $0.height.equalTo(52)
                $0.leading.trailing.equalToSuperview().inset(32)
                $0.bottom.equalToSuperview().inset(40) // ⭐️ 밑부분을 완전히 닫아줌 (스크롤 하단 여백 확보)
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

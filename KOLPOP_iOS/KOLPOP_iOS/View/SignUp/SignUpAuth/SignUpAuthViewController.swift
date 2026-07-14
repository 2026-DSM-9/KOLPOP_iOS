import UIKit
import SnapKit
import Then

final class SignUpAuthViewController: UIViewController {
    
    @objc func nextButtonDidTap() {
        let signUpInfoViewController = SignUpInfoViewController()
        signUpInfoViewController.modalPresentationStyle = .fullScreen
        present(signUpInfoViewController, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let arrow = UIButton().then {
            $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            $0.tintColor = UIColor(named: "0F1010")
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
        
        let phoneTitle = UILabel().then {
            $0.text = "전화번호"
            $0.textColor = UIColor(named: "A3A4A5")
            $0.font = .systemFont(ofSize: 16, weight: .regular)
        }
        let phoneTextField = UITextField().then {
            $0.textColor = UIColor(named: "0F1010")
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.attributedPlaceholder = NSAttributedString(
                string: "전화번호를 입력해 주세요",
                attributes: [.foregroundColor: UIColor(named: "D9D9D9")!]
            )
            $0.layer.borderColor = UIColor(named: "D9D9D9")!.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 25
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 52))
            $0.leftView = paddingView
            $0.leftViewMode = .always
        }
        let sendCodeButton = UIButton().then {
            $0.setTitle("인증 코드 발송", for: .normal)
            $0.setTitleColor(UIColor(named: "767778"), for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            $0.backgroundColor = UIColor(named: "F8F8F8")
            $0.layer.cornerRadius = 16
        }
        let codeTitle = UILabel().then {
            $0.text = "인증코드"
            $0.textColor = UIColor(named: "A3A4A5")
            $0.font = .systemFont(ofSize: 16, weight: .regular)
        }
        let codeTextField = UITextField().then {
            $0.textColor = UIColor(named: "0F1010")
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.attributedPlaceholder = NSAttributedString(
                string: "인증코드를 입력해주세요",
                attributes: [.foregroundColor: UIColor(named: "D9D9D9")!]
            )
            $0.layer.borderColor = UIColor(named: "D9D9D9")!.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 25
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 52))
            $0.leftView = paddingView
            $0.leftViewMode = .always
        }
        
        let titleView = UIView().then {
            $0.addSubview(titleLabel)
            $0.addSubview(subTitleLabel)
            
            titleLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().inset(40)
                $0.height.equalTo(38)
            }
            subTitleLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(titleLabel.snp.bottom).offset(4)
                $0.height.equalTo(24)
                $0.bottom.equalToSuperview()
            }
        }
        let inputView = UIView().then {
            $0.addSubview(phoneTitle)
            $0.addSubview(phoneTextField)
            $0.addSubview(sendCodeButton)
            $0.addSubview(codeTitle)
            $0.addSubview(codeTextField)
            
            phoneTitle.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(32)
                $0.height.equalTo(19)
            }
            phoneTextField.snp.makeConstraints {
                $0.height.equalTo(52)
                $0.leading.trailing.equalToSuperview().inset(32)
                $0.top.equalTo(phoneTitle.snp.bottom).offset(12)
            }
            sendCodeButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(32)
                $0.top.equalTo(phoneTextField.snp.bottom).offset(12)
                $0.width.equalTo(113)
                $0.height.equalTo(32)
            }
            codeTitle.snp.makeConstraints {
                $0.top.equalTo(sendCodeButton.snp.bottom).offset(12)
                $0.leading.equalToSuperview().inset(32)
                $0.height.equalTo(19)
            }
            codeTextField.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(32)
                $0.top.equalTo(codeTitle.snp.bottom).offset(12)
                $0.height.equalTo(52)
                $0.bottom.equalToSuperview()
            }
        }
        let codeCheckText = UILabel().then {
            $0.text = "인증코드를 확인해주세요"
            $0.textColor = UIColor(named: "FF5757")
            $0.font = .systemFont(ofSize: 16)
            $0.textAlignment = .center
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleView, inputView]).then {
            $0.axis = .vertical
            $0.spacing = 36
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.leading.trailing.equalToSuperview()
        }
        
        let nextButton = UIButton().then {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            $0.backgroundColor = UIColor(named: "99DFF9")
            $0.layer.cornerRadius = 26
            $0.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(32)
                $0.top.equalTo(stackView.snp.bottom).offset(36)
                $0.height.equalTo(52)
            }
        }
    }
}

//
//  SignUpViewController.swift
//  KOLPOP_iOS
//
//  Created by Seoyun Jin on 7/13/26.
//
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
        }
        view.addSubview(arrow)
        arrow.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.equalToSuperview().offset(71)
            $0.leading.equalToSuperview().inset(24)
        }
        
    }
    
}

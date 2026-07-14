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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let arrow = UIImageView().then {
            $0.image = UIImage(systemName: "arrow.left")
            $0.tintColor = UIColor(named: "0F1010")
        }
        view.addSubview(arrow)
        arrow.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.equalToSuperview().offset(71)
            $0.leading.equalToSuperview().inset(24)
        }
        
    }
    
}

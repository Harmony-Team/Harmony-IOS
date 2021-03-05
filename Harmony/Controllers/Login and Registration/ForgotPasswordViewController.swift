//
//  ForgotPasswordViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 22.02.2021.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    var viewModel: ForgotPasswordViewModel!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var continueButton: LoginButtonStyle!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBg(image: UIImage(named: "loginBg2")!, alpha: 0.22)
        
        setupForm()
    }
    
    private func setupForm() {
        emailTextField.setGradientStack(colorTop: UIColor.gradientColorTop.cgColor,
                                        colorBottom: UIColor.gradientColorBottom.cgColor,
                                        cornerRadius: 15)
        emailTextField.setupLoginFormFields()
        
        continueButton.isEnabled = false
        continueButton.layer.cornerRadius = continueButton.frame.width / 2
        continueButton.backgroundColor = .buttonColor
        
        dontHaveAccountButton.titleLabel?.font = UIFont.setFont(size: .Medium)
        dontHaveAccountButton.titleLabel?.addKern(1.74)
        
        let arrowImage = UIImage(named: "right-arrow-white")
        let arrImageView = UIImageView(image: arrowImage)
        arrImageView.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addSubview(arrImageView)
        
        NSLayoutConstraint.activate([
            arrImageView.centerXAnchor.constraint(equalTo: continueButton.centerXAnchor),
            arrImageView.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor),
            arrImageView.widthAnchor.constraint(equalTo: continueButton.widthAnchor, multiplier: 0.25),
            arrImageView.heightAnchor.constraint(equalTo: arrImageView.widthAnchor)
        ])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.viewDidDisappear()
    }
    
    
    @IBAction func continueTapped(_ sender: UIButton) {
    }
}

//
//  ForgotPasswordViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 22.02.2021.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    var viewModel: ForgotPasswordViewModel!

    @IBOutlet weak var emailTextField: LoginTextFieldStyle!
    @IBOutlet weak var continueButton: LoginButtonStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBg(image: UIImage(named: "loginBg2")!, alpha: 0.22)
        
        setupForm()
    }
    
    private func setupForm() {
//        emailTextField.layer.borderWidth = 1
//        emailTextField.layer.borderColor = UIColor.white.cgColor
//        emailTextField.layer.cornerRadius = 15
        emailTextField.setGradientStack(colorTop: UIColor.gradientColorTop.cgColor,
                                        colorBottom: UIColor.gradientColorBottom.cgColor,
                                        cornerRadius: 15)
        
        continueButton.isEnabled = false
        continueButton.layer.cornerRadius = continueButton.frame.width / 2
        continueButton.backgroundColor = .buttonColor
        
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

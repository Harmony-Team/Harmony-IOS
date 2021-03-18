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
        
        // Move View With Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Hide keyboard after tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        addBg(image: UIImage(named: "loginBg2"), colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 0.22)
        
        setupForm()
    }
    
    private func setupForm() {
        emailTextField.setGradientStack(colorTop: UIColor.gradientColorTop.cgColor,
                                        colorBottom: UIColor.gradientColorBottom.cgColor,
                                        cornerRadius: 15, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0))
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
    
    /* Keyboard moving */
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
                self.continueButton.frame.origin.y -= keyboardSize.height / 4
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0, let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
            self.continueButton.frame.origin.y += keyboardSize.height / 4
        }
    }
    
    // Hide keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

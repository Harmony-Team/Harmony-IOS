//
//  LoginViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit
import VK_ios_sdk

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel!
    
    /* Spotify */
    
    
    @IBOutlet weak var userNameTextField: LoginTextFieldStyle!
    @IBOutlet weak var passwordTextField: LoginTextFieldStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        passwordTextField.isSecureTextEntry = true
        setupPasswordEye()
    
    }
    
    private func setupPasswordEye() {
        let eyeButton = UIButton()
        eyeButton.setImage(UIImage(named: "eye"), for: .normal)
        eyeButton.tintColor = .gray
        eyeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 15)
        eyeButton.addTarget(self, action: #selector(togglePasswordText), for: .touchUpInside)
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .whileEditing
    }
    
    @objc private func togglePasswordText() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    /* Go to register form */
    @IBAction func goToSignIn(_ sender: UIButton) {
        viewModel.goToSignIn()
    }
    
    /* Go to forgot password view */
    @IBAction func goToForgotPassword(_ sender: UIButton) {
        viewModel.goToForgotPassword()
    }
}

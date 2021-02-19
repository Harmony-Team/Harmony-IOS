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
    @IBOutlet weak var signInButton: LoginButtonStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupForm()
        setupPasswordEye()
    }
    
    private func setupForm() {
        passwordTextField.isSecureTextEntry = true
        userNameTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        signInButton.isEnabled = false
        signInButton.backgroundColor = .darkMainColor
    }
    
    @objc private func textChanged(_ textField: UITextField) {
        let filteredArray = [userNameTextField, passwordTextField].filter { $0?.text == "" }
        if filteredArray.isEmpty {
            signInButton.isEnabled = true
            signInButton.backgroundColor = .mainColor
        } else {
            signInButton.isEnabled = false
            signInButton.backgroundColor = .darkMainColor
        }
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
    
    /* Login user */
    @IBAction func signIn(_ sender: UIButton) {
        guard let username = userNameTextField.text, let password = passwordTextField.text else {return}
        let user = LoginUser(username: username, password: password)
        
        /* Try Login User */
        showActivityIndicator()
        DispatchQueue.main.async {
            self.viewModel.loginUser(user: user) { (result) in
                switch result {
                case .success(let msg):
                    if let msg = msg {
                        self.callAlert(with: msg)
                    }
                    break
                case .failure( _):
                    print("ERROR")
                    break
                }
                self.hideActivityIndicator()
            }
        }
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

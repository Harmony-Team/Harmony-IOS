//
//  RegistrationViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    var viewModel: RegisterViewModel!
    
    /* Error View */
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorTitle: UILabel!
    @IBOutlet weak var errorDescr: UILabel!
    
    /* Form Fields + Button */
    @IBOutlet weak var userNameTextField: LoginTextFieldStyle!
    @IBOutlet weak var emailTextField: LoginTextFieldStyle!
    @IBOutlet weak var passwordTextField: LoginTextFieldStyle!
    @IBOutlet weak var signUpButton: LoginButtonStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupError()
        setupForm()
        setupPasswordEye()
    }
    
    /* Setting up form fields and button */
    private func setupForm() {
//        userNameTextField.delegate = self
        signUpButton.backgroundColor = .darkMainColor
        signUpButton.isEnabled = false
        userNameTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
    }
    
    /* Setting up error view */
    private func setupError() {
        errorView.isHidden = true
        errorView.layer.cornerRadius = 10
    }
    
    private func callAlert(with msg: String) {
        let alert = UIAlertController(title: msg, message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func textChanged(_ textField: UITextField) {
        let filteredArray = [userNameTextField, emailTextField, passwordTextField].filter { $0?.text == "" }
        if filteredArray.isEmpty {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .mainColor
            let (valid, message) = validate(textField)
            errorDescr.text = message
            
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
                self.errorView.isHidden = valid
            })
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .darkMainColor
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    /* Setting up password text field eye icon */
    private func setupPasswordEye() {
        let eyeButton = UIButton()
        eyeButton.setImage(UIImage(named: "eye"), for: .normal)
        eyeButton.tintColor = .gray
        eyeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 15)
        eyeButton.addTarget(self, action: #selector(togglePasswordText), for: .touchUpInside)
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
    }
    
    /* Show/Hide password */
    @objc private func togglePasswordText() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    /* Register button tapped */
    @IBAction func signIn(_ sender: UIButton) {
        checkTextFields()
    }
    
    /* Validate text fields */
    private func checkTextFields() {
        guard let name = userNameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {return}
        
        let user = User(username: name, email: email, password: password)
        
        registerUser(user: user)
//        viewModel.goToServices(with: user)
    }
    
    /* Register user and go to services */
    private func registerUser(user: User) {
        APIManager.shared.callRegisterAPI(register: user, completion: { msg in
            if msg != "" {
                self.callAlert(with: msg)
            } else {
                
                UserDefaults.standard.setValue(true, forKey: "isLoggedIn")

                UserProfileCache.save(user, "user")
                self.viewModel.goToServices(with: user)
            }
        })
    }
    
    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        
        if textField == userNameTextField {
            return (text.count >= 3, "Username must include at least 3 symbols")
        }
        
        if textField == emailTextField {
            
            return (text.count >= 3, "Email must include at least 3 symbols")
        }
        
        if textField == passwordTextField {
            return (text.count >= 6, "Password must include at least 6 symbols")
        }
        
        return (text.count > 0, "This field cannot be empty.")
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Validate Text Field
        let (valid, message) = validate(textField)
        
        if valid {
            emailTextField.becomeFirstResponder()
        }
        
        // Update Password Validation Label
        errorDescr.text = message
        
        // Show/Hide Password Validation Label
        UIView.animate(withDuration: 0.25, animations: {
            self.errorView.isHidden = valid
        })
        
        
        return true
    }
    
}

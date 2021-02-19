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
        
        // Move View With Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Hide keyboard after tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupError()
        setupForm()
        setupPasswordEye()
    }
    
    /* Setting up form fields and button */
    private func setupForm() {
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
    
    @objc private func textChanged(_ textField: UITextField) {
        let filteredArray = [userNameTextField, emailTextField, passwordTextField].filter { $0?.text == "" }
        if filteredArray.isEmpty {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .mainColor
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
        
        if !getValidationErrors(textField: userNameTextField) ||
            !getValidationErrors(textField: emailTextField) ||
            !getValidationErrors(textField: passwordTextField) {
            return
        }
        
        let user = RegisterUser(login: name, email: email, password: password)
        
        /* Try Register User */
        showActivityIndicator()
        DispatchQueue.main.async {
            self.viewModel.registerUser(user: user) { (result) in
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
    
    /* Keyboard moving */
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // Hide keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension RegistrationViewController {
    
    func getValidationErrors(textField: UITextField) -> Bool {
        // Validate Text Field
        let (valid, message) = validate(textField)
        
        // Update Password Validation Label
        errorDescr.text = message
        
        // Show/Hide Password Validation Label
        UIView.animate(withDuration: 0.25, animations: {
            self.errorView.isHidden = valid
        })
        
        return valid
    }
    
    /* Form fields validation */
    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        
        if textField == userNameTextField {
            if text.count < 4 {
                return (false, "Username must include at least 4 symbols")
            }
            if text.count > 15 {
                return (false, "Username mustn't include more than 15 symbols")
            }
            return (viewModel.isValidUsername(name: text), "You have entered an invalid username")
        }
        
        if textField == emailTextField {
            if text.count < 4 {
                return (false, "Email must include at least 4 symbols")
            }
            if text.count > 32 {
                return (false, "Email mustn't include more than 32 symbols")
            }
            return (viewModel.isValidEmail(email: text), "You have entered an invalid email address")
        }
        
        if textField == passwordTextField {
            if text.count < 8 {
                return (false, "Password must include at least 8 symbols")
            }
            if text.count > 32 {
                return (false, "Password mustn't include more than 32 symbols")
            }
            return (viewModel.isValidPassword(password: text), "You have entered an invalid password")
        }
        
        return (text.count > 0, "This field cannot be empty.")
    }
    
}

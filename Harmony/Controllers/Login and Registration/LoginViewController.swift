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
    var keyboardSize: CGRect?
    
    /* Spotify */
    
    /* Error View */
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorTitle: UILabel!
    @IBOutlet weak var errorDescr: UILabel!
    
    /* Form Fields + Button */
    @IBOutlet weak var signInToContinueLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: LoginButtonStyle!
    @IBOutlet weak var fieldsView: UIView!
    @IBOutlet weak var fieldsStack: UIStackView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var authorizeWithLabel: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    @IBOutlet weak var signInButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Move View With Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Hide keyboard after tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        addBg(image: UIImage(named: "bg1"), colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 0.22)
        setupError()
        setupForm()
        setupPasswordEye()
    }
    
    private func setupForm() {
        fieldsView.setGradientStack(colorTop: UIColor.gradientColorTop.cgColor,
                                    colorBottom: UIColor.gradientColorBottom.cgColor,
                                    cornerRadius: 15, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0))
        
        passwordTextField.isSecureTextEntry = true
        userNameTextField.addBottomBorder(height: 1.5, color: .white)
        
        [userNameTextField, passwordTextField].forEach { $0?.setupLoginFormFields() }
        
        forgotPasswordButton.titleLabel?.font = UIFont.setFont(size: .Small)
        forgotPasswordButton.titleLabel?.addKern(1.74)
        
        authorizeWithLabel.titleLabel?.font = UIFont.setFont(size: .Small)
        authorizeWithLabel.titleLabel?.addKern(1.74)
        
        signInToContinueLabel.font = UIFont.setFont(size: .Big)
        signInToContinueLabel.addKern(1.74)
        
        dontHaveAccountButton.titleLabel?.font = UIFont.setFont(size: .Medium)
        dontHaveAccountButton.titleLabel?.addKern(1.74)
        
        signInButton.titleLabel?.font = UIFont.setFont(size: .Big)
        signInButton.layer.cornerRadius = signInButton.frame.width / 2
        signInButton.backgroundColor = .buttonColor
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
//            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            signInButton.bottomAnchor.constraint(equalTo: dontHaveAccountButton.topAnchor, constant: -30),
//            signInButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
//            signInButton.widthAnchor.constraint(equalTo: signInButton.heightAnchor)
//        ])
    }
    
    /* Setting up error view */
    private func setupError() {
        errorView.isHidden = true
        errorView.layer.cornerRadius = 10
        [errorTitle, errorDescr].forEach { $0?.font = UIFont.setFont(size: .Medium) }
    }
    
    private func setupPasswordEye() {
        let eyeButton = UIButton()
        let eyeImage = UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate)
        eyeButton.setImage(eyeImage, for: .normal)
        eyeButton.tintColor = .white
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
        checkTextFields()
    }
    
    /* Validate text fields */
    private func checkTextFields() {
        
        if !getValidationErrors(textField: userNameTextField) ||
            !getValidationErrors(textField: passwordTextField) {
            return
        }
        
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
    
    /* Authorize With Spotify */
    @IBAction func authorizeWithSpotify(_ sender: UIButton) {
        
    }
    
    /* Go to register form */
    @IBAction func goToSignIn(_ sender: UIButton) {
        viewModel.goToSignIn()
    }
    
    /* Go to forgot password view */
    @IBAction func goToForgotPassword(_ sender: UIButton) {
        viewModel.goToForgotPassword()
    }
    
    /* Keyboard moving */
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
                signInButtonBottomConstraint.constant = keyboardSize.height / 3
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        signInButtonBottomConstraint.constant = 30
    }
    
    // Hide keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController {
    
    func getValidationErrors(textField: UITextField) -> Bool {
        // Validate Text Field
        let (valid, message) = validate(textField)
        
        // Update Password Validation Label
        errorDescr.text = message
        
        // Show/Hide Password Validation Label
        UIView.animate(withDuration: 0.25, animations: {
            self.errorView.isHidden = valid
            // If Error
            if !valid {
                self.fieldsView.shakeAnimation()
            } else {
                self.dismissKeyboard()
            }
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
        }
        
        if textField == passwordTextField {
            if text.count < 8 {
                return (false, "Password must include at least 8 symbols")
            }
            if text.count > 32 {
                return (false, "Password mustn't include more than 32 symbols")
            }
        }
        
        return (text.count > 0, "This field cannot be empty.")
    }
    
}

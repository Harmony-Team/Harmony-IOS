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
    @IBOutlet weak var signUpToContinue: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: LoginButtonStyle!
    @IBOutlet weak var fieldsView: UIView!
    @IBOutlet weak var fieldsStack: UIStackView!
    @IBOutlet weak var haveAccountButton: UIButton!
    @IBOutlet weak var signUpButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Move View With Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Hide keyboard after tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        addBg(image: UIImage(named: "bg2"), colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 0.22)
        
        setupError()
        setupForm()
        setupPasswordEye()
    }
    
    /* Setting up form fields and button */
    private func setupForm() {
        fieldsView.setGradientStack(colorTop: UIColor.gradientColorTop.cgColor,
                                    colorBottom: UIColor.gradientColorBottom.cgColor,
                                    cornerRadius: 15, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0))
        
        userNameTextField.addBottomBorder(height: 1.5, color: .white)
        emailTextField.addBottomBorder(height: 1.5, color: .white)
        
        [userNameTextField, emailTextField, passwordTextField].forEach { $0?.setupLoginFormFields() }
        
        signUpToContinue.font = UIFont.setFont(size: .Big)
        signUpToContinue.addKern(1.74)
        
        haveAccountButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 14)!)
        haveAccountButton.titleLabel?.addKern(1.74)
                
        signUpButton.titleLabel?.font = UIFont.setFont(size: .Big)
        signUpButton.layer.cornerRadius = signUpButton.frame.width / 2
        signUpButton.backgroundColor = .buttonColor
    }
    
    /* Setting up error view */
    private func setupError() {
        errorView.isHidden = true
        errorView.layer.cornerRadius = 10
        [errorTitle, errorDescr].forEach { $0?.font = UIFont.setFont(size: .Medium) }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    /* Setting up password text field eye icon */
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
        
        if !getValidationErrors(textField: userNameTextField) ||
            !getValidationErrors(textField: emailTextField) ||
            !getValidationErrors(textField: passwordTextField) {
            return
        }
        
        guard let name = userNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else {return}
        
        let user = RegisterUser(login: name, email: email, password: password)
        
        /* Try Register User */
        DispatchQueue.main.async {
            self.showActivityIndicator()
        }
        self.viewModel.registerUser(user: user) { (result) in
            switch result {
            case .success(let msg):
                if let msg = msg {
                    DispatchQueue.main.async {
                        self.callAlert(with: msg)
                    }
                }
                break
            case .failure( _):
                print("ERROR")
                break
            }
        }
        DispatchQueue.main.async {
            self.hideActivityIndicator()
        }
    }
    
    /* Keyboard moving */
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
                signUpButtonBottomConstraint.constant = keyboardSize.height / 3
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        signUpButtonBottomConstraint.constant = 30
    }
    
    // Hide keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func goToLogin(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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

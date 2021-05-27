//
//  LoginViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit
import WebKit

enum LoginRegisterMode {
    case Login
    case Register
    case ForgorPassword
}

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel!
    private var loginUser: LoginUser?
    private var registerUser: RegisterUser?
    private var loginRegisterStatus: LoginRegisterMode = .Login
    private var keyboardSize: CGRect?
    private var originalButtonFontSize: CGFloat?
    private var gradient: CAGradientLayer!
    private var shape: CAShapeLayer!
    
    /* Variables For Animation */
    private var buttonTitle: String!
    private var downButtonTitle: String!
    private var continueLabelText: String!
    private var signInButtonFontMultiplier: CGFloat!
    private var bgLeadConstant: CGFloat!
    private var formHeightMultiplier: CGFloat!
    private var authItemsAplha: CGFloat!

    /* Spotify */
    private var spotifyWebView: WKWebView!
    
    /* Error View */
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorTitle: UILabel!
    @IBOutlet weak var errorDescr: UILabel!
    
    /* Form Fields + Button */
    @IBOutlet weak var topLogoImage: UIImageView!
    @IBOutlet weak var signInToContinueLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: LoginButtonStyle!
    @IBOutlet weak var fieldsView: UIView!
    @IBOutlet weak var fieldsStack: UIStackView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var authorizeWithLabel: UIButton!
    @IBOutlet weak var spotifyAuthButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    
    /* Constraints */
    @IBOutlet weak var formStackHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInButtonBottomConstraint: NSLayoutConstraint!
    
    /* Background Image */
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var bgLeadingConstraint: NSLayoutConstraint!
    
    /* CollectionView For Fields And Buttons */
    private var contentCollectionView: UICollectionView!
    
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
        
//        addBg(image: UIImage(named: "bg1"), colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 0.22)
        setupError()
        setupForm()
        setupPasswordEye()
//        setupCollectionView()

        bgImageView.alpha = 0.22
        addGradientToImage(colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom)
    }
    
    private func setupForm() {
        fieldsView.setGradientStack(colorTop: UIColor.gradientColorTop.cgColor,
                                    colorBottom: UIColor.gradientColorBottom.cgColor,
                                    cornerRadius: 15, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0)) { (shape, gradient) in
            self.gradient = gradient
            self.shape = shape
        }
        
        passwordTextField.isSecureTextEntry = true
        userNameTextField.addBottomBorder(height: 1.5, color: .white)
        emailTextField.addBottomBorder(height: 1.5, color: .white)
        
        [userNameTextField, emailTextField, passwordTextField].forEach { $0?.setupLoginFormFields() }
        
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
        originalButtonFontSize = self.signInButton.titleLabel?.font.pointSize
    }
    
    private func setupCollectionView() {
        contentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        contentCollectionView.backgroundColor = .red
        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentCollectionView)
        
        NSLayoutConstraint.activate([
            contentCollectionView.topAnchor.constraint(equalTo: topLogoImage.bottomAnchor, constant: 5),
            contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentCollectionView.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -5)
        ])
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

        // Check Email Field If It Is Registration Mode
        if loginRegisterStatus == .Register {
            if !getValidationErrors(textField: emailTextField) {
                return
            }
        }

        guard let username = userNameTextField.text, let password = passwordTextField.text, let email = emailTextField.text else {return}

        if loginRegisterStatus == .Login { loginUser = LoginUser(username: username, password: password) }
        else { registerUser = RegisterUser(login: username, email: email, password: password) }
            
        /* Try Login Or Register User */
        DispatchQueue.main.async {
            self.animateSignButton()
        }
        if loginRegisterStatus == .Login { doLoginUser() }
        else { doRegisterUser() }

        DispatchQueue.main.async {
            self.hideActivityIndicator()
        }
    }
    
    /* Login User */
    private func doLoginUser() {
        self.viewModel.loginUser(user: loginUser!) { (result) in
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
    }
    
    /* Register User */
    private func doRegisterUser() {
        self.viewModel.registerUser(user: registerUser!) { (result) in
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
    }
    
    /* Authorize With Spotify */
    @IBAction func authorizeWithSpotify(_ sender: UIButton) {
        spotifyWebView = WKWebView()
        spotifyAuthVC(spotifyWebView: spotifyWebView)
    }
    
    /* Go to register form */
    @IBAction func goToSignIn(_ sender: UIButton) {
        buttonTitle = loginRegisterStatus == .Login ? "Sign up" : "Sign in"
        continueLabelText = loginRegisterStatus == .Login ? "SIGN UP TO CONTINUE" : "SIGN IN TO CONTINUE"
        downButtonTitle = loginRegisterStatus == .Login ? "ALREADY HAVE AN ACCOUNT?" : "DONT HAVE AN ACCOUNT?"
        bgLeadConstant = loginRegisterStatus == .Login ? -bgImageView.frame.width / 2 : 0
        formHeightMultiplier = loginRegisterStatus == .Login ? 0.225 : 0.15
        authItemsAplha = loginRegisterStatus == .Login ? 0 : 1
        loginRegisterStatus = loginRegisterStatus == .Login ? .Register : .Login
        
        if loginRegisterStatus == .ForgorPassword { animateTransition(to: .ForgorPassword) }
        else { animateTransition() }
    }
    
    /* Go to forgot password view */
    @IBAction func goToForgotPassword(_ sender: UIButton) {
//        buttonTitle = loginRegisterStatus == .Login ? "Sign up" : "Sign in"
//        continueLabelText = loginRegisterStatus == .Login ? "" : "SIGN IN TO CONTINUE"
//        downButtonTitle = loginRegisterStatus == .Login ? "CANCEL" : "DONT HAVE AN ACCOUNT?"
//        bgLeadConstant = loginRegisterStatus == .Login ? -bgImageView.frame.width / 2 : 0
//        formHeightMultiplier = loginRegisterStatus == .Login ? 0.075 : 0.15
//        authItemsAplha = loginRegisterStatus == .Login ? 0 : 1
//        loginRegisterStatus = loginRegisterStatus == .Login ? .ForgorPassword : .Login
//
//        animateTransition(to: .ForgorPassword)
        viewModel.goToForgotPassword()
    }
}

/* Animation */
extension LoginViewController {
    private func animateTransition(to mode: LoginRegisterMode = .Login) {
        
        var newShapePath: CGPath!
        let animationDuration: TimeInterval = 0.4
        
        UIView.animate(withDuration: animationDuration) {
            self.bgLeadingConstraint.constant = self.bgLeadConstant
            self.signInButton.setTitle(self.buttonTitle, for: .normal)
            self.dontHaveAccountButton.setTitle(self.downButtonTitle, for: .normal)
            self.signInToContinueLabel.animateTextChange(duration: CGFloat(animationDuration), newText: self.continueLabelText)
            self.emailTextField.isHidden = !self.emailTextField.isHidden
            if mode == .ForgorPassword {
                self.userNameTextField.isHidden = !self.userNameTextField.isHidden
                self.passwordTextField.isHidden = !self.passwordTextField.isHidden
            }
            [self.forgotPasswordButton, self.authorizeWithLabel, self.spotifyAuthButton].forEach {
                $0?.alpha = self.authItemsAplha
            }
                        
            let newConstraint = self.formStackHeightConstraint.constraintWithMultiplier(self.formHeightMultiplier)
            self.view.removeConstraint(self.formStackHeightConstraint)
            self.view.addConstraint(newConstraint)
            self.formStackHeightConstraint = newConstraint
            self.view.layoutIfNeeded()
            
            newShapePath = UIBezierPath(roundedRect: self.fieldsView.bounds.insetBy(dx: 1, dy: 1), cornerRadius: 15).cgPath
                    
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = animationDuration
            animation.toValue = newShapePath
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            self.gradient.frame = CGRect(origin: CGPoint.zero, size: self.fieldsView.frame.size)

            self.shape.add(animation, forKey: "path")
        } completion: { (_) in
            self.shape.path = newShapePath
        }
    }
    
    private func animateSignButton() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        self.showActivityIndicator()
    }
}

/* Web View */
extension LoginViewController {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        viewModel.requestForCallbackURL(request: navigationAction.request) {
            self.dismiss(animated: true, completion: nil)
        }
        
        decisionHandler(.allow)
    }
}

/* Errors Validation */
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

/* Keyboard Ext */
extension LoginViewController {
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

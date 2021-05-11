//
//  JoinGroupViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 11.05.2021.
//

import UIKit

class JoinGroupViewController: UIViewController {

    var viewModel: JoinGroupViewModel!
    
    var bottomLine = UIView()
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var joinGroupLabel: UILabel!
    @IBOutlet weak var groupLinkField: UITextField!
    @IBOutlet weak var joinButton: LoginButtonStyle!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Move View With Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Hide keyboard after tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        customizeNavBarController(bgColor: .white, textColor: .mainTextColor)
        
        setupTopView()
        setupButtons()
        setupFields()
    }
    
    /* Setting Up TopView */
    private func setupTopView() {
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor.mainTextColor.cgColor
        topView.layer.cornerRadius = 15
        joinGroupLabel.font = UIFont.setFont(size: .Medium)
        joinGroupLabel.textColor = .mainTextColor
    }
    
    /* Setting up buttons */
    private func setupButtons() {
        joinButton.titleLabel?.font = UIFont.setFont(size: .Medium)
        joinButton.titleLabel?.addKern(1.74)
        joinButton.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: joinButton.frame.height / 2.5, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
        
        cancelButton.titleLabel?.font = UIFont.setFont(size: .Small)
        cancelButton.titleLabel?.addKern(1.74)
        cancelButton.titleLabel?.tintColor = .mainTextColor
        
        bottomLine.backgroundColor = .lightGray
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomLine)
        NSLayoutConstraint.activate([
            bottomLine.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 5),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            bottomLine.widthAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1.05),
            bottomLine.centerXAnchor.constraint(equalTo: cancelButton.centerXAnchor)
        ])
    }
    
    /* Setting up fields */
    private func setupFields() {
        groupLinkField?.font = UIFont.setFont(size: .ExtraLarge)
        groupLinkField?.defaultTextAttributes.updateValue(1.74, forKey: NSAttributedString.Key.kern)
        groupLinkField?.textColor = .mainTextColor
        groupLinkField?.attributedPlaceholder = NSAttributedString(string: groupLinkField?.placeholder ?? "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.mainTextColor.cgColor,
            NSAttributedString.Key.kern: 1.74
        ])
    }

    @IBAction func joinGroup(_ sender: UIButton) {
        guard let codeText = groupLinkField?.text, !codeText.isEmpty else {
            groupLinkField?.shakeAnimation()
            return
        }
        viewModel.joinGroupByCode(code: codeText) { (arg) in
            let (msg, group) = arg
            if let errorMsg = msg { // Show Alert Msg
                DispatchQueue.main.async {
                    self.callAlert(with: errorMsg)
                }
            } else { // Go To Joined Group
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
//                        self.viewModel.goToGroup()
                        self.viewModel.goToJoinedGroup(group: group!)
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        viewModel?.closeWindow()
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
        self.view.frame.origin.y = 0
    }
    
    // Hide keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//
//  NewGroupViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

class NewGroupViewController: UIViewController {
    
    var viewModel: NewGroupViewModel!
    
    var bottomLine = UIView()
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var newGroupLabel: UILabel!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var photoImagePicker: UIImageView!
    @IBOutlet weak var chooseImageView: UIImageView!
    @IBOutlet weak var newGroupLogoImageView: UIImageView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var createButton: LoginButtonStyle!
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
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor.mainTextColor.cgColor
        topView.layer.cornerRadius = 15
        newGroupLabel.font = UIFont.setFont(size: .Medium)
        newGroupLabel.textColor = .mainTextColor
        
        imageView.layer.cornerRadius = 10
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseGroupLogo(tapGestureRecognizer:)))
        chooseImageView.isUserInteractionEnabled = true
        chooseImageView.addGestureRecognizer(tapGestureRecognizer)
        
        setupButtons()
        setupFields()
    }
    
    /* Setting up buttons */
    private func setupButtons() {
        imageView.setupShadow(cornerRad: 15, shadowRad: 15, shadowOp: 0.3, offset: CGSize(width: 10, height: 10))
        imageView.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: 15, startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
        createButton.titleLabel?.font = UIFont.setFont(size: .Medium)
        createButton.titleLabel?.addKern(1.74)
        createButton.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: 30, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
        
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
        groupNameTextField.font = UIFont.setFont(size: .ExtraLarge)
        
        descriptionTextField.font = UIFont.setFont(size: .Medium)
        
        [groupNameTextField, descriptionTextField].forEach {
            $0?.defaultTextAttributes.updateValue(1.74, forKey: NSAttributedString.Key.kern)
            $0?.textColor = .mainTextColor
            $0?.attributedPlaceholder = NSAttributedString(string: $0?.placeholder ?? "", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.mainTextColor.cgColor,
                NSAttributedString.Key.kern: 1.74
            ])
        }
    }
    
    /* Choosing Group Logo */
    @objc private func chooseGroupLogo(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    /* Create group chat and close window */
    @IBAction func createGroupChat(_ sender: UIButton) {
//        viewModel.goToShareLink()
        guard let nameText = groupNameTextField.text, !nameText.isEmpty else {
            groupNameTextField.shakeAnimation()
            return
        }
        
        if let image = newGroupLogoImageView.image { // If Group Image Selected
            viewModel.createNewGroup(with: nameText, image: image)
        } else { // Default Image
            viewModel.createNewGroup(with: nameText, image: UIImage(named: "groupImage")!)
        }
        
        dismiss(animated: true) {
            self.viewModel.goToGroup()
        }
    }
    
    /* Close window without saving */
    @IBAction func closeWithoutSaving(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        viewModel.closeWindow()
    }
    
    /* Keyboard moving */
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
//                signInButtonBottomConstraint.constant = keyboardSize.height / 3
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
//        signInButtonBottomConstraint.constant = 30
    }
    
    // Hide keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        print("DEINIT: NewGroupViewController")
    }
    
}

extension NewGroupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newGroupLogoImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

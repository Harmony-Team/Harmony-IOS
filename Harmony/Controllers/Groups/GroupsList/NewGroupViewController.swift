//
//  NewGroupViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

class NewGroupViewController: UIViewController {
    
    var viewModel: NewGroupViewModel?
    var newPlaylistViewModel: NewPlaylistViewModel?
    var playlistCreatedViewModel: PlaylistCreatedViewModel?
    
    var bottomLine = UIView()
    
    /* Top View */
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var newGroupLabel: UILabel!
    
    /* Image Section */
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var photoImagePicker: UIImageView!
    @IBOutlet weak var chooseImageView: UIImageView!
    @IBOutlet weak var newGroupLogoImageView: UIImageView!
    
    @IBOutlet weak var groupNameTextField: UITextField?
    @IBOutlet weak var descriptionTextField: UITextField?
    @IBOutlet weak var createButton: LoginButtonStyle!
    @IBOutlet weak var cancelButton: UIButton!
    
    /* New Playlist */
    @IBOutlet weak var tracksLabel: UILabel?
    @IBOutlet weak var tracksValueLabel: UILabel?
    @IBOutlet weak var participantsLabel: UILabel?
    @IBOutlet weak var participantsValueLabel: UILabel?
    
    /* Created Playlist */
    @IBOutlet weak var createdPlaylistLabel: UILabel?
    @IBOutlet weak var hoursLabel: UILabel?
    
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
        
        imageView.layer.cornerRadius = 10
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseGroupLogo(tapGestureRecognizer:)))
        chooseImageView.isUserInteractionEnabled = true
        chooseImageView.addGestureRecognizer(tapGestureRecognizer)
        
        setupButtons()
        setupFields()
    }
    
    /* Setting Up TopView */
    private func setupTopView() {
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor.mainTextColor.cgColor
        topView.layer.cornerRadius = 15
        newGroupLabel.font = UIFont.setFont(size: .Medium)
        newGroupLabel.textColor = .mainTextColor
    }
    
    /* Setting up buttons */
    private func setupButtons() {
        imageView.setupShadow(cornerRad: 15, shadowRad: 15, shadowOp: 0.3, offset: CGSize(width: 10, height: 10))
        imageView.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: 15, startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
        createButton.titleLabel?.font = UIFont.setFont(size: .Medium)
        createButton.titleLabel?.addKern(1.74)
        createButton.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: createButton.frame.height / 2.5, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
        
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
        groupNameTextField?.font = UIFont.setFont(size: .ExtraLarge)
        
        descriptionTextField?.font = UIFont.setFont(size: .Medium)
        
        createdPlaylistLabel?.font = UIFont.setFont(size: .ExtraLarge)
        createdPlaylistLabel?.addKern(1.74)
        createdPlaylistLabel?.text = playlistCreatedViewModel?.spotifyPlaylistName
        
        [tracksLabel, tracksValueLabel, participantsLabel, participantsValueLabel, hoursLabel].forEach {
            $0?.font = UIFont.setFont(size: .Small)
            $0?.textColor = .redTextColor
            $0?.addKern(1.74)
        }
        
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

        guard let nameText = groupNameTextField?.text?.replacingOccurrences(of: " ", with: "%20"), groupNameTextField?.text?.prefix(1) != " ", !nameText.isEmpty else {
            groupNameTextField?.shakeAnimation()
            return
        }
        
        let descrText = descriptionTextField?.text?.replacingOccurrences(of: " ", with: "%20")
        
        if let image = newGroupLogoImageView.image { // If Group Image Selected
            viewModel?.createNewGroup(with: nameText, description: descrText ?? "", imageUrl: image.imageToBase64())
        } else { // Default Image
            viewModel?.createNewGroup(with: nameText, description: descrText ?? "", imageUrl: UIImage(named: "groupImage")!.imageToBase64())
        }
    }
    
    /* Create playlist */
    @IBAction func createNewPlaylist(_ sender: UIButton) {
        guard let nameText = groupNameTextField?.text, !nameText.isEmpty else {
            groupNameTextField?.shakeAnimation()
            return
        }
        
        if let image = newGroupLogoImageView.image { // If Playlist Image Selected
            newPlaylistViewModel?.createNewPlaylist(with: nameText, image: image)
        } else { // Default Image
            newPlaylistViewModel?.createNewPlaylist(with: nameText, image: UIImage(named: "groupImage")!)
        }
    }
    
    /* Open Created Playlist In Sporify */
    @IBAction func openPlaylistInSpotify(_ sender: UIButton) {
        print("Open in Spotify")
    }
    
    /* Close window without saving */
    @IBAction func closeWithoutSaving(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
        guard viewModel != nil else {
            guard newPlaylistViewModel != nil else {
                playlistCreatedViewModel?.closeWindow()
                return
            }
            newPlaylistViewModel?.closeWindow()
            return
        }
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

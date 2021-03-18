//
//  ShareLinkViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 09.03.2021.
//

import UIKit

class ShareLinkViewController: UIViewController {

    var viewModel: ShareLinkViewModel!
    
    var bottomLine = UIView()
    
    @IBOutlet weak var shareGroupView: UIView!
    @IBOutlet weak var shareGroupLabel: UILabel!
    @IBOutlet weak var groupHasCreatedLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var shareButton: LoginButtonStyle!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeNavBarController(bgColor: .white, textColor: .mainTextColor)
        
        setupLabels()
        setupButtons()
    }
    
    private func setupLabels() {
        groupHasCreatedLabel.font = UIFont.setFont(size: .ExtraLarge)
        groupHasCreatedLabel.textColor = .darkTextColor
        
        shareLabel.font = UIFont.setFont(size: .Medium)
        shareLabel.textColor = .lightTextColor
        
        linkField.font = UIFont.setFont(size: .Large)
        
    }
    
    /* Setting up buttons */
    private func setupButtons() {
        shareButton.titleLabel?.font = UIFont.setFont(size: .Medium)
        shareButton.titleLabel?.addKern(1.74)
        shareButton.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: 30, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
        
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
    
    @IBAction func shareLink(_ sender: UIButton) {
        
//        dismiss(animated: true) {
            self.viewModel.goToGroup()
//        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
    }
    
}

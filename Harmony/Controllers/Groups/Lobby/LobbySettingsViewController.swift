//
//  LobbySettingsViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 09.05.2021.
//

import UIKit

class LobbySettingsViewController: UIViewController {

    var viewModel: LobbySettingsViewModel!
    var lobbyViewModel: GroupViewModel!
    
    @IBOutlet weak var lobbyImageView: UIImageView!
    @IBOutlet weak var lobbyNameField: UITextField!
    @IBOutlet weak var lobbyDescrField: UITextField!
    @IBOutlet weak var participantsView: UIView!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var saveButton: LoginButtonStyle!
    
//    private var participantsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBg(image: nil, colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 1)
        customizeNavBarController(bgColor: .bgColor, textColor: .white)
        
        setupViews()
        setupUsersCollectionView()
    }

    private func setupViews() {
        lobbyNameField?.font = UIFont.setFont(size: .ExtraLarge)
        lobbyDescrField?.font = UIFont.setFont(size: .Medium)
        
        participantsView.layer.cornerRadius = participantsView.frame.width * 0.08
        participantsLabel.font = UIFont.setFont(size: .Largest, weight: .Bold)
        participantsLabel.textColor = .darkMainTextColor
        
        saveButton.titleLabel?.font = UIFont.setFont(size: .Medium)
        saveButton.titleLabel?.addKern(1.74)
        saveButton.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: saveButton.frame.height / 2.5, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
        
        [lobbyNameField, lobbyDescrField].forEach {
            $0?.defaultTextAttributes.updateValue(1.74, forKey: NSAttributedString.Key.kern)
            $0?.textColor = .mainTextColor
            $0?.attributedPlaceholder = NSAttributedString(string: $0?.placeholder ?? "", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.mainTextColor.cgColor,
                NSAttributedString.Key.kern: 1.74
            ])
        }
    }
    
    /* Users Collection View */
    private func setupUsersCollectionView() {
//        participantsCollectionView = UICollectionView(frame: <#T##CGRect#>, collectionViewLayout: <#T##UICollectionViewLayout#>)
//        participantsView.addSubview(participantsCollectionView)
//        
//        participantsCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            participantsCollectionView.widthAnchor.constraint(equalTo: participantsView.widthAnchor, multiplier: 0.9),
//            participantsCollectionView.topAnchor.constraint(equalTo: participantsLabel.bottomAnchor, constant: 15),
//            participantsCollectionView.bottomAnchor.constraint(equalTo: participantsView.bottomAnchor, constant: -15),
//        ])
    }
    
    @IBAction func saveSettings(_ sender: UIButton) {
        
    }
    
}

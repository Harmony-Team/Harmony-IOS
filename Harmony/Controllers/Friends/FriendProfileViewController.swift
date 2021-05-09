//
//  FriendProfileViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 08.05.2021.
//

import UIKit

class FriendProfileViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var friendImageView: UIView!
    @IBOutlet weak var friendAvatarImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendId: UILabel!
    @IBOutlet weak var friendImageTopConstraint: NSLayoutConstraint!
    
    /* User Table Info */
    @IBOutlet weak var friendsCount: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var groupsCount: UILabel!
    @IBOutlet weak var groupsLabel: UILabel!
    @IBOutlet weak var playlistsCount: UILabel!
    @IBOutlet weak var playlistsLabel: UILabel!
    
    @IBOutlet weak var followButton: LoginButtonStyle!
    
    var viewModel: FriendProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeNavBarController(bgColor: .bgColor, textColor: .white)
        contentView.setGradientFill(colorTop: UIColor.loginGradientColorTop.cgColor, colorBottom: UIColor.loginGradientColorBottom.cgColor, cornerRadius: 0, startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)

        setupViews()
        setupFields()
    }

    private func setupViews() {
        friendName.text = "Friend Name"
        friendId.text = "@FRIENDID"
        
        friendName.font = UIFont.setFont(size: .ExtraLarge)
        friendId.font = UIFont.setFont(size: .Medium)
        
        [friendName, friendId].forEach {
            $0?.textColor = .white
            $0?.addKern(1.74)
        }
        
        friendImageView.backgroundColor = .clear
        friendImageView.setupShadow(cornerRad: friendAvatarImage.frame.width / 2, shadowRad: 5, shadowOp: 0.4, offset: CGSize(width: 8, height: 8))
        
        friendAvatarImage.layer.cornerRadius = friendAvatarImage.frame.width / 2
        friendAvatarImage.backgroundColor = .mainTextColor
        friendAvatarImage.image = UIImage(named: "groupImage1")
        friendAvatarImage.contentMode = .scaleAspectFill
        
        friendImageTopConstraint.constant = ((UIApplication.shared.keyWindow?.safeAreaInsets.top)! + (navigationController?.navigationBar.frame.height)!) * 1.1
        
        followButton.titleLabel?.font = UIFont.setFont(size: .Medium)
        followButton.titleLabel?.addKern(1.74)
        followButton.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: followButton.frame.height / 2.5, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
    }
    
    private func setupFields() {
        
        [friendsCount, groupsCount, playlistsCount].forEach {
            $0?.font = UIFont.setFont(size: .Big)
            $0?.textColor = .white
            $0?.addKern(1.74)
        }
        
        [friendsLabel, groupsLabel, playlistsLabel].forEach {
            $0?.font = UIFont.setFont(size: .Medium)
            $0?.textColor = .white
            $0?.addKern(1.74)
        }
    }
    
    @IBAction func followOrUnfollow(_ sender: UIButton) {
        
    }
    
}

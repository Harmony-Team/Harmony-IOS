//
//  ProfileViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

enum MenuViewAppearence {
    case Show
    case Hide
}

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    var viewModel: ProfileViewModel!
    private var menuView: SideMenuView!
    
    // Main Content View
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var userImageView: UIView!
    @IBOutlet weak var userImageTopConstrant: NSLayoutConstraint!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userId: UILabel!
    
    /* Collection Views */
    private var latestGroupsHeader = UILabel()
    private var latestGroupsCollectionView = LatestGroupsCollectionView()
    private var recentActivityHeader = UILabel()
    private var recentActivityCollectionView = RecentActivityCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeNavBarController(bgColor: .bgColor, textColor: .white)
        
        /* Setting Up Side Menu */
        setupMenuAndContent()
        if viewModel.isChosen { // Animate If Profile Screen Is Choosen In Menu
            goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: false)
            closeMenuOnTap(nil)
        }
        // Notification About Chosing Section In Menu
        NotificationCenter.default.addObserver(self, selector: #selector(chooseSection(notification:)), name: NSNotification.Name(rawValue: "ChoseSection"), object: nil)
        
        /* Loading Collection Views */
        showActivityIndicator(alpha: 1)
        
        /* Get user info */
        DispatchQueue.main.async {
            self.viewModel.getUserInfo {
                self.hideActivityIndicator()
                self.setupViews()
                self.setupLatestGroupsCollectionView()
                self.setupRecentActivityCollectionView()
            }
        }
        
        let settingsImage = UIImage(systemName: "gear")?.withRenderingMode(.alwaysTemplate)
        let menuImage = UIImage(named: "menuIcon")?.withRenderingMode(.alwaysTemplate)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuImage, style: .done, target: self, action: #selector(toggleMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingsImage, style: .done, target: self, action: #selector(goToSettings))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /* Setting Up Content View And Menu */
    private func setupMenuAndContent() {
        menuView = SideMenuView(frame: view.frame, viewModel: SideMenuViewModel())
        addSideMenuView(menuView: menuView)
        setupContent(menuView: menuView, contentView: contentView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeMenuOnTap(_:completion:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        contentView.addGestureRecognizer(tap)
        contentView.addGestureRecognizer(panGestureRecognizer)
        contentView.isUserInteractionEnabled = true
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let position: CGFloat = sender.translation(in: self.view).x
//        let velocity: CGFloat = sender.velocity(in: self.view).x
//
//        if(position >= 0) {
//            contentView.transform = CGAffineTransform(translationX: position, y: 0)
//        }
//
        print(position)
    }

    private func setupViews() {
        userName.text = viewModel.user.login
        userId.text = "@\(viewModel.user.login)".uppercased()
        
        userName.font = UIFont.setFont(size: .ExtraLarge)
        userId.font = UIFont.setFont(size: .Medium)
        
        latestGroupsHeader.text = "LATEST GROUPS"
        recentActivityHeader.text = "RECENT ACTIVITY"
        
        [latestGroupsHeader, recentActivityHeader].forEach {
            $0.textColor = .mainTextColor
            $0.font = UIFont.setFont(size: .Medium, weight: .Light)
            $0.addKern(1.5)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [userName, userId].forEach {
            $0?.textColor = .white
            $0?.addKern(1.74)
        }
        
        userImageView.backgroundColor = .clear
        userImageView.setupShadow(cornerRad: userImage.frame.width / 2, shadowRad: 5, shadowOp: 0.4, offset: CGSize(width: 8, height: 8))
        
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.backgroundColor = .mainTextColor
        userImage.image = UIImage(named: "groupImage1")
        userImage.contentMode = .scaleAspectFill
        
        userImageView.setVerificationIcon()
        userImageTopConstrant.constant = ((UIApplication.shared.keyWindow?.safeAreaInsets.top)! + (navigationController?.navigationBar.frame.height)!) * 1.1
    }
    
    /* Setting Up Lates Groups Collection View */
    private func setupLatestGroupsCollectionView() {
        contentView.addSubview(latestGroupsHeader)
        contentView.addSubview(latestGroupsCollectionView)
        latestGroupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            latestGroupsHeader.topAnchor.constraint(equalTo: userId.bottomAnchor, constant: 40),
            latestGroupsHeader.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            latestGroupsCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            latestGroupsCollectionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.13),
            latestGroupsCollectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            latestGroupsCollectionView.topAnchor.constraint(equalTo: latestGroupsHeader.bottomAnchor, constant: 5)
        ])
    }
    
    /* Setting Up Recent Activity Collection View */
    private func setupRecentActivityCollectionView() {
        contentView.addSubview(recentActivityHeader)
        contentView.addSubview(recentActivityCollectionView)
        recentActivityCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recentActivityHeader.topAnchor.constraint(equalTo: latestGroupsCollectionView.bottomAnchor, constant: 30),
            recentActivityHeader.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            recentActivityCollectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            recentActivityCollectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            recentActivityCollectionView.topAnchor.constraint(equalTo: recentActivityHeader.bottomAnchor, constant: 15),
            recentActivityCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1),
        ])
    }
    
    /* Open user settings screen */
    @objc private func goToSettings() {
        viewModel.goToSettings()
    }
    
    /* Choosing Secton In Menu */
    @objc private func chooseSection(notification: NSNotification) {
        if let section = notification.userInfo?["section"] as? MenuSection {
            closeMenuOnTap(nil) {
                self.viewModel.goToSelectedSection(section: section)
            }
        }
    }
    
    /* Content View Tapped To Close Menu */
    @objc private func closeMenuOnTap(_ sender: UITapGestureRecognizer?, completion: (()->())? = nil) {
        if (viewModel.menuShow) {
            goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: true, completion: completion)
        }
    }
    
    /* Open / Close menu */
    @objc private func toggleMenu(_ sender: UITapGestureRecognizer) {
        goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: true)
    }
}

/*
extension ProfileViewController: UIGestureRecognizerDelegate {
    
    @objc func revealSideMenu() {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
    
    // Dragging Side Menu
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        // ...

        let position: CGFloat = sender.translation(in: self.view).x
        let velocity: CGFloat = sender.velocity(in: self.view).x

        switch sender.state {
        case .began:

            // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
            if velocity > 0, self.isExpanded {
                sender.state = .cancelled
            }

            // If the user swipes right but the side menu hasn't expanded yet, enable dragging
            if velocity > 0, !self.isExpanded {
                self.draggingIsEnabled = true
            }
            // If user swipes left and the side menu is already expanded, enable dragging they collapsing the side menu)
            else if velocity < 0, self.isExpanded {
                self.draggingIsEnabled = true
            }

            if self.draggingIsEnabled {
                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.sideMenuState(expanded: self.isExpanded ? false : true)
                    self.draggingIsEnabled = false
                    return
                }

                if self.revealSideMenuOnTop {
                    self.panBaseLocation = 0.0
                    if self.isExpanded {
                        self.panBaseLocation = self.sideMenuRevealWidth
                    }
                }
            }

        case .changed:

            // Expand/Collapse side menu while dragging
            if self.draggingIsEnabled {
                if self.revealSideMenuOnTop {
                    // Show/Hide shadow background view while dragging
                    let xLocation: CGFloat = self.panBaseLocation + position
                    let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                    let alpha = percentage >= 0.6 ? 0.6 : percentage

                    // Move side menu while dragging
                    if xLocation <= self.sideMenuRevealWidth {
                        self.sideMenuTrailingConstraint.constant = xLocation - self.sideMenuRevealWidth
                    }
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                       // Show/Hide shadow background view while dragging
                        let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                        let alpha = percentage >= 0.6 ? 0.6 : percentage

                        // Move side menu while dragging
                        if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
        case .ended:
            self.draggingIsEnabled = false
            // If the side menu is half Open/Close, then Expand/Collapse with animationse with animation
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuRevealWidth * 0.5)
                self.sideMenuState(expanded: movedMoreThanHalf)
            }
            else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                    self.sideMenuState(expanded: movedMoreThanHalf)
                }
            }
        default:
            break
        }
    }
}
*/

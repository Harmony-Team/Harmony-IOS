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
    private var latestGroupsCollectionView: LatestGroupsCollectionView!
    private var recentActivityHeader = UILabel()
    private var recentActivityCollectionView = RecentActivityCollectionView()
    
    /* Gesture To Reopen Screen From Menu */
    private var tapGestureRecogniser: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeNavBarController(bgColor: .bgColor, textColor: .white)
        
        /* Setting Up Side Menu */
        setupMenuAndContent()
        if viewModel.isChosen { // Animate If Profile Screen Is Choosen In Menu
            goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: false, gestureRecogniser: tapGestureRecogniser)
            closeMenuOnTap(nil)
        }
        // Notification About Chosing Section In Menu
        NotificationCenter.default.addObserver(self, selector: #selector(chooseSection(notification:)), name: NSNotification.Name(rawValue: "ChoseSection"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeMenuOnTap(_:completion:)), name: NSNotification.Name(rawValue: "CloseSideMenu"), object: nil)
        
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
        tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(closeMenuOnTap(_:completion:)))
        addSideMenuView(menuView: menuView)
        setupContent(menuView: menuView, contentView: contentView)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        contentView.addGestureRecognizer(panGestureRecognizer)
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
        latestGroupsCollectionView = LatestGroupsCollectionView(viewModel: viewModel)
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
            goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: true, gestureRecogniser: tapGestureRecogniser, completion: completion)
        }
    }
    
    /* Open / Close menu */
    @objc private func toggleMenu(_ sender: UITapGestureRecognizer) {
        goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: true, gestureRecogniser: tapGestureRecogniser)
    }
}

//
//  GroupViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 10.03.2021.
//

import UIKit

class LobbyViewController: UIViewController {
    
    var viewModel: GroupViewModel!
    
    /* Header Gradient Section */
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topImage: UIImageView!
    
    /* Users Of The Group Section */
    private var groupUsersLabel = UILabel()
    private var groupUsersCollectionView: GroupUsersCollectionView!
    
    /* Music Section */
    private var musicTabBarSegment = UISegmentedControl()
    private var musicSearchBar = UITextField()
    private var searchIcon = UIButton()
    private var closeSearchBarIcon = UIButton()
    private var musicTabBarCollectionView: MusicTabBarCollectionView!
    private var waitingForFriendsView: WaitingFriendsView!
    
    @IBOutlet weak var readyButton: LoginButtonStyle!
    @IBOutlet weak var notReadyButton: LoginButtonStyle?
    
    var iconLeftAnchor: NSLayoutConstraint?
    var iconRightAnchor: NSLayoutConstraint?
    var usersCollectionViewTopAnchor: NSLayoutConstraint?
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    var segmentTopAnchor: NSLayoutConstraint?
    var errorMsg: String?

    private var lastContentOffset: CGFloat = 0.0
    
    @IBOutlet weak var blackView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blackView.alpha = 1
        blackView.layer.zPosition = 100
        UIView.animate(withDuration: 0.5, delay: 0.2) {
            self.blackView.alpha = 0
        }

        addBg(image: nil, colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 1)
        customizeNavBarController(bgColor: .bgColor, textColor: .white)
        
        let settingsImage: UIImage?
        if #available(iOS 13.0, *) {
            settingsImage = UIImage(systemName: "gear")?.withRenderingMode(.alwaysTemplate)
        } else {
            settingsImage = UIImage(named: "gear")?.withRenderingMode(.alwaysTemplate)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingsImage, style: .done, target: self, action: #selector(openLobbySettings))
        
        topImage.setupTopGradientMask(with: topView)
        
        navigationController?.title = "LOBBY"
        
        NotificationCenter.default.addObserver(self, selector: #selector(musicTabBarCollectionViewSlided(notification:)), name: NSNotification.Name(rawValue: "SlideMusicSections"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(myMusicScrolled(notification:)), name: NSNotification.Name(rawValue: "ScrollMyMusic"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callErrorAlertSong(notification:)), name: NSNotification.Name(rawValue: "ShowErrorAlertSong"), object: nil)
        
        setupUsersCollectionView()
        
        setupSegment()
        setupSearchBar()
        setupButton()
        setupCustomView()
        if let readyButton = notReadyButton {
            waitingForFriendsView.addSubview(readyButton)
        }
        waitingForFriendsView.alpha = 0
        
        showActivityIndicator()
        
        DispatchQueue.main.async {
            self.viewModel.checkSpotify (refresh: false) { (result) in
                
                self.hideActivityIndicator()
                
                switch result {
                case .failure(let error):
                    if error == .NoPlaylists { // No playlists
                        self.errorMsg = "You have no playlists in your spotify account"
                        print("You have no playlists in your sporify account")
                    } else { // Not signed in
                        self.errorMsg = "To see your tracks you have to sign in to your spotify account"
                        print("To see your tracks you have to sign in to your spotify account")
                    }
                    self.setupMusicCollectionView()
                    self.readyButton.alpha = 0
                    break
                default:
                    self.setupMusicCollectionView()
                    self.musicTabBarCollectionView.reloadData()
                    self.musicTabBarCollectionView.addSubview(self.readyButton)
                    break
                }

            }
            
        }
        
    }
    
    /* Users Collection View */
    private func setupUsersCollectionView() {
        groupUsersCollectionView = GroupUsersCollectionView(viewModel: viewModel, groupAdmin: viewModel.group.hostLogin, groupUsers: viewModel.group.users)
        groupUsersLabel.text = "USERS OF THE GROUP"
        groupUsersLabel.font = UIFont.setFont(size: .Small)
        groupUsersLabel.addKern(1.74)
        groupUsersLabel.textColor = .white
        groupUsersLabel.textAlignment = .center
        
        view.addSubview(groupUsersLabel)
        view.addSubview(groupUsersCollectionView)
        
        groupUsersLabel.translatesAutoresizingMaskIntoConstraints = false
        groupUsersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            groupUsersLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            groupUsersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groupUsersLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            groupUsersCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            groupUsersCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            groupUsersCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groupUsersCollectionView.topAnchor.constraint(equalTo: groupUsersLabel.bottomAnchor, constant: 10)
        ])
    }
    
    /* Music Segment */
    private func setupSegment() {
        musicTabBarSegment = UISegmentedControl(items: [
            "ADD MY MUSIC",
            "LOBBY'S PLAYLISTS"
        ])

        musicTabBarSegment.selectedSegmentIndex = 0
        musicTabBarSegment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        musicTabBarSegment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        musicTabBarSegment.apportionsSegmentWidthsByContent = true
        musicTabBarSegment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        musicTabBarSegment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.redTextNotSelectedColor,
            NSAttributedString.Key.kern: 1.74,
            NSAttributedString.Key.font: UIFont.setFont(size: .Small)
        ], for: .normal)
        
        musicTabBarSegment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.redTextColor,
        ], for: .selected)
        
        view.addSubview(musicTabBarSegment)
        musicTabBarSegment.translatesAutoresizingMaskIntoConstraints = false
        
        segmentTopAnchor = musicTabBarSegment.topAnchor.constraint(equalTo: groupUsersCollectionView.bottomAnchor, constant: 15)
        segmentTopAnchor?.isActive = true
        NSLayoutConstraint.activate([
            musicTabBarSegment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            musicTabBarSegment.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            musicTabBarSegment.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
           // musicTabBarSegment.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        musicTabBarCollectionView.scrollToItem(at: IndexPath(item: sender.selectedSegmentIndex, section: 0), at: .top, animated: true)
    }
    
    /* Notification: Slide To Music/Playlists Section */
    @objc private func musicTabBarCollectionViewSlided(notification: Notification) {
        if let xPos = notification.userInfo?["xPos"] as? CGFloat {
            musicTabBarSegment.selectedSegmentIndex = xPos == 0 ? 0 : 1
            closeSearchBar()
        }
    }
    
    /* Notification: Hide My View After Scrolling Music */
    @objc private func myMusicScrolled(notification: Notification) {
        if let yPos = notification.userInfo?["yPos"] as? CGFloat {
            let delta = yPos - lastContentOffset
            let safeFrame = view.safeAreaLayoutGuide.layoutFrame

//            let availableToScroll: Bool = (topViewHeightConstraint.constant + safeFrame.minY) > -safeFrame.minY
//            let availableToScroll: Bool = (topViewHeightConstraint.constant + safeFrame.minY) < safeFrame.minY

//            if availableToScroll {

                segmentTopAnchor!.constant -= delta
                topViewHeightConstraint.constant -= delta
            
                print(safeFrame.minY)
                print(topViewHeightConstraint.constant + safeFrame.minY)
//            }

            lastContentOffset = yPos
        }
    }
    
    /* Show Alert About "Song is already in music pool" */
    @objc private func callErrorAlertSong(notification: NSNotification) {
        if let msg = notification.userInfo?["msg"] as? String {
            DispatchQueue.main.async {
                self.callAlert(with: msg)
            }
        }
    }
    
    private func setupSearchBar() {
        if #available(iOS 13.0, *) {
            searchIcon.setBackgroundImage(UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            searchIcon.setBackgroundImage(UIImage(named: "magnifyingglass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        searchIcon.tintColor = .white
        
        if #available(iOS 13.0, *) {
            closeSearchBarIcon.setBackgroundImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            closeSearchBarIcon.setBackgroundImage(UIImage(named: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)

        }
        closeSearchBarIcon.tintColor = .white
        closeSearchBarIcon.alpha = 0
        
        musicSearchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width * 0.65, height: view.frame.height * 0.05)
        musicSearchBar.setGradientStack(colorTop: UIColor.gradientColorTop.cgColor,
                                        colorBottom: UIColor.gradientColorBottom.cgColor,
                                        cornerRadius: 15, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0))
        musicSearchBar.alpha = 0
        musicSearchBar.textColor = .mainTextColor
        musicSearchBar.addPadding(.both(15))
        musicSearchBar.addTarget(self, action: #selector(searchTrack(_:)), for: .editingChanged)
        musicSearchBar.attributedPlaceholder = NSAttributedString(string: "Search...",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.mainTextColor])
        
        [searchIcon, musicSearchBar, closeSearchBarIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        searchIcon.addTarget(self, action: #selector(goToSearchMusic), for: .touchUpInside)
        closeSearchBarIcon.addTarget(self, action: #selector(closeSearchBar), for: .touchUpInside)
        
        view.addSubview(searchIcon)
        view.addSubview(musicSearchBar)
        view.addSubview(closeSearchBarIcon)
        
        iconLeftAnchor = searchIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        
        iconRightAnchor = searchIcon.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        iconRightAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            searchIcon.heightAnchor.constraint(equalTo: musicTabBarSegment.heightAnchor, multiplier: 0.6),
            searchIcon.widthAnchor.constraint(equalTo: searchIcon.heightAnchor),
            searchIcon.centerYAnchor.constraint(equalTo: musicTabBarSegment.centerYAnchor),
            
            closeSearchBarIcon.heightAnchor.constraint(equalTo: musicTabBarSegment.heightAnchor, multiplier: 0.6),
            closeSearchBarIcon.widthAnchor.constraint(equalTo: searchIcon.heightAnchor),
            closeSearchBarIcon.centerYAnchor.constraint(equalTo: musicTabBarSegment.centerYAnchor),
            closeSearchBarIcon.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            musicSearchBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            musicSearchBar.leftAnchor.constraint(equalTo: searchIcon.rightAnchor, constant: 20),
            musicSearchBar.rightAnchor.constraint(equalTo: closeSearchBarIcon.leftAnchor, constant: -20),
            musicSearchBar.centerYAnchor.constraint(equalTo: closeSearchBarIcon.centerYAnchor)
        ])
        
    }
    
    /* Search Bar Value Changed */
    @objc func searchTrack(_ textfield: UITextField) {
        if let searchText = textfield.text {
            let searchDict: [String: String] = ["text": searchText]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SearchBarTextEntered"), object: nil, userInfo: searchDict)
        }
    }
    
    /* Music Collection View */
    private func setupMusicCollectionView() {
        musicTabBarCollectionView = MusicTabBarCollectionView(viewModel: viewModel, errorMsg: errorMsg ?? "")
        musicTabBarCollectionView.layer.zPosition = 10
        view.addSubview(musicTabBarCollectionView)
        musicTabBarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            musicTabBarCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            musicTabBarCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            musicTabBarCollectionView.topAnchor.constraint(equalTo: musicTabBarSegment.bottomAnchor, constant: 0),
            musicTabBarCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /* Setting Up Ready/Create Button */
    private func setupButton() {
        readyButton.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: readyButton.frame.width / 2, startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
        readyButton.titleLabel?.font = UIFont.setFont(size: .Small)
        readyButton.titleLabel?.addKern(1.74)
        readyButton.layer.zPosition = 2
        
        notReadyButton?.titleLabel?.font = UIFont.setFont(size: .Small)
        notReadyButton?.titleLabel?.addKern(1.74)
        notReadyButton?.tintColor = .white
        notReadyButton?.layer.zPosition = 3
        notReadyButton?.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: 30, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
    }
    
    /* Show Search Bar */
    @objc private func searchButtonTapped() {
        iconLeftAnchor?.isActive = true
        iconRightAnchor?.isActive = false
        musicSearchBar.text = ""
        
//        segmentTopAnchor?.isActive = false
//        musicTabBarSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
//        topImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.alpha = 0
            self.groupUsersCollectionView.alpha = 0
            self.groupUsersLabel.alpha = 0
            self.topImage.alpha = 0
            
            self.musicTabBarSegment.alpha = 0
            self.musicSearchBar.alpha = 1
            self.closeSearchBarIcon.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    /* Go To Search View Controller */
    @objc private func goToSearchMusic() {
        viewModel.goToSearchMusic()
    }
    
    /* Close Search Bar */
    @objc private func closeSearchBar() {
        iconLeftAnchor?.isActive = false
        iconRightAnchor?.isActive = true
        musicSearchBar.text = ""
        searchTrack(musicSearchBar)
        
        //musicTabBarSegment.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: -20).isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.groupUsersCollectionView.alpha = 1
            self.groupUsersLabel.alpha = 1
            self.topImage.alpha = 1
            
            self.musicTabBarSegment.alpha = 1
            self.musicSearchBar.alpha = 0
            self.closeSearchBarIcon.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    /* Open Lobby Settings */
    @objc private func openLobbySettings() {
        
    }
    
    /* Ready Button Tapped */
    @IBAction func readyButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.musicTabBarCollectionView.alpha = 0
            self.musicTabBarSegment.alpha = 0
            self.searchIcon.alpha = 0
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.waitingForFriendsView.alpha = 1
            }
        }
    }
    
    /* CreatePlaylist Button Tapped */
    @IBAction func createButtonTapped(_ sender: UIButton) {
        viewModel.createPlaylist()
    }
    
    @IBAction func notReadyButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.waitingForFriendsView.alpha = 0
            
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.musicTabBarCollectionView.alpha = 1
                self.musicTabBarSegment.alpha = 1
                self.searchIcon.alpha = 1
            }
        }
    }
    
    /* Setting Up Waiting For Users Tracks View */
    private func setupCustomView() {
        waitingForFriendsView = WaitingFriendsView(frame: .zero)
        waitingForFriendsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(waitingForFriendsView!)
        
        NSLayoutConstraint.activate([
            waitingForFriendsView.bottomAnchor.constraint(equalTo: readyButton.centerYAnchor),
            waitingForFriendsView.topAnchor.constraint(equalTo: musicTabBarSegment.topAnchor),
            waitingForFriendsView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            waitingForFriendsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}

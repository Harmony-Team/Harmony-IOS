//
//  GroupViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 10.03.2021.
//

import UIKit

class GroupViewController: UIViewController {
    
    var viewModel: GroupViewModel!
    
    /* Header Gradient Section */
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topImage: UIImageView!
    
    /* Users Of The Group Section */
    private var groupUsersLabel = UILabel()
    private var groupUsersCollectionView = GroupUsersCollectionView()
    
    /* Music Section */
    private var musicTabBarSegment = UISegmentedControl()
    private var musicSearchBar = UITextField()
    private var searchIcon = UIButton()
    private var closeSearchBarIcon = UIButton()
    private var musicTabBarCollectionView: MusicTabBarCollectionView!
    private var waitingForFriendsView: WaitingFriendsView!
    
    @IBOutlet weak var readyButton: LoginButtonStyle!
    @IBOutlet weak var notReadyButton: LoginButtonStyle!
    @IBOutlet weak var notReadyBottomConstraint: NSLayoutConstraint!
    
    var iconLeftAnchor: NSLayoutConstraint?
    var iconRightAnchor: NSLayoutConstraint?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.title = "LOBBY"
        
        addBg(image: nil, colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 1)
        customizeNavBarController(bgColor: .bgColor, textColor: .white)
        
        topImage.setupTopGradientMask(with: topView)
        
        setupUsersCollectionView()
        
        setupSegment()
        setupSearchBar()
        setupButton()
        setupCustomView()
        waitingForFriendsView.addSubview(self.notReadyButton)
        waitingForFriendsView.alpha = 0
        
        showActivityIndicator()
        
        DispatchQueue.main.async {
            self.viewModel.checkSpotify { (result) in
                switch result {
                case .failure(let error):
                    if error == .NoPlaylists { // No playlists
//                        self.failedSpotify(msg: "You have no playlists in your sporify account")
                        print("You have no playlists in your sporify account")
                    } else { // Not signed in
//                        self.failedSpotify(msg: "To see your tracks you have to sign in to your spotify account")
                        print("To see your tracks you have to sign in to your spotify account")
                    }
                    break
                default:
                    break
                }
            }
            self.viewModel.viewDidLoad {
                self.hideActivityIndicator()
//                self.musicTableView.isHidden = false
            }
        }
        viewModel.onUpdate = {
            self.setupMusicCollectionView()
            self.musicTabBarCollectionView.reloadData()
            self.musicTabBarCollectionView.addSubview(self.readyButton)
        }
        
    }
    
    /* Users Collection View */
    private func setupUsersCollectionView() {
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
            groupUsersCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.13),
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
        musicTabBarSegment.selectedSegmentTintColor = .clear
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
        NSLayoutConstraint.activate([
            musicTabBarSegment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            musicTabBarSegment.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            musicTabBarSegment.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            musicTabBarSegment.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        musicTabBarCollectionView.scrollToItem(at: IndexPath(item: sender.selectedSegmentIndex, section: 0), at: .top, animated: true)
    }
    
    private func setupSearchBar() {
        searchIcon.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchIcon.tintColor = .white
        
        closeSearchBarIcon.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        closeSearchBarIcon.tintColor = .white
        closeSearchBarIcon.alpha = 0
        
        musicSearchBar.setGradientStack(colorTop: UIColor.gradientColorTop.cgColor,
                                        colorBottom: UIColor.gradientColorBottom.cgColor,
                                        cornerRadius: 15, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0))
        musicSearchBar.alpha = 0
        musicSearchBar.placeholder = "Search..."
        musicSearchBar.textColor = .mainTextColor
        //        musicSearchBar.backgroundColor = .white
        musicSearchBar.addPadding(.both(15))
        musicSearchBar.addTarget(self, action: #selector(searchTrack), for: .valueChanged)
        
        [searchIcon, musicSearchBar, closeSearchBarIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        searchIcon.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
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
            musicSearchBar.topAnchor.constraint(equalTo: musicTabBarSegment.topAnchor)
        ])
        
    }
    
    @objc private func searchTrack() {
        print("Search")
    }
    
    /* Music Collection View */
    private func setupMusicCollectionView() {
        musicTabBarCollectionView = MusicTabBarCollectionView(viewModel: viewModel)
        musicTabBarCollectionView.layer.zPosition = 1
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
        readyButton.titleLabel?.font = UIFont.setFont(size: .Medium)
        readyButton.titleLabel?.addKern(1.74)
        readyButton.layer.zPosition = 2
        
        notReadyButton.titleLabel?.font = UIFont.setFont(size: .Medium)
        notReadyButton.titleLabel?.addKern(1.74)
        notReadyButton.tintColor = .white
        notReadyButton.layer.zPosition = 3
        notReadyButton.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: 30, startPoint: CGPoint(x: -0.5, y: 1.1), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
    }
    
    /* Show Search Bar */
    @objc private func searchButtonTapped() {
        iconLeftAnchor?.isActive = true
        iconRightAnchor?.isActive = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.musicTabBarSegment.alpha = 0
            self.musicSearchBar.alpha = 1
            self.closeSearchBarIcon.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    /* Close Search Bar */
    @objc private func closeSearchBar() {
        iconLeftAnchor?.isActive = false
        iconRightAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.musicTabBarSegment.alpha = 1
            self.musicSearchBar.alpha = 0
            self.closeSearchBarIcon.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func readyButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
//            self.musicTabBarCollectionView.alpha = 0
//            self.musicTabBarSegment.alpha = 0
//            self.searchIcon.alpha = 0
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.waitingForFriendsView.alpha = 1
            }
        }
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(targetContentOffset.pointee.x)
    }
    
}

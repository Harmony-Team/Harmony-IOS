//
//  FriendsViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

class FriendsViewController: UIViewController {
    
    var viewModel: FriendsViewModel!
    private var menuView: SideMenuView!
    
    // Main Content View
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    /* Gesture To Reopen Screen From Menu */
    private var tapGestureRecogniser: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setting Up Menu And Content */
        setupMenuAndContent()
        customizeNavBarController(bgColor: .bgColor, textColor: .white)
        
        let menuImage = UIImage(named: "menuIcon")?.withRenderingMode(.alwaysTemplate)
        goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: false, gestureRecogniser: tapGestureRecogniser)
        closeMenuOnTap(nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuImage, style: .done, target: self, action: #selector(toggleMenu))
        
        // Notification About Chosing Section In Menu
        NotificationCenter.default.addObserver(self, selector: #selector(chooseSection(notification:)), name: NSNotification.Name(rawValue: "ChoseSection"), object: nil)
        
        setupSearchBar()
        setupTableView()
    }
    
    /* Setting Up Content View And Menu */
    private func setupMenuAndContent() {
        menuView = SideMenuView(frame: view.frame, viewModel: SideMenuViewModel(), selectedSection: 2)
        addSideMenuView(menuView: menuView)
        setupContent(menuView: menuView, contentView: contentView)
        tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(closeMenuOnTap(_:completion:)))
    }
    
    /* Setting Up Search Bar */
    private func setupSearchBar() {
        friendsSearchBar.searchBarStyle = .minimal
        friendsSearchBar.delegate = self
        if #available(iOS 13.0, *) {
            friendsSearchBar.searchTextField.textColor = .white
        } else {
            friendsSearchBar.tintColor = .white
        }
    }
    
    /* Setting Up Friends Table View */
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: "friendCell")
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
        view.endEditing(true)
        goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: true, gestureRecogniser: tapGestureRecogniser)
    }
    
}

/* Search Bar Ext */
extension FriendsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}

extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        cell.selectionStyle = .none
        cell.nameLabel.text = "Friend Name"
        cell.infoLabel.text = "Info"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.13
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goToFriendProfile()
    }
}

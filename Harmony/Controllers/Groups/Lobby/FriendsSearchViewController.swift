//
//  FriendsSearchViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 06.05.2021.
//

import UIKit

class FriendsSearchViewController: UIViewController {

    var viewModel: FriendsSearchViewModel!

    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBg(image: nil, colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 1)
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.titleView = searchBar
        let cancelSearchBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.setRightBarButton(cancelSearchBarButtonItem, animated: true)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(notification:)), name: NSNotification.Name(rawValue: "SearchFriendsTextEntered"), object: nil)
        
        setupTableView()
        setupSearchBar()
    }
    
    /* Setting Up Table View */
    private func setupTableView() {
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        friendsTableView.allowsMultipleSelection = true
        friendsTableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.reuseId)
        friendsTableView.separatorStyle = .none
        friendsTableView.rowHeight = UIScreen.main.bounds.height * 0.1
        friendsTableView.backgroundColor = .clear
    }
    
    /* Setting Up Search Bar */
    private func setupSearchBar() {
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.textColor = .white
        } else {
            searchBar.barTintColor = .white
        }
    }
    
    /* Go Back To Lobby (Fade Out) */
    @objc private func cancelButtonTapped() {
        viewModel.goToLobbyViewController()
    }

    /* Filter Spotify Tracks */
    @objc private func notificationAction(notification: Notification) {
//        if let text = notification.userInfo?["text"] as? String {
//            if !text.isEmpty {
//                viewModel.visibleSpotifyTracks = viewModel.spotifyTracks.filter {
//                    return $0.name?.range(of: text, options: .caseInsensitive) != nil
//                }
//            } else {
//                viewModel.visibleSpotifyTracks = viewModel.spotifyTracks
//            }
//
//            friendsTableView.reloadData()
//        }
    }
    
}

/* Search Bar Ext */
extension FriendsSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchDict: [String: String] = ["text": searchText]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SearchFriendsTextEntered"), object: nil, userInfo: searchDict)
    }
}

/* Table View Ext */
extension FriendsSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.reuseId, for: indexPath) as! FriendCell
        
//        cell.update(track: viewModel.visibleSpotifyTracks[indexPath.row])
        cell.nameLabel.text = "Friend Name"
        cell.infoLabel.text = "Info"
        cell.selectionStyle = .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let track = viewModel.visibleSpotifyTracks[indexPath.row]
//        if viewModel.selectedSpotifyTracks.contains(track) {
//            cell.isSelected = true
//            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? FriendCell else {return}
//        let selectedTrack = viewModel.visibleSpotifyTracks[indexPath.row]
        
        selectedCell.isSelected = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? FriendCell else {return}
//        let selectedTrack = viewModel.visibleSpotifyTracks[indexPath.row]
        
        selectedCell.isSelected = false
    }
    
}

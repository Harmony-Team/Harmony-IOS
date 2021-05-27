//
//  MusicSearchViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 01.04.2021.
//

import UIKit

class MusicSearchViewController: UIViewController {
    
    var viewModel: MusicSearchViewModel!

    @IBOutlet weak var musicTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBg(image: nil, colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 1)
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.titleView = searchBar
        let cancelSearchBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.setRightBarButton(cancelSearchBarButtonItem, animated: true)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        setupTableView()
        setupSearchBar()
    }
    
    /* Setting Up Table View */
    private func setupTableView() {
        musicTableView.dataSource = self
        musicTableView.delegate = self
        musicTableView.allowsMultipleSelection = true
        musicTableView.register(MyMusicTableCell.self, forCellReuseIdentifier: MyMusicTableCell.reuseId)
        musicTableView.separatorStyle = .none
        musicTableView.rowHeight = UIScreen.main.bounds.height * 0.1
        musicTableView.backgroundColor = .clear
    }
    
    /* Setting Up Search Bar */
    private func setupSearchBar() {
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.textColor = .white
        } else {
            searchBar.tintColor = .white
        }
    }
    
    /* Go Back To Lobby (Fade Out) */
    @objc private func cancelButtonTapped() {
        viewModel.goToLobbyViewController()
    }
}

/* Search Bar Ext To Filter Visible Spotify Tracks */
extension MusicSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.visibleSpotifyTracks = viewModel.spotifyTracks.matching(searchText)
        musicTableView.reloadData()
    }
}

/* Table View Ext */
extension MusicSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.visibleSpotifyTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyMusicTableCell.reuseId, for: indexPath) as! MyMusicTableCell
        cell.update(track: viewModel.visibleSpotifyTracks[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let track = viewModel.visibleSpotifyTracks[indexPath.row]
        if viewModel.selectedSpotifyTracks.contains(track) {
            cell.isSelected = true
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? MyMusicTableCell else {return}
        let selectedTrack = viewModel.visibleSpotifyTracks[indexPath.row]
        
        selectedCell.isSelected = true
        viewModel.selectedSpotifyTracks.append(selectedTrack)
        viewModel.addSong()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? MyMusicTableCell else {return}
        let selectedTrack = viewModel.visibleSpotifyTracks[indexPath.row]
        
        selectedCell.isSelected = false
        viewModel.selectedSpotifyTracks.removeAll(where: { $0 == selectedTrack })
        viewModel.removeSong(index: indexPath.row)
    }
    
}

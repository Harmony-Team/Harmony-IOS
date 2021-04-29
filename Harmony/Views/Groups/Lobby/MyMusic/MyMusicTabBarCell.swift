//
//  MusicTabBarCell.swift
//  Harmony
//
//  Created by Macbook Pro on 10.03.2021.
//

import UIKit

class MusicTabBarCell: UICollectionViewCell {
    
    var viewModel: GroupViewModel!
    
    private var musicTableView = UITableView()
    private var refreshControl = UIRefreshControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Notification Of Search Bar
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(notification:)), name: NSNotification.Name(rawValue: "SearchBarTextEntered"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMusicTableView(notification:)), name: NSNotification.Name(rawValue: "MusicTableReload"), object: nil)
        
        backgroundColor = .clear
        setupTableView()
    }
    
    private func setupTableView() {
        musicTableView.dataSource = self
        musicTableView.delegate = self
        musicTableView.allowsMultipleSelection = true
        musicTableView.register(MyMusicTableCell.self, forCellReuseIdentifier: "musicTableCellId")
        musicTableView.separatorStyle = .none
        musicTableView.rowHeight = UIScreen.main.bounds.height * 0.1
        musicTableView.backgroundColor = .clear
        musicTableView.translatesAutoresizingMaskIntoConstraints = false
        musicTableView.frame = contentView.frame
        refreshControl.tintColor = .mainColor
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        musicTableView.addSubview(refreshControl)
        
        contentView.addSubview(musicTableView)
    }
    
    /* Filter Spotify Tracks */
    @objc private func notificationAction(notification: Notification) {
        if let text = notification.userInfo?["text"] as? String {
            if !text.isEmpty {
                viewModel.visibleSpotifyTracks = viewModel.spotifyTracks.filter {
                    return $0.name?.range(of: text, options: .caseInsensitive) != nil
                }
            } else {
                viewModel.visibleSpotifyTracks = viewModel.spotifyTracks
            }

            musicTableView.reloadData()
        }
    }
    
    /* Reload Music Table View After Search Bar */
    @objc private func updateMusicTableView(notification: Notification) {
        musicTableView.reloadData()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellYPos = musicTableView.contentOffset.y
        let posDict: [String: CGFloat] = ["yPos": cellYPos]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ScrollMyMusic"), object: nil, userInfo: posDict)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        
        DispatchQueue.main.async {
            self.viewModel.checkSpotify(refresh: true) { (result) in
                print("UPDATING...")
                self.refreshControl.endRefreshing()
                
                switch result {
                case .failure(let error):
                    if error == .NoPlaylists { // No playlists
//                        self.errorMsg = "You have no playlists in your spotify account"
                        print("You have no playlists in your sporify account")
                    } else { // Not signed in
//                        self.errorMsg = "To see your tracks you have to sign in to your spotify account"
                        print("To see your tracks you have to sign in to your spotify account")
                    }
                    break
                default:
                    self.musicTableView.reloadData()
                    break
                }

            }
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MusicTabBarCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.visibleSpotifyTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicTableCellId", for: indexPath) as! MyMusicTableCell
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
    
    // Adding Track
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

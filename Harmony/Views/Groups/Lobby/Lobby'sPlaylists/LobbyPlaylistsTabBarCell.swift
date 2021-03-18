//
//  LobbyPlaylistsTabBarCell.swift
//  Harmony
//
//  Created by Macbook Pro on 11.03.2021.
//

import UIKit

class LobbyPlaylistsTabBarCell: UICollectionViewCell {
    
    private var lobbyPlaylistsTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    
        setupTableView()
    }
    
    private func setupTableView() {
        
        lobbyPlaylistsTableView.dataSource = self
        lobbyPlaylistsTableView.register(GroupCell.self, forCellReuseIdentifier: "lobbyPlaylistsCellId")
        lobbyPlaylistsTableView.separatorStyle = .none
        lobbyPlaylistsTableView.backgroundColor = .clear
        lobbyPlaylistsTableView.translatesAutoresizingMaskIntoConstraints = false
        lobbyPlaylistsTableView.frame = contentView.frame
        
        contentView.addSubview(lobbyPlaylistsTableView)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LobbyPlaylistsTabBarCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lobbyPlaylistsCellId", for: indexPath) as! GroupCell
        cell.selectionStyle = .none
        cell.logoImageView.image = UIImage(named: "groupImage")
        cell.titleLabel.text = "Group Title"
        cell.msgLabel.text = "236 Tracks"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.15
    }
}

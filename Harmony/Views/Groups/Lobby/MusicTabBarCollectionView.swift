//
//  MusicTabBarCollectionView.swift
//  Harmony
//
//  Created by Macbook Pro on 10.03.2021.
//

import UIKit

class MusicTabBarCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cellsCount = 2
    var viewModel: GroupViewModel?

    init(viewModel: GroupViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(MusicTabBarCell.self, forCellWithReuseIdentifier: "musicSectionId")
        register(LobbyPlaylistsTabBarCell.self, forCellWithReuseIdentifier: "lobbyPlaylistsSectionId")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 { // My Music Section
            let cell = dequeueReusableCell(withReuseIdentifier: "musicSectionId", for: indexPath) as! MusicTabBarCell
            cell.viewModel = viewModel
            return cell
        } else { // Lobby's Playlists Section
            let cell = dequeueReusableCell(withReuseIdentifier: "lobbyPlaylistsSectionId", for: indexPath) as! LobbyPlaylistsTabBarCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

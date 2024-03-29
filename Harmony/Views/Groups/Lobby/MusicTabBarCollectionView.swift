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
    var errorMsg: String

    init(viewModel: GroupViewModel, errorMsg: String) {
        self.viewModel = viewModel
        self.errorMsg = errorMsg
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(MusicTabBarCell.self, forCellWithReuseIdentifier: "musicSectionId")
        register(ErrorMusicTabBarCell.self, forCellWithReuseIdentifier: "musicErrorSectionId")
        register(LobbyPlaylistsTabBarCell.self, forCellWithReuseIdentifier: "lobbyPlaylistsSectionId")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 { // My Music Section
            if errorMsg.isEmpty {
                let cell = dequeueReusableCell(withReuseIdentifier: "musicSectionId", for: indexPath) as! MusicTabBarCell
                cell.viewModel = viewModel
                return cell
            } else {
                let cell = dequeueReusableCell(withReuseIdentifier: "musicErrorSectionId", for: indexPath) as! ErrorMusicTabBarCell
                cell.setupErrorLabel(errorMsg: errorMsg)
                return cell
            }
        } else { // Lobby's Playlists Section
            let cell = dequeueReusableCell(withReuseIdentifier: "lobbyPlaylistsSectionId", for: indexPath) as! LobbyPlaylistsTabBarCell
            cell.viewModel = viewModel
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cellXPos = visibleCells[0].frame.minX
        let posDict: [String: CGFloat] = ["xPos": cellXPos]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SlideMusicSections"), object: nil, userInfo: posDict)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

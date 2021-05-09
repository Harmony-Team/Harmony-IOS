//
//  LatestGroupsCollectionView.swift
//  Harmony
//
//  Created by Macbook Pro on 10.03.2021.
//

import UIKit

class LatestGroupsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var viewModel: ProfileViewModel
    
    var cellsCount = 10
    private static var cellScale: CGFloat = 0.18
    private var spacing: CGFloat = UIScreen.main.bounds.width * ((1 - cellScale * 4) / 5)

    init(viewModel: ProfileViewModel) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.viewModel = viewModel
        super.init(frame: .zero, collectionViewLayout: layout)
        
        viewModel.onUpdate = { [weak self] in
            self?.reloadData()
        }
        
        viewModel.viewDidLoad()
        
        contentInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        showsHorizontalScrollIndicator = false
        
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(LatestGroupsCell.self, forCellWithReuseIdentifier: "latestGroupId")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "latestGroupId", for: indexPath) as! LatestGroupsCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * LatestGroupsCollectionView.cellScale, height: frame.width * LatestGroupsCollectionView.cellScale)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

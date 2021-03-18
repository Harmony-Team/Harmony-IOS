//
//  GroupUsersCollectionView.swift
//  Harmony
//
//  Created by Macbook Pro on 11.03.2021.
//

import UIKit

class GroupUsersCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cellsCount = 10
    private static var cellScale: CGFloat = 0.26
    private var spacing: CGFloat = UIScreen.main.bounds.width * ((1 - cellScale * 3.5) / 4)
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        contentInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        showsHorizontalScrollIndicator = false
        
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(GroupUsersCell.self, forCellWithReuseIdentifier: "groupUserId")
        register(GroupAddUserCell.self, forCellWithReuseIdentifier: "groupAddUserId")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return cellsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = dequeueReusableCell(withReuseIdentifier: "groupAddUserId", for: indexPath) as! GroupAddUserCell
            return cell
        } else {
            let cell = dequeueReusableCell(withReuseIdentifier: "groupUserId", for: indexPath) as! GroupUsersCell
            if indexPath.row == 0 { // set gradient border for admin user
                cell.isAdmin = true
            } else { // set white border for other users
                cell.isAdmin = false
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets.zero
        } else {
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * GroupUsersCollectionView.cellScale, height: frame.width * GroupUsersCollectionView.cellScale)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Select")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

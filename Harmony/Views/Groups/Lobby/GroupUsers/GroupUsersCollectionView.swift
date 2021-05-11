//
//  GroupUsersCollectionView.swift
//  Harmony
//
//  Created by Macbook Pro on 11.03.2021.
//

import UIKit

class GroupUsersCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var viewModel: GroupViewModel
    var groupAdmin: String
    var groupUsers: [GroupUsers] // Group Users
    private static var cellScale: CGFloat = 0.25
    private var spacing: CGFloat = UIScreen.main.bounds.width * ((1 - cellScale * 3.5) / 4)
    
    init(viewModel: GroupViewModel, groupAdmin: String, groupUsers: [GroupUsers]) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.viewModel = viewModel
        self.groupAdmin = groupAdmin
        self.groupUsers = groupUsers.filter{$0.login != groupAdmin}
        super.init(frame: .zero, collectionViewLayout: layout)
        
        contentInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        showsHorizontalScrollIndicator = false
        
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(GroupUsersCell.self, forCellWithReuseIdentifier: "groupUserAdminId")
        register(GroupUsersCell.self, forCellWithReuseIdentifier: "groupUserId")
        register(GroupAddUserCell.self, forCellWithReuseIdentifier: "groupAddUserId")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }
        return groupUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = dequeueReusableCell(withReuseIdentifier: "groupAddUserId", for: indexPath) as! GroupAddUserCell
            return cell
        } else if indexPath.section == 1 {
            let cell = dequeueReusableCell(withReuseIdentifier: "groupUserAdminId", for: indexPath) as! GroupUsersCell
            cell.userName.text = groupAdmin.uppercased()
            cell.isAdmin = true
            return cell
        } else {
            let cell = dequeueReusableCell(withReuseIdentifier: "groupUserId", for: indexPath) as! GroupUsersCell
            cell.update(viewModel: GroupUsersCellViewModel(groupUser: groupUsers[indexPath.row]))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 || section == 1 {
            return UIEdgeInsets.zero
        } else {
            return UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * GroupUsersCollectionView.cellScale, height: frame.width * GroupUsersCollectionView.cellScale)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.goToSearchFriends()
        } else {
            print("Select")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

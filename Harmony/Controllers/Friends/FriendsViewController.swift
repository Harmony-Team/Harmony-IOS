//
//  FriendsViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

class FriendsViewController: UIViewController {
    
    var viewModel: FriendsViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBg(image: nil, colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 1)
        customizeNavBarController(bgColor: .bgColor, textColor: .white)
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: "friendCell")
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
        cell.checkImageView.isHidden = true
        cell.addFriendButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

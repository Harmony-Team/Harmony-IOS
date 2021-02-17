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
        
        setupTableView()
    }
    
    private func setupTableView() {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
//        cell.transform = CGAffineTransform(translationX: tableView.bounds.width / 2, y: 0)
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0.05 * Double(indexPath.row),
            options: [.transitionFlipFromLeft],
            animations: {
//                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

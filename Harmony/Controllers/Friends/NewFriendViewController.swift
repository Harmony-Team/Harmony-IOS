//
//  NewFriendViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 07.02.2021.
//

import UIKit

class NewFriendViewController: UIViewController {
    
    var viewModel: NewFriendViewModel!

    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "New Friend"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeWithoutSaving))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTableView()
    }
    
    private func setupTableView() {
        friendsTableView.contentInsetAdjustmentBehavior = .never
        friendsTableView.setContentOffset(CGPoint(x: 0, y: -1), animated: false)
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        friendsTableView.register(FriendCell.self, forCellReuseIdentifier: "friendCell")
    }
    
    /* Close window without saving */
    @objc private func closeWithoutSaving() {
        dismiss(animated: true, completion: nil)
        viewModel.closeWindow()
    }

}

extension NewFriendViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        cell.selectionStyle = .none
        cell.nameLabel.text = "Friend Name"
        cell.infoLabel.text = "Info"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        if cell.isSelected { cell.isSelected = false }
        else { cell.isSelected = true }
    }
}


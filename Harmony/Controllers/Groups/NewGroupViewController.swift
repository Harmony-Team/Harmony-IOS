//
//  NewGroupViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

class NewGroupViewController: UIViewController {
    
    var viewModel: NewGroupViewModel!
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var photoImagePicker: UIImageView!
    @IBOutlet weak var membersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New Group"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeWithoutSaving))
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        
        setupTableView()
    }
    
    private func setupTableView() {
        membersTableView.dataSource = self
        membersTableView.delegate = self
        membersTableView.register(FriendCell.self, forCellReuseIdentifier: "friendCell")
    }
    
    /* Close window without saving */
    @objc private func closeWithoutSaving() {
        dismiss(animated: true, completion: nil)
        viewModel.closeWindow()
    }
    
    /* Create group chat and close window */
    @IBAction func createGroupChat(_ sender: UIButton) {
    }
}

extension NewGroupViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Members"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        cell.selectionStyle = .none
        cell.nameLabel.text = "Friend Name"
        cell.infoLabel.text = "Info"
        cell.addFriendButton.isHidden = true
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


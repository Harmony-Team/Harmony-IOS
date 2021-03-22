//
//  GroupsViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

class GroupsListViewController: UIViewController {
    
    var viewModel: GroupsListViewModel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var groupsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBg(image: nil, colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 1)
        customizeNavBarController(bgColor: .bgColor, textColor: .white)
        
        topImage.setupTopGradientMask(with: topView)
        setupTableView()
        
        viewModel.onUpdate = { [weak self] in
            self?.groupsTableView.reloadData()
        }
        
        viewModel.viewDidLoad()
    }
    
    private func setupTableView() {
        groupsTableView.layer.zPosition = 2
        groupsTableView.backgroundColor = .clear
        groupsTableView.dataSource = self
        groupsTableView.delegate = self
        groupsTableView.register(GroupCell.self, forCellReuseIdentifier: "groupCell")
        groupsTableView.register(NewGroupCell.self, forCellReuseIdentifier: "createCell")
    }
    
}

extension GroupsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return viewModel.numberOfCells()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            
            switch viewModel.cellForRow(at: indexPath) {
            case .group(let groupCellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
                cell.selectionStyle = .none
                cell.update(viewModel: groupCellViewModel)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "createCell", for: indexPath) as! NewGroupCell
            cell.selectionStyle = .none
            cell.logoImageView.image = UIImage(systemName: "plus")
            cell.titleLabel.text = "Create a new group..."
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            let label = UILabel()
            label.frame = CGRect.init(x: headerView.frame.height * 2/5, y: headerView.frame.height - 30, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "LATEST GROUPS"
            label.font = UIFont.setFont(size: .Medium)
            label.addKern(1.74)
            label.textColor = .white
            
            headerView.addSubview(label)
            
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.15
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.addNewGroupChat()
        } else {
//            viewModel.goToCurrentGroup()
            viewModel.didSelectRow(at: indexPath)
        }
    }
}


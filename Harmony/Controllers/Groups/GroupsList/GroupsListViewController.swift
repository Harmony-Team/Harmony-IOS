//
//  GroupsViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

class GroupsListViewController: UIViewController {
    
    var viewModel = GroupsListViewModel()
    
    /* Menu */
    private var menuView: SideMenuView!
    
    /* Content */
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var groupsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setting Up Menu And Content */
        setupMenuAndContent()
        customizeNavBarController(bgColor: .bgColor, textColor: .white)
        
        let menuImage = UIImage(named: "menuIcon")?.withRenderingMode(.alwaysTemplate)
        goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: false)
        closeMenuOnTap(nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuImage, style: .done, target: self, action: #selector(toggleMenu))
        // Notification About Chosing Section In Menu
        NotificationCenter.default.addObserver(self, selector: #selector(chooseSection(notification:)), name: NSNotification.Name(rawValue: "ChoseSection"), object: nil)
        
        topImage.setupTopGradientMask(with: topView)
        setupTableView()
        
        /* Loading Groups Table */
        showActivityIndicator()
        viewModel.onUpdate = { [weak self] in
            self?.hideActivityIndicator()
            self?.groupsTableView.reloadData()
        }
    
        viewModel.viewDidLoad()
    }
    
    /* Setting Up Content View And Menu */
    private func setupMenuAndContent() {
        menuView = SideMenuView(frame: view.frame, viewModel: SideMenuViewModel())
        addSideMenuView(menuView: menuView)
        setupContent(menuView: menuView, contentView: contentView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeMenuOnTap(_:completion:)))
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
//        panGestureRecognizer.delegate = self
        contentView.addGestureRecognizer(tap)
//        contentView.addGestureRecognizer(panGestureRecognizer)
        contentView.isUserInteractionEnabled = true
    }
    
    /* Choosing Secton In Menu */
    @objc private func chooseSection(notification: NSNotification) {
        if let section = notification.userInfo?["section"] as? MenuSection {
            closeMenuOnTap(nil) {
                self.viewModel.goToSelectedSection(section: section)
            }
        }
    }
    
    /* Content View Tapped To Close Menu */
    @objc private func closeMenuOnTap(_ sender: UITapGestureRecognizer?, completion: (()->())? = nil) {
        if (viewModel.menuShow) {
            goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: true, completion: completion)
        }
    }
    
    /* Open / Close menu */
    @objc private func toggleMenu(_ sender: UITapGestureRecognizer?) {
        hideActivityIndicator()
        goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: true)
    }

    private func setupTableView() {
        groupsTableView.layer.zPosition = 2
        groupsTableView.showsVerticalScrollIndicator = false
        groupsTableView.backgroundColor = .clear
        groupsTableView.tableFooterView = UIView(frame: CGRect.zero)
        groupsTableView.sectionFooterHeight = 0.0
        groupsTableView.tableFooterView = nil
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.15
    }
    
    /* Header Section */
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.addNewGroupChat()
        } else {
            viewModel.didSelectRow(at: indexPath)
        }
    }
    
    /* Deleting Group */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            callBottomAlert(msg: "Are you sure you want to delete this group?\n This cannot be undone.") { (res) in
                if res == .Success {
                    self.viewModel.deleteGroup(at: indexPath)
                }
            }
        }
    }
}


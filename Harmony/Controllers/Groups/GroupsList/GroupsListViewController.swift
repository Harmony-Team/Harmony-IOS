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
    private var tapGestureRecogniser: UITapGestureRecognizer!
    
    /* Search Section */
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchLobbyField: UITextField!
    @IBOutlet weak var searchIcon: UIImageView!
    
    /* Content */
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var groupsTableView: UITableView!
    
    /* Create Group Or Join Alert */
    private var createOrJoinView: CreateOrJoinView!
    
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
        
        // Notification About Creating Or Joining Group
        NotificationCenter.default.addObserver(self, selector: #selector(createOrJoinGroup(notification:)), name: NSNotification.Name(rawValue: "NewGroupChoice"), object: nil)
        
        topImage.setupTopGradientMask(with: topView)
        setupTableView()
        setupCustomView()
        
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
        menuView = SideMenuView(frame: view.frame, viewModel: SideMenuViewModel(), selectedSection: 1)
        addSideMenuView(menuView: menuView)
        setupContent(menuView: menuView, contentView: contentView)
        
        searchView.setupShadow(cornerRad: searchView.frame.height * 0.5, shadowRad: searchView.frame.height * 0.6, shadowOp: 0.5, offset: CGSize(width: 3, height: 5))
        searchLobbyField.font = UIFont.setFont(size: .Big)
        searchLobbyField.textColor = .mainTextColor
        searchLobbyField.delegate = self
        
        searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
        searchIcon.contentMode = .scaleAspectFill
        searchIcon.tintColor = .mainTextColor
        
        tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(closeMenuOnTap(_:completion:)))
        //        panGestureRecognizer.delegate = self
        //        contentView.addGestureRecognizer(panGestureRecognizer)
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
            goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: true, gestureRecogniser: tapGestureRecogniser, completion: completion)
        }
    }
    
    /* Open / Close menu */
    @objc private func toggleMenu(_ sender: UITapGestureRecognizer?) {
        hideActivityIndicator()
        goToMenu(contentView: contentView, menuShow: &viewModel.menuShow, withAnimation: true, gestureRecogniser: tapGestureRecogniser)
    }
    
    private func setupTableView() {
        //        groupsTableView.contentInset = UIEdgeInsets(top: topView.frame.height * 0.3, left: 0, bottom: 0, right: 0)
        groupsTableView.layer.zPosition = 25
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
    
    /* Setting Up Alert View */
    private func setupCustomView() {
        createOrJoinView = CreateOrJoinView(frame: .zero)
        createOrJoinView.translatesAutoresizingMaskIntoConstraints = false
        createOrJoinView.alpha = 0
        contentView.addSubview(createOrJoinView!)
        
        NSLayoutConstraint.activate([
            createOrJoinView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            createOrJoinView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            createOrJoinView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createOrJoinView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func createOrJoinGroup(notification: NSNotification) {
        if let groupChoice = notification.userInfo?["choice"] as? NewGroupChoice {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.createOrJoinView.transform = CGAffineTransform(translationX: 0, y: 800)
                self.groupsTableView.alpha = 1
                self.searchView.alpha = 1
                self.createOrJoinView.alpha = 0
            }) { _ in
                self.createOrJoinView.transform = CGAffineTransform(translationX: 0, y: 0)
                if groupChoice == .Create {
                    self.viewModel.addNewGroupChat()
                } else {
                    self.viewModel.joinGroup()
                }
            }
        }
    }
}

/* Table View Extension */
extension GroupsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return viewModel.visibleGroups.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "createCell", for: indexPath) as! NewGroupCell
            cell.selectionStyle = .none
            if #available(iOS 13, *) {
                cell.logoImageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
            } else {
                cell.logoImageView.image = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
            }
            cell.titleLabel.text = "Create a new group..."
            return cell
        } else {
            switch viewModel.cellForRow(at: indexPath) {
            case .group(let groupCellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
                cell.selectionStyle = .none
                cell.update(viewModel: groupCellViewModel)
                return cell
            }
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
            UIView.animate(withDuration: 0.3) {
                self.createOrJoinView.alpha = 1
                self.groupsTableView.alpha = 0
                self.searchView.alpha = 0
            }
            //            viewModel.addNewGroupChat()
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

/* Text Field Extension (Searching) */
extension GroupsListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        var searchText = textField.text! + string
        
        if(string.isEmpty) {searchText.removeLast()}
        
        if !searchText.isEmpty {
            viewModel.visibleGroups = viewModel.userGroups.filter {
                return $0.name.range(of: searchText, options: .caseInsensitive) != nil
            }
        } else {
            viewModel.visibleGroups = viewModel.userGroups
        }
        
        viewModel.updateCells()
        
        return true
    }
}

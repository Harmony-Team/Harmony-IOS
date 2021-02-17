//
//  SettingsViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 12.02.2021.
//

import UIKit

class SettingsViewController: UIViewController {

    var viewModel: SettingsViewModel!
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getUserInfoDictionary()
        
        navigationItem.title = "Settings"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupTableView()
    }
    
    private func setupTableView() {
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(SettingsCell.self, forCellReuseIdentifier: "settingsCell")
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "logoutCell")
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .gray
        
        headerView.addSubview(label)
        
        switch section {
        case 0:
            label.text = "PERSONAL INFORMATION"
            break
        case 1:
            label.text = "ABOUT"
            break
        default:
            label.text = "LOGINS"
            break
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return viewModel.userInfoDictionary.count }
        else if section == 1 { return 1 }
        else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
            cell.leftLabel.text = Array(viewModel.userInfoDictionary)[indexPath.row].key
            cell.rightLabel.text = Array(viewModel.userInfoDictionary)[indexPath.row].value
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
            cell.leftLabel.text = "About App"
            cell.rightLabel.text = ""
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)
            cell.textLabel?.text = "Log Out"
            cell.textLabel?.textColor = .red
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            
        } else {
            viewModel.logout()
        }
    }
}

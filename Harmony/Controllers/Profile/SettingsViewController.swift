//
//  SettingsViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 12.02.2021.
//

import UIKit
import WebKit

class SettingsViewController: UIViewController {

    var viewModel: SettingsViewModel!
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBg(image: nil, colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 1)
                
        viewModel.getUserInfoDictionary()
        
        navigationItem.title = "SETTINGS"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupTableView()
    }
    
    private func setupTableView() {
        settingsTableView.backgroundColor = .clear
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(SettingsCell.self, forCellReuseIdentifier: "settingsCell")
    }
    
    @objc private func change(switcher: UISwitch) {
        if switcher.isOn { // Authorize In Spotify
            let spotifyWebView = WKWebView()
            spotifyAuthVC(spotifyWebView: spotifyWebView)
        } else { // Logout From Spotify
            callAlertWithOptions(title: "Spotify Logout", msg: "You will not be able to add your music in lobbies. Are you sure you want to logout?") { (response) in
                if response == .Success {
                    self.viewModel.handleLogout()
                } else {
                    switcher.isOn = true
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.viewDidDisappear()
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            cell.leftLabel.text = Array(viewModel.userInfoDictionary)[indexPath.row].value
            cell.rightLabel.text = "EDIT"
            cell.rightSwitcher.isHidden = true
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
            cell.leftLabel.text = "Spotify"
            cell.rightLabel.text = ""
            cell.rightSwitcher.isOn = SpotifyService.shared.isSignedIn
            cell.rightSwitcher.addTarget(self, action: #selector(change(switcher:)), for: .valueChanged)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
            cell.textLabel?.text = "Log Out"
            cell.textLabel?.textColor = .redTextColor
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.setFont(size: .Large)
            cell.rightSwitcher.isHidden = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.goToEditCell()
        } else if indexPath.section == 1 {
            
        } else {
            viewModel.logout()
        }
    }
    
    /* Header Section */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: view.frame.height * 0.05))
        
        let label = UILabel()
        let labelHeight = headerView.frame.height-10
        label.frame = CGRect.init(x: tableView.frame.width * 0.08, y: 50 - labelHeight, width: headerView.frame.width-50, height: labelHeight)
        label.font = UIFont.setFont(size: .Medium)
        label.addKern(1.74)
        label.textColor = .mainTextColor
        headerView.addSubview(label)
        
        switch section {
        case 0:
            label.text = "USER ACCOUNT"
            break
        case 1:
            label.text = "CONNECTIONS"
            break
        default:
            label.text = "LOGINS"
            break
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height * 0.05
    }
    
    /* Footer Section */
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
        if section != 2 {
            let separator = UIView(frame: CGRect(x: 0, y: view.frame.height * 0.03 - 1, width: tableView.frame.width, height: 1))
            separator.backgroundColor = .gray
            separator.alpha = 0.3
            v.addSubview(separator)
        }
        return v
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 { return 0 }
        else { return view.frame.height * 0.03 }
    }
}

extension SettingsViewController {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        viewModel.requestForCallbackURL(request: navigationAction.request) {
            self.dismiss(animated: true, completion: nil)
        }
        
        decisionHandler(.allow)
    }
}

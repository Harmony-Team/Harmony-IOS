//
//  MusicViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

class MusicViewController: UIViewController {
    
    var viewModel: MusicViewModel!
    
    @IBOutlet weak var musicTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator()
        
        setupTableView()
        
        DispatchQueue.main.async {
            self.viewModel.viewDidLoad {
                self.hideActivityIndicator()
                self.musicTableView.isHidden = false
            }
        }
        viewModel.onUpdate = {
            self.musicTableView.reloadData()
        }
    }
    
    private func setupTableView() {
        musicTableView.dataSource = self
        musicTableView.delegate = self
        musicTableView.register(MusicCell.self, forCellReuseIdentifier: "musicCell")
    }
    
}

extension MusicViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.cellForRow(at: indexPath) {
        case .track(let trackCellViewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as! MusicCell
            cell.update(viewModel: trackCellViewModel)
            cell.durationLabel.text = "3:04"
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.alpha = 0
//        UIView.animate(
//            withDuration: 0.1,
//            delay: 0.05 * Double(indexPath.row),
//            options: [.transitionFlipFromLeft],
//            animations: {
//                cell.alpha = 1
//            })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goToTrack()
    }
}

//
//  MusicTabBarCell.swift
//  Harmony
//
//  Created by Macbook Pro on 10.03.2021.
//

import UIKit

class MusicTabBarCell: UICollectionViewCell {
    
    var viewModel: GroupViewModel!
    private var musicTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    
        setupTableView()
    }
    
    private func setupTableView() {
        
        musicTableView.dataSource = self
        musicTableView.delegate = self
        musicTableView.register(MyMusicTableCell.self, forCellReuseIdentifier: "musicTableCellId")
        musicTableView.separatorStyle = .none
        musicTableView.rowHeight = UIScreen.main.bounds.height * 0.1
        musicTableView.backgroundColor = .clear
        musicTableView.translatesAutoresizingMaskIntoConstraints = false
        musicTableView.frame = contentView.frame
        
        contentView.addSubview(musicTableView)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MusicTabBarCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.cellForRow(at: indexPath) {
        case .track(let trackCellViewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "musicTableCellId", for: indexPath) as! MyMusicTableCell
            cell.update(viewModel: trackCellViewModel)
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? MyMusicTableCell else {return}
        let string = "Song \"" + selectedCell.trackName.text! + "\" was added"
        print(string)
    }
    
}

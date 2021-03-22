//
//  MusicCell.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

class MusicCell: UITableViewCell {
    
    var logoImageView = UIImageView()
    var titleLabel = UILabel()
    var authorLabel = UILabel()
    var durationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupHierarchy()
        setupLayouts()
    }
    
    func update(viewModel: MusicCellViewModel) {
        titleLabel.text = viewModel.trackName
        authorLabel.text = viewModel.trackArtistName
//        logoImageView.downloaded(from: viewModel.trackImage!)
//        viewModel.loadTrackImage { image in
//            self.logoImageView.image = image
//        }
    }
    
    private func setupViews() {
        logoImageView.backgroundColor = .lightGray
        logoImageView.layer.cornerRadius = 15
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        authorLabel.font = .systemFont(ofSize: 16, weight: .medium)
        authorLabel.textColor = .gray
        
        durationLabel.font = .systemFont(ofSize: 16, weight: .medium)
        durationLabel.textColor = .gray
        
        [logoImageView, titleLabel, authorLabel, durationLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func setupHierarchy() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(durationLabel)
    }
    
    private func setupLayouts() {
        logoImageView.pinToEdges(edges: [.left, .top], constant: 15)
        titleLabel.pinToEdges(edges: [.top], constant: 15)
        durationLabel.pinToEdges(edges: [.right], constant: 15)
        
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            
            titleLabel.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 15),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            authorLabel.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 15),
            
            durationLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

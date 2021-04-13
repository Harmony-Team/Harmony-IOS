//
//  MyMusicTableCell.swift
//  Harmony
//
//  Created by Macbook Pro on 10.03.2021.
//

import UIKit

class MyMusicTableCell: UITableViewCell {
    
    var trackLogoView = UIView()
    var trackLogo = TrackImageView()
    private var verticalStack = UIStackView()
    var trackName = UILabel()
    var trackArtist = UILabel()
    private var separatorLine = UIView()
    var addIcon = UIImageView()
    var check = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupViews()
        setupHierarchy()
        setupLayouts()
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.15) {
                    self.addIcon.transform = .init(scaleX: 0.6, y: 0.6)
                } completion: { finished in
                    if finished {
                        self.addIcon.image = UIImage(systemName: "checkmark.circle.fill")
                        UIView.animate(withDuration: 0.15) {
                            self.addIcon.transform = .init(scaleX: 1, y: 1)
                        }
                    }
                }
            } else {
                UIView.animate(withDuration: 0.15) {
                    self.addIcon.transform = .init(scaleX: 0.6, y: 0.6)
                } completion: { finished in
                    if finished {
                        self.addIcon.image = UIImage(systemName: "plus")
                        UIView.animate(withDuration: 0.15) {
                            self.addIcon.transform = .init(scaleX: 1, y: 1)
                        }
                    }
                }
            }
        }
    }
    
    func update(track: SpotifyTrack) {
        trackName.text = track.name
        trackArtist.text = track.artist
        trackLogo.downloaded(from: track.image_url!)
    }
    
    private func setupViews() {
        trackLogoView.setupShadow(cornerRad: 15, shadowRad: 6, shadowOp: 0.3, offset: CGSize(width: 0, height: 6))
        trackLogo.image = UIImage(named: "groupImage")
        trackLogo.contentMode = .scaleAspectFill
        
        verticalStack.axis = .vertical
        verticalStack.spacing = 5
        
        trackName.font = UIFont.setFont(size: .Large, weight: .Light)
        trackName.textColor = .white
        
        trackArtist.font = UIFont.setFont(size: .Medium, weight: .Light)
        trackArtist.textColor = .lightTextColor
        
        addIcon.image = UIImage(systemName: "plus")
        addIcon.tintColor = .redTextColor
        addIcon.contentMode = .scaleAspectFill
        addIcon.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(addIconTapped)))
        
        separatorLine.backgroundColor = .gray
        separatorLine.alpha = 0.3
        
        [trackLogoView, trackLogo, verticalStack, trackName, trackArtist, addIcon, separatorLine].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @objc private func addIconTapped() {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 30
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        self.addIcon.layer.add(pulseAnimation, forKey: nil)
    }
    
    private func setupHierarchy() {
        contentView.addSubview(trackLogoView)
        contentView.addSubview(verticalStack)
        contentView.addSubview(separatorLine)
        contentView.addSubview(addIcon)
        verticalStack.addArrangedSubview(trackName)
        verticalStack.addArrangedSubview(trackArtist)
        trackLogoView.addSubview(trackLogo)
    }
    
    private func setupLayouts() {
        trackLogoView.pinToEdges(edges: [.left], constant: contentView.frame.height * 2/5)
        trackLogo.pinToEdges(constant: 0)
        addIcon.pinToEdges(edges: [.right], constant: contentView.frame.height * 2/5)

        NSLayoutConstraint.activate([
            trackLogoView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            trackLogoView.widthAnchor.constraint(equalTo: trackLogoView.heightAnchor),
            trackLogoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            addIcon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.26),
            addIcon.widthAnchor.constraint(equalTo: addIcon.heightAnchor),
            addIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            verticalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            verticalStack.leftAnchor.constraint(equalTo: trackLogoView.rightAnchor, constant: contentView.frame.height * 2/5),
            verticalStack.rightAnchor.constraint(equalTo: addIcon.leftAnchor, constant: -15),
            
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.leftAnchor.constraint(equalTo: verticalStack.leftAnchor),
            separatorLine.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

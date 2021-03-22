//
//  WaitingFriendsView.swift
//  Harmony
//
//  Created by Macbook Pro on 14.03.2021.
//

import UIKit

class WaitingFriendsView: UIView {
    
    private var topView = UIView()
    private var titleLabel = UILabel()
    private var label1 = UILabel()
    private var label2 = UILabel()
    private var indicatorContainer = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupHierarchy()
        setupLayouts()
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.zPosition = 2
        layer.cornerRadius = 10
        
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor.mainTextColor.cgColor
        topView.layer.cornerRadius = 20
        titleLabel.text = "ELFS ARE WORKING"
        titleLabel.font = UIFont.setFont(size: .Medium)
        titleLabel.textColor = .mainTextColor
        titleLabel.textAlignment = .center
        
        label1.text = "Amazing!"
        label1.font = UIFont.setFont(size: .Largest)
        label1.textAlignment = .center
        label1.textColor = .darkMainTextColor
        
        label2.numberOfLines = 2
        
        let attributedString = NSMutableAttributedString(string: "Now, wait till your friends add their tracks")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length)
        )

        label2.attributedText = attributedString
        label2.font = UIFont.setFont(size: .Largest)
        label2.textAlignment = .center
        label2.textColor = .darkMainTextColor
        
        activityIndicator.color = .mainColor
        activityIndicator.startAnimating()

        [topView, titleLabel, label1, label2, indicatorContainer, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupHierarchy() {
        addSubview(topView)
        topView.addSubview(titleLabel)
        addSubview(label1)
        addSubview(label2)
        addSubview(indicatorContainer)
        indicatorContainer.addSubview(activityIndicator)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            topView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            topView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08),
            topView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            label1.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 30),
            label1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            label1.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 10),
            label2.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            label2.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            indicatorContainer.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: -10),
            indicatorContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicatorContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            indicatorContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: indicatorContainer.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: indicatorContainer.centerXAnchor)
        ])

        titleLabel.pinToEdges()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

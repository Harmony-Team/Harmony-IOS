//
//  CreateOrJoinView.swift
//  Harmony
//
//  Created by Macbook Pro on 11.05.2021.
//

import UIKit

enum NewGroupChoice {
    case Create
    case Join
}

class CreateOrJoinView: UIView {
    
    private var topView = UIView()
    private var titleLabel = UILabel()
    private var orLabel = UILabel()
    private var createGroupButton = LoginButtonStyle()
    private var joinGroupButton = LoginButtonStyle()
    private var cancelButton = UIButton()
    private var bottomLine = UIView()
    
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
        titleLabel.text = "ADD A NEW GROUP"
        titleLabel.font = UIFont.setFont(size: .Medium)
        titleLabel.textColor = .mainTextColor
        titleLabel.textAlignment = .center
        
        createGroupButton.setTitle("CREATE A NEW GROUP", for: .normal)
        createGroupButton.titleLabel?.font = UIFont.setFont(size: .Medium, weight: .Bold)
        createGroupButton.titleLabel?.addKern(1.74)
        createGroupButton.addTarget(self, action: #selector(createGroup), for: .touchUpInside)
                
        joinGroupButton.setTitle("JOIN A GROUP BY CODE", for: .normal)
        joinGroupButton.setTitleColor(.darkMainTextColor, for: .normal)
        joinGroupButton.titleLabel?.font = UIFont.setFont(size: .Medium, weight: .Bold)
        joinGroupButton.titleLabel?.addKern(1.74)
        joinGroupButton.addTarget(self, action: #selector(joinGroup), for: .touchUpInside)
        
        orLabel.text = "OR"
        orLabel.font = UIFont.setFont(size: .Small)
        orLabel.textColor = .mainTextColor
        orLabel.textAlignment = .center
        
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(.mainTextColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont.setFont(size: .Small)
        cancelButton.titleLabel?.addKern(1.74)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        bottomLine.backgroundColor = .lightGray
        
        [topView, titleLabel, createGroupButton, joinGroupButton, orLabel, cancelButton, bottomLine].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    /* Create New Group */
    @objc private func createGroup() {
        let choice = NewGroupChoice.Create
        let result: [String: NewGroupChoice] = ["choice": choice]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewGroupChoice"), object: nil, userInfo: result)
    }
    
    /* Join Group By Link */
    @objc private func joinGroup() {
        let choice = NewGroupChoice.Join
        let result: [String: NewGroupChoice] = ["choice": choice]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewGroupChoice"), object: nil, userInfo: result)
    }
    
    /* Return Back To Groups */
    @objc private func cancel() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BackToGroups"), object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createGroupButton.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: createGroupButton.frame.width * 0.1, startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
        joinGroupButton.setGradientStack(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: joinGroupButton.frame.width * 0.1, startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0))
    }
    
    private func setupHierarchy() {
        addSubview(topView)
        topView.addSubview(titleLabel)
        addSubview(createGroupButton)
        addSubview(joinGroupButton)
        addSubview(orLabel)
        addSubview(cancelButton)
        addSubview(bottomLine)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            topView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            topView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            topView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            createGroupButton.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 30),
            createGroupButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            createGroupButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            createGroupButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.17),
            
            orLabel.topAnchor.constraint(equalTo: createGroupButton.bottomAnchor, constant: 10),
            orLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            joinGroupButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 10),
            joinGroupButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            joinGroupButton.widthAnchor.constraint(equalTo: createGroupButton.widthAnchor),
            joinGroupButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.17),
            
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            cancelButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bottomLine.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 5),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            bottomLine.widthAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1.05),
            bottomLine.centerXAnchor.constraint(equalTo: cancelButton.centerXAnchor)
        ])

        titleLabel.pinToEdges()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


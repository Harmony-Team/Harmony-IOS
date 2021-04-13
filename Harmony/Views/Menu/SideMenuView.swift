//
//  SideMenuView.swift
//  Harmony
//
//  Created by Macbook Pro on 12.04.2021.
//

import UIKit

class SideMenuView: UIView {

    var viewModel: SideMenuViewModel!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var sectionsTableView: UITableView!
    
    private var closeButton = UIButton()
    
    init(frame: CGRect, viewModel: SideMenuViewModel) {
        super.init(frame: frame)
        self.viewModel = viewModel
        
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("MenuView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setupViews()
        setupTableView()
    }
    
    private func setupViews() {
        contentView.setGradientFill(colorTop: UIColor.menuGradientColorTop.cgColor, colorBottom: UIColor.menuGradientColorBottom.cgColor, cornerRadius: 0, startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0), opacity: 1)
        
        closeButton.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeMenu), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    /* Setting Up Sections Table View */
    private func setupTableView() {
        sectionsTableView.allowsMultipleSelection = false
        sectionsTableView.rowHeight = frame.height / 12
        sectionsTableView.backgroundColor = .clear
        sectionsTableView.delegate = self
        sectionsTableView.dataSource = self
        sectionsTableView.register(MenuSectionsCell.self, forCellReuseIdentifier: "menuSectionsCellId")
        
        // Centering Table View
        let headerHeight: CGFloat = (frame.size.height - CGFloat(Int(sectionsTableView.rowHeight) * sectionsTableView.numberOfRows(inSection: 0))) / 2
        sectionsTableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: -headerHeight, right: 0)
    }
    
    /* Sent Notification To Close Side Menu */
    @objc private func closeMenu() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseSideMenu"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SideMenuView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuSectionsCellId", for: indexPath) as! MenuSectionsCell
        cell.sectionNameLabel.text = viewModel.sectionNames[indexPath.row]
        if indexPath.row == 0 { cell.sectionNameLabel.font = UIFont.setFont(size: .Largest, weight: .Bold) } 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? MenuSectionsCell else {return}
//        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        selectedCell.isSelected = true
        viewModel.selectedSection(at: indexPath.row)
    }
}

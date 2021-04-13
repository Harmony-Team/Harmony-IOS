//
//  RecentActivityCollectionView.swift
//  Harmony
//
//  Created by Macbook Pro on 07.04.2021.
//

import UIKit

class RecentActivityCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var user: User!
    
    /* Fade Effect Variables */
    private let fadePercentage: Double = 0.4
    private let gradientLayer = CAGradientLayer()
    private let transparentColor = UIColor.clear.cgColor
    private let opaqueColor = UIColor.black.cgColor
    
    private var topOpacity: CGColor {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height * 0.8
        let scrollOffset = contentOffset.y
        
        let alpha: CGFloat = (scrollViewHeight >= scrollContentSizeHeight || scrollOffset <= 0) ? 1 : 0.2
        
        let color = UIColor(white: 0, alpha: alpha)
        return color.cgColor
    }
        
    private var bottomOpacity: CGColor {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y
        
        let alpha:CGFloat = (scrollViewHeight >= scrollContentSizeHeight || scrollOffset + scrollViewHeight >= scrollContentSizeHeight) ? 1 : 0

        let color = UIColor(white: 0, alpha: alpha)
        return color.cgColor
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        showsVerticalScrollIndicator = false
        
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(RecentActivityCell.self, forCellWithReuseIdentifier: "recentActivityId")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.delegate = self
        let maskLayer = CALayer()
        maskLayer.frame = self.bounds
        
        gradientLayer.frame = CGRect(x: self.bounds.origin.x, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        gradientLayer.colors = [topOpacity, opaqueColor, opaqueColor, bottomOpacity]
        gradientLayer.locations = [0, NSNumber(floatLiteral: fadePercentage), NSNumber(floatLiteral: 1 - fadePercentage), 1]
        maskLayer.addSublayer(gradientLayer)

        self.layer.mask = maskLayer
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "recentActivityId", for: indexPath) as! RecentActivityCell
        cell.update(viewModel: RecentActivityCellViewModel())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * 0.8, height: frame.height * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 14
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Select")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

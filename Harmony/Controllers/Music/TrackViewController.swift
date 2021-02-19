//
//  TrackViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 18.02.2021.
//

import UIKit

class TrackViewController: UIViewController {
    
    var viewModel: TrackViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemPink
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.viewDidDisappear()
    }
    
}

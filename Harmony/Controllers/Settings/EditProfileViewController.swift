//
//  EditProfileViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 12.02.2021.
//

import UIKit

class EditProfileViewController: UIViewController {

    var viewModel: EditProfileViewModel!
    
    @IBOutlet weak var editTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBg(image: nil, colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 1)
        
        navigationItem.title = "SETTINGS"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        editTextField.addPadding(.both(15))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.viewDidDisappear()
    }
    
    deinit {
        print("DEINIT: Edit Controller")
    }

}

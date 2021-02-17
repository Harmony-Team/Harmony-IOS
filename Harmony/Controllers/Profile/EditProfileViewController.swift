//
//  EditProfileViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 12.02.2021.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var editTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editTextField.addPadding(.both(15))
    }

}

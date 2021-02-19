//
//  ChatViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 06.02.2021.
//

import UIKit

class ChatViewController: UIViewController {
    
    var viewModel: ChatViewModel!

    @IBOutlet weak var msgTextField: UITextField!
    @IBOutlet weak var attachFilesButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Chat"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow_back"), style: .done, target: self, action: #selector(back))
        
        setupViews()
    }
    
    func setupViews() {
        msgTextField.layer.cornerRadius = 15
        msgTextField.addPadding(.both(15))
        
        var image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        sendButton.setImage(image, for: .normal)
        sendButton.tintColor = .mainColor
        
        image = UIImage(named: "attach")?.withRenderingMode(.alwaysTemplate)
        attachFilesButton.setImage(image, for: .normal)
        attachFilesButton.tintColor = .mainColor
    }
    
    @objc private func back() {
        dismissFromLeft()
        viewModel.viewDidDisappear()
    }

    @IBAction func didSendMsg(_ sender: UIButton) {
    }
    
    
    @IBAction func didAttachFiles(_ sender: UIButton) {
    }
}

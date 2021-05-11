//
//  ShareLinkViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 10.03.2021.
//

import UIKit

class ShareLinkViewModel {
    
    var coordinator: ShareLinkCoordinator!
    var inviteCode: String!
    
    func goToGroup() {
        coordinator.closeWithoutSaving()
    }
    
}

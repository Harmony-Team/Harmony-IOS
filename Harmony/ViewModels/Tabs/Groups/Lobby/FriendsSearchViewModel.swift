//
//  FriendsSearchViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 06.05.2021.
//

import UIKit

class FriendsSearchViewModel {
    
    var coordinator: FriendsSearchCoordinator!
    
    private var ApiManager = APIManager.shared
    
    func goToLobbyViewController() {
        coordinator.goToLobby()
    }
    
}

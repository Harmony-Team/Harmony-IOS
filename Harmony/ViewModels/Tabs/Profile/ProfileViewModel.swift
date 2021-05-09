//
//  ProfileViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

class ProfileViewModel {
    
    // Menu
    var menuShow = false
    var isChosen = true
    
    var coordinator: ProfileCoordinator!
    var user: User!
    var spotifyUser: SpotifyUser?
    var spotifyService = SpotifyService.shared
    
    // Groups Info
    private var apiManager = APIManager.shared
    var onUpdate = {}
    
    enum Cell {
        case group(viewModel: GroupCellViewModel)
    }
    private(set) var cells: [Cell] = []
    
    /* Get user info from UserDefaults */
    func getUserInfo(completion: ()->()) {
        
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            return
        }
        
        if let user: User = UserProfileCache.get(key: "user") {
            self.user = user
        } else {
            let semaphore = DispatchSemaphore(value: 0)
            
            APIManager.shared.getUserAPI(token: token) { user in
                self.user = user
                semaphore.signal()
            }
            
            semaphore.wait()
        }
        completion()
        
    }
    
    func viewDidLoad() {
        getLatestGroups()
    }
    
    /* Get latest user groups */
    func getLatestGroups() {
        apiManager.getGroups { groups in
            var reversedGroups = [UserGroup]()
            for group in groups {
                reversedGroups.insert(group, at: 0)
            }
            self.cells = reversedGroups.map {
                var groupCellViewModel = GroupCellViewModel(group: $0)
                if let coordinator = self.coordinator {
                    groupCellViewModel.onSelect = coordinator.goToCreatedGroup
                }
                return .group(viewModel: groupCellViewModel)
            }
            DispatchQueue.main.async {
                self.onUpdate()
            }
        }
    }
    
    /* Check if user is logged in Spotify */
    func checkSpotify() {
        
        //        if UserDefaults.standard.bool(forKey: "isLoggedSpotify") {
        //            print("Logged")
        //            spotifyUser = UserProfileCache.get(key: "spotifyUser")
        //            getPlaylists(for: spotifyUser!)
        //            print(spotifyUser?.spotifyAccessToken)
        //        } else {
        //            print("Not logged")
        //        }
        
    }
    
    func numberOfCells() -> Int {
        return cells.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> Cell {
        return cells[indexPath.row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case .group(let groupCellViewModel):
            groupCellViewModel.didSelect()
        }
    }
    
    /* Go to user settings */
    func goToSettings() {
        coordinator.goToSettings(for: user)
    }
    
    /* Go To Selected Section */
    func goToSelectedSection(section: MenuSection) {
        coordinator.goToSection(section: section)
    }
    
}

//
//  JoinGroupViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 11.05.2021.
//

import UIKit

class JoinGroupViewModel {
    
    var coordinator: JoinGroupCoordinator!
    
    /* Join New Group By Invite Code */
    func joinGroupByCode(code: String, completion: @escaping ((String?, UserGroup?)) -> ()) {
        APIManager.shared.joinGroupByCode(code: code) { (arg) in
            let (msg, group) = arg
            if let errorMsg = msg {
                completion((errorMsg, nil))
            } else {
                completion((nil, group!.object))
            }
        }
    }
    
    /* Open New Group Screen */
    func goToJoinedGroup(group: UserGroup) {
        coordinator.goToJoinedGroup(group: group)
    }
    
    func goToGroup() {
        coordinator.closeWithoutSaving(true)
    }
    
    func closeWindow() {
        coordinator.closeWithoutSaving(nil)
    }
}

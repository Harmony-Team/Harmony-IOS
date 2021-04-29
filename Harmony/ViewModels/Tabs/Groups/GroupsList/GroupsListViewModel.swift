//
//  GroupViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

class GroupsListViewModel {
    
    var coordinator: GroupsListCoordinator!
    private let coreDataManager: GroupsCoreDataManager
    var onUpdate = {}
    
    // Menu
    var menuShow = false
    
    init(coreDataManager: GroupsCoreDataManager = GroupsCoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    enum Cell {
        case group(viewModel: GroupCellViewModel)
    }
    private(set) var cells: [Cell] = []
    
    func viewDidLoad() {
        reload()
    }
    
    func reload() {
        APIManager.shared.getGroups { groups in
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
//        let groups = coreDataManager.fetchGroups()
//        cells = groups.map {
//            var groupCellViewModel = GroupCellViewModel(group: $0)
//            if let coordinator = coordinator {
//                groupCellViewModel.onSelect = coordinator.goToCreatedGroup
//            }
//            return .group(viewModel: groupCellViewModel)
//        }
//        onUpdate()
    }
    
    /* Create new group */
    func addNewGroupChat() {
        coordinator.addNewGroup()
    }
    
    /* Delete group */
    func deleteGroup(at indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case .group(_):
//            let id = groupCellViewModel.group.objectID
//            coreDataManager.deleteGroup(id: id)
            reload()
        }
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
    
    /* Go To Selected Section */
    func goToSelectedSection(section: MenuSection) {
        coordinator.goToSection(section: section)
    }
    
}

//
//  GroupViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

class GroupsListViewModel {
    
    var coordinator: GroupsListCoordinator!
    private let coreDataManager: CoreDataManager
    var onUpdate = {}
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
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
        let groups = coreDataManager.fetchGroups()
        cells = groups.map {
            var groupCellViewModel = GroupCellViewModel(group: $0)
            if let coordinator = coordinator {
                groupCellViewModel.onSelect = coordinator.goToCreatedGroup
            }
            return .group(viewModel: groupCellViewModel)
        }
        onUpdate()
    }
    
    /* Create new group */
    func addNewGroupChat() {
        coordinator.addNewGroup()
    }
    
    /* Delete group */
    func deleteGroup(at indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case .group(let groupCellViewModel):
            let id = groupCellViewModel.group.objectID
            coreDataManager.deleteGroup(id: id)
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
    
}

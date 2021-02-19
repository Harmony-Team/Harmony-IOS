//
//  TrackViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 18.02.2021.
//

import UIKit

class TrackViewModel {
    
    var coordinator: TrackCoordinator!
    
    func viewDidDisappear() {
        coordinator.goBack()
    }
    
}

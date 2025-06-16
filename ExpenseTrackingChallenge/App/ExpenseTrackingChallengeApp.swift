//
//  ExpenseTrackingChallengeApp.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import SwiftUI

@main
struct ExpenseTrackingChallengeApp: App {
    private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.rootView
        }
    }
}

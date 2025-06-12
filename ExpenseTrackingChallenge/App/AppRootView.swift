//
//  AppRootView.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import SwiftUI

struct AppRootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    typealias Screen = AppCoordinator.Screen
    private let defaultView: Screen = .receiptHistory
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.view(for: defaultView)
                .navigationDestination(for: AppCoordinator.Screen.self) { screen in
                    coordinator.view(for: screen)
                }
        }
    }
}

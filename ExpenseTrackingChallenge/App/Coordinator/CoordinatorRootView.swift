//
//  CoordinatorRootView.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 16/06/2025.
//

import SwiftUI

struct CoordinatorRootView<C: CoordinatorProtocol>: View {
    @ObservedObject var coordinator: C

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.mainView
                .navigationDestination(for: C.Route.self) { page in
                    coordinator.build(page: page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet: sheet)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { cover in
                    coordinator.build(fullScreenCover: cover)
                }
        }
    }
}

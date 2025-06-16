//
//  CoordinatorProtocol.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 14/06/2025.
//

import SwiftUI

@MainActor
@preconcurrency
protocol CoordinatorProtocol: ObservableObject {
    associatedtype MainView: View

    associatedtype RouteView: View
    associatedtype SheetView: View
    associatedtype FullScreenCoverView: View

    associatedtype Route: Hashable
    associatedtype Sheet: Identifiable
    associatedtype FullScreenCover: Identifiable

    var mainView: MainView { get }

    var path: NavigationPath { get set }

    var sheet: Sheet? { get set }
    var fullScreenCover: FullScreenCover? { get set }

    @ViewBuilder func build(page: Route) -> RouteView
    @ViewBuilder func build(sheet: Sheet) -> SheetView
    @ViewBuilder func build(fullScreenCover: FullScreenCover) -> FullScreenCoverView
}

extension CoordinatorProtocol {
    func push(_ page: Route) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }

    func present(sheet: Sheet) {
        self.sheet = sheet
    }
    
    func dismissSheet() {
        sheet = nil
    }

    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func dismissFullScreenCover() {
        fullScreenCover = nil
    }
}

extension CoordinatorProtocol {
    public var rootView: some View {
        CoordinatorRootView(coordinator: self)
    }
}

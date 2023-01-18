//
//  LocalChangesViewModel.swift
//  GitBuddy
//
//  Created by Artur Hellmann on 14.01.23.
//

import SwiftUI
import GitCaller

@MainActor
class LocalChangesViewModel: BaseViewModel {

    @Published var status: StatusResult?
    @Published var commitMessage: String = ""
    
    init(repository: some Repository, status: StatusResult) {
        self.status = status
        super.init(repository: repository)
    }
    
    func load() {
        defaultTask { [weak self] in
            self?.status = try await self?.repository.getStatus()
        }
    }
    
    func stage(change: Change) {
        defaultTask { [weak self] in
            _ = try await self?.repository.stage(file: change.path)
            self?.load()
        }
    }
    
    func unstage(change: Change) {
        defaultTask { [weak self] in
            _ = try await self?.repository.unstage(file: change.path)
            self?.load()
        }
    }
    
    func commit() {
        defaultTask { [weak self] in
            _ = try await self?.repository.commit(message: self?.commitMessage ?? "")
            self?.commitMessage = ""
            AppDelegate.shared?.reload()
        }
    }
    
    func revert(change: Change) {
        alertItem = AlertItem(
            title: "revert alert title",
            message: "revert alert message",
            actions: [
                AlertButton(
                    title: "revert",
                    role: .destructive,
                    action: { [weak self] in
                        self?.defaultTask {
                            _ = try await self?.repository.revert(unstagedFile: change.path)
                            self?.load()
                        }
                    }
                )
            ]
        )
    }
}

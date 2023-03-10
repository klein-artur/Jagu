//
//  BranchElementViewModel.swift
//  Jagu
//
//  Created by Artur Hellmann on 17.01.23.
//

import Foundation
import GitCaller

@MainActor
class BranchElementViewModel: BaseRepositoryViewModel {
    
    let branch: Branch
    let status: StatusResult?
    let showLogButton: Bool
    
    init(
        branch: Branch,
        status: StatusResult?,
        showLogButton: Bool
    ) {
        self.branch = branch
        self.status = status
        self.showLogButton = showLogButton
        super.init()
    }
    
    @MainActor
    func pull(force: Bool) {
        if force {
            self.alertItem = AlertItem(
                title: "Force Pull",
                message: "Force Pull Message",
                actions: [
                    AlertButton(title: "yes", role: .destructive, action: { [weak self] in
                        self?.defaultTask {
                            _ = try await self?.repository.pull(force: force)
                        }
                    })
                ]
            )
        } else {
            defaultTask { [weak self] in
                _ = try await self?.repository.pull(force: force)
            }
        }
    }
    
    @MainActor
    func push(force: Bool) {
        if force {
            self.alertItem = AlertItem(
                title: "Force Push",
                message: "Force Push Message",
                actions: [
                    AlertButton(title: "yes", role: .destructive, action: { [weak self] in
                        self?.defaultTask {
                            _ = try await self?.repository.push(force: force)
                        }
                    })
                ]
            )
        } else {
            defaultTask { [weak self] in
                _ = try await self?.repository.push(force: force)
            }
        }
    }
}

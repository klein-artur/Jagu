//
//  CommitListViewModel.swift
//  GitBuddy
//
//  Created by Artur Hellmann on 05.01.23.
//

import Foundation
import GitCaller

@MainActor
class CommitListViewModel: BaseViewModel {
    
    let repository: Repository
    
    let branch: Branch
    @Published var commitList: CommitList?
    
    init(
        repository: Repository,
        branch: Branch
    ) {
        self.branch = branch
        self.repository = repository
        
        super.init()
    
        defaultErrorHandling { [weak self] in
            self?.commitList = try await repository.getLog(branchName: branch.name).commitPathTree
        }
    }
    
    func checkoutBranch() {
        defaultErrorHandling { [weak self] in
            guard let self = self else {
                return
            }
            let result = try await self.repository.checkout(branch: self.branch)
            if result.didChange {
                AppDelegate.shared?.reload()
            }
        }
    }
    
}

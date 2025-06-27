//
//  JaguAppMainViewModel.swift
//  Jagu
//
//  Created by Artur Hellmann on 30.12.22.
//

import Foundation
import SwiftUI
import Combine
import GitCaller
import SwiftDose

@MainActor
class JaguAppMainViewModel: BaseRepositoryViewModel {
    
    @Published var status: StatusResult?
    
    @Dose(of: \.favoriteRepoService) var favoritesService: FavoriteRepoService
    
    private var innerUpdate = false
    @Published var newBranchName: String = "" {
        didSet {
            if !innerUpdate {
                innerUpdate = true
                newBranchName = newBranchName.replacingOccurrences(of: " ", with: "-")
                innerUpdate = false
            }
        }
    }
    
    var isFavorite: Bool {
        favoritesService.favorites.contains { favorite in
            favorite.path == self.repoPath
        }
    }
    
    var repoPathPublisher: (any Publisher<String?, Never>)? {
        didSet {
            guard let repoPathPublisher = repoPathPublisher else { return }
            repoPathPublisher
                .sink { [weak self] in
                    self?.repoName = $0?.lastPathComponent
                    self?.repoPath = $0
                }
                .store(in: &self.lifetimeCancellables)
        }
    }
    
    override func load() {
        defaultTask { [weak self] in
            self?.status = try await self?.repository.getStatus()
        }
    }
    
    override func updateSent() {
        load()
    }
    
    @Published var repoName: String?
    @Published var repoPath: String?
    
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
    
    @MainActor
    func pushNew(branch: Branch) {
        defaultTask { [weak self] in
            _ = try await self?.repository.push(force: false, createUpstream: true, remoteName: "origin", newName: branch.name)
        }
    }
    
    @MainActor
    func checkoutNewBranch() {
        alertItem = AlertItem(
            title: "New Branch",
            message: "New Branch Name",
            actions: [
                AlertTextField(title: "name", text: Binding(get: {
                    self.newBranchName
                }, set: { newValue in
                    self.newBranchName = newValue
                })),
                AlertButton(title: "New Branch", action: { [weak self] in
                    self?.defaultTask({
                        _ = try await self?.repository.newBranchAndCheckout(name: self!.newBranchName)
                        self?.newBranchName = ""
                    })
                }),
                AlertButton(title: "cancel", action: { })
            ]
        )
    }
    
    func pushTags() {
        defaultTask { [weak self] in
            try await self?.repository.pushTags()
        }
    }
    
    func addCurrentAsFavorite() {
        guard let path = self.repoPath else {
            return
        }
        favoritesService.saveFavorite(path: path)
    }
    
    override func shouldHandleError(parseError: ParseError) -> Bool {
        if parseError.type == .notARepository {
            return false
        } else {
            return super.shouldHandleError(parseError: parseError)
        }
    }
}

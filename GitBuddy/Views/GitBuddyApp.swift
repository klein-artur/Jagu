//
//  GitBuddyApp.swift
//  GitBuddy
//
//  Created by Artur Hellmann on 29.12.22.
//

import SwiftUI
import GitCaller

@main
struct GitBuddyApp: App {                                                                                                                                                                                                        
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var mainViewModel: GitBuddyAppMainViewModel = GitBuddyAppMainViewModel(repository: GitRepo.standard)
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if let repoPath = mainViewModel.repoPath {
                    RepoView(viewModel: RepoViewModel(repository: GitRepo.standard, repoPath: repoPath, appDelegate: appDelegate))
                } else {
                    NoPathSelectedView()
                        .frame(width: 500, height: 400)
                }
            }
            .navigationTitle(mainViewModel.repoName ?? "Git Buddy")
            .gitErrorAlert(gitError: $mainViewModel.gitError)
            .onAppear {
                self.mainViewModel.repoPathPublisher = appDelegate.$currentRepoDir
            }
            .loading(loadingCount: $mainViewModel.loadingCount)
            .generalAlert(item: $mainViewModel.alertItem)
        }
        .commands {
            CommandMenu("Repository") {
                Button("Fetch") {
                    mainViewModel.defaultTask {
                        try await GitRepo.standard.fetch()
                    }
                }
                .keyboardShortcut("f", modifiers: .command)
                .disabled(mainViewModel.status == nil)
                if let shouldForce = mainViewModel.status?.branch.shouldForcePull {
                    Button(shouldForce ? "Force Pull" : "Pull") {
                        mainViewModel.pull(force: shouldForce)
                    }
                    .keyboardShortcut("p", modifiers: shouldForce ? [.command, .shift] : .command)
                } else {
                    Button("Pull") { }
                    .keyboardShortcut("p", modifiers: .command)
                    .disabled(true)
                }
                if let shouldForce = mainViewModel.status?.branch.shouldForcePush {
                    Button(shouldForce ? "Force Push" : "Push") {
                        mainViewModel.push(force: shouldForce)
                    }
                    .keyboardShortcut("u", modifiers: shouldForce ? [.command, .shift] : .command)
                } else {
                    Button("Push") { }
                    .keyboardShortcut("u", modifiers: .command)
                    .disabled(true)
                }
                Button("New Branch") {
                    mainViewModel.checkoutNewBranch()
                }
                .keyboardShortcut("b", modifiers: [.command, .shift])
                .disabled(mainViewModel.status == nil)
            }
            CommandGroup(replacing: .newItem) {
                Button {
                    AppDelegate.shared?.openFile()
                } label: {
                    Text("Open")
                }
                .keyboardShortcut("o", modifiers: .command)
                Button {
                    GitRepo.standard.objectWillChange.send()
                } label: {
                    Text("Reload")
                }
                .keyboardShortcut("r", modifiers: .command)
            }
            CommandGroup(replacing: .saveItem) {}
            CommandGroup(replacing: .undoRedo) {}
            CommandGroup(replacing: .textFormatting) {}
        }
    }
}

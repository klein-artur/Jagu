//
//  JaguApp.swift
//  Jagu
//
//  Created by Artur Hellmann on 29.12.22.
//

import SwiftUI
import GitCaller
import Combine

@main
struct
JaguApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var mainViewModel: JaguAppMainViewModel = JaguAppMainViewModel()
    
    @State var showCommandView: Bool = false
    @State var showCommitList: Bool = false
    @State var showFavorites: Bool = false
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if let repoPath = mainViewModel.repoPath {
                    RepoView(viewModel: RepoViewModel(repoPath: repoPath, appDelegate: appDelegate))
                } else {
                    NoPathSelectedView()
                        .frame(width: 500, height: 400)
                }
            }
            .navigationTitle(mainViewModel.repoName ?? "Jagu")
            .gitErrorAlert(gitError: $mainViewModel.gitError)
            .onAppear {
                self.mainViewModel.repoPathPublisher = appDelegate.$currentRepoDir
            }
            .showLoadingIndicator()
            .generalAlert(item: $mainViewModel.alertItem)
            .sheet(isPresented: $showCommandView) {
                CommandInputView(viewModel: CommandInputViewModel())
            }
            .sheet(isPresented: $showFavorites, content: {
                FavoritesView(
                    viewModel: FavoritesViewModel(
                        favoriteRepoService: FavoriteRepoService()
                    )
                )
            })
            .commitSheet(presented: $showCommitList)
            .if(mainViewModel.repoName != nil) { view in
                view.toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(mainViewModel.repoName ?? "")
                            .font(.headline)
                            .lineLimit(1)
                    }
                }
            }
        }
        .commands {
            CommandMenu("Actions") {
                Button ("Run") {
                    showCommandView = true
                }
                .keyboardShortcut("r", modifiers: [.command, .shift])
                .disabled(mainViewModel.status == nil)
            }
            CommandMenu("Repository") {
                Button("Fetch") {
                    mainViewModel.defaultTask(infoText: "Fetching new data".localized) {
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
                if let branch = mainViewModel.status?.branch, branch.upstream == nil {
                    Button("Push New Branch") {
                        mainViewModel.pushNew(branch: branch)
                    }
                    .keyboardShortcut("u", modifiers: [.command, .option])
                }
                Button("New Branch") {
                    mainViewModel.checkoutNewBranch()
                }
                .keyboardShortcut("b", modifiers: [.command, .shift])
                .disabled(mainViewModel.status == nil)
                Divider()
                Button("Commits") {
                    showCommitList = true
                }
                Divider()
                Button("push tags") {
                    mainViewModel.pushTags()
                }
            }
            CommandGroup(replacing: .newItem) {
                Button {
                    AppDelegate.shared?.openFile()
                } label: {
                    Text("Open")
                }
                .keyboardShortcut("o", modifiers: .command)
                Button {
                    self.showFavorites = true
                } label: {
                    Text("Favorites")
                }
                .keyboardShortcut("o", modifiers: [.command, .option])
                Button {
                    mainViewModel.addCurrentAsFavorite()
                } label: {
                    Text("Save favorite")
                }
                .disabled(mainViewModel.status == nil || mainViewModel.isFavorite)
                Button {
                    GitRepo.standard.repositoryUpdated.send()
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

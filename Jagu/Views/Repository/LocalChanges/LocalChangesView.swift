//
//  LocalChangesView.swift
//  Jagu
//
//  Created by Artur Hellmann on 14.01.23.
//

import SwiftUI
import GitCaller
import SwiftDose

struct LocalChangesView: View {
    @StateObject var viewModel: LocalChangesViewModel
    
    @State var localChangesFilePath: DiffChange?
    
    var body: some View {
        VStack {
            ScrollView {
                if viewModel.status != nil {
                    VStack {
                        if viewModel.status?.status == .merging || viewModel.status?.status == .rebasing {
                            HStack {
                                Text(
                                    viewModel.mergeOrRebaseInfo
                                )
                                if viewModel.canContinue {
                                    Text("No Mergeissues")
                                }
                                Spacer()
                                Button {
                                    viewModel.abort()
                                } label: {
                                    Text(
                                        viewModel.status?.status == .merging ? "abort merge" : "abort rebase"
                                    )
                                }
                            }
                        }
                        group(for: viewModel.unstagedChanges, staged: false)
                        group(for: viewModel.stagedChanges, staged: true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
            if let status = viewModel.status, !status.stagedChanges.isEmpty || status.canContinue {
                HStack{
                    InsetTextEditor(text: $viewModel.commitMessage)
                        .verticalInset(8)
                        .horizontalInset(8)
                        .frame(height: 50.0)
                        .cornerRadius(5.0)
                    Button {
                        viewModel.commit()
                    } label: {
                        Text(status.status == .merging || status.status == .rebasing ? "continue" : "commit")
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.load()
        }
        .gitErrorAlert(gitError: $viewModel.gitError)
        .generalAlert(item: $viewModel.alertItem)
        .tabItem {
            Text(viewModel.viewTitle)
        }
        .sheet(item: $localChangesFilePath) { path in
            DiffView(viewModel: DiffViewModel(leftFile: path.change.leftItem.change.path, staged: path.staged))
                .background(
                    KeyAwareView { event in
                        var newElement: DiffChange? = nil
                        switch event {
                        case .upArrow:
                            newElement = viewModel.getChangeFor(item: path.change, staged: path.staged, offset: -1)
                        case .downArrow:
                            newElement = viewModel.getChangeFor(item: path.change, staged: path.staged, offset: 1)
                        case .enter:
                            if let element = viewModel.getChangeFor(item: path.change, staged: path.staged, offset: 1) ?? viewModel.getChangeFor(item: path.change, staged: path.staged, offset: -1) {
                                newElement = element
                            }
                            if path.staged {
                                viewModel.unstage(change: path.change.leftItem.change)
                            } else {
                                viewModel.stage(change: path.change.leftItem.change)
                            }
                        }
                        if let newElement = newElement {
                            localChangesFilePath = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.localChangesFilePath = newElement
                            }
                        }
                    }
                )
        }
    }
    
    @ViewBuilder
    private func group(for changeList: [ChangeLine], staged: Bool) -> some View {
        let changes = changeList.sorted { left, right in
            left.leftItem.change.path < right.leftItem.change.path
        }
        if !changes.isEmpty {
            GroupBox {
                LazyVStack (alignment: .leading) {
                    ForEach(changeList, id: \.leftItem.change.path) { change in
                        LocalChangeItem(viewModel: viewModel, change: change, staged: staged, localChangesFilePath: $localChangesFilePath)
                    }
                }
            } label: {
                HStack(spacing: 16) {
                    Text(staged ? "staged changes" : "unstaged changes")
                    Spacer()
                    if let text = viewModel.revertButtonText(), !staged {
                        Button(text) {
                            viewModel.revertSelectedCanges()
                        }
                        .buttonStyle(LinkButtonStyle())
                    }
                    Button(viewModel.stageButtonText(staged: staged)) {
                        if staged {
                            viewModel.unstage(change: nil)
                        } else {
                            viewModel.stage(change: nil)
                        }
                    }
                    .buttonStyle(LinkButtonStyle())
                }
            }
        }
    }
}

struct DiffChange: Identifiable {
    var id: String {
        "\(change.leftItem.change.path)---\(staged)"
    }
    let change: ChangeLine
    let staged: Bool
}

struct LocalChangeItem: View {
    let viewModel: LocalChangesViewModel
    @ObservedObject var change: ChangeLine
    let staged: Bool
    @State var showButton: Bool = false
    
    @Binding var localChangesFilePath: DiffChange?
    
    var body: some View {
        HStack {
            if change.rightItem == nil {
                Toggle(
                    "",
                    isOn: $change.selected
                )
            }
            itemView(for: change.leftItem, isLeft: true, change: change, staged: staged)
                .frame(maxWidth: .infinity, alignment: .leading)
            if let rightItem = change.rightItem {
                itemView(for: rightItem, isLeft: false, change: change, staged: staged)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
            }
            if showButton && change.rightItem == nil {
                switch change.submoduleInfo {
                case .notSubmodule:
                    if let diffChange = viewModel.getChangeFor(item: change, staged: staged, offset: 0) {
                        Spacer()
                        Button("Details") {
                            localChangesFilePath = diffChange
                        }
                    }
                    if change.leftItem.change.state != .staged && change.leftItem.changeKind.revertable {
                        if !change.leftItem.change.kind.canShowDetails {
                            Spacer()
                        }
                        Button("revert") {
                            viewModel.revert(change: change.leftItem.change)
                        }
                    }
                case .modified:
                    Button("Update Submodule") {
                        viewModel.updateSubmodule(change: change.leftItem.change)
                    }
                    if let diffChange = viewModel.getChangeFor(item: change, staged: staged, offset: 0) {
                        Spacer()
                        Button("Details") {
                            localChangesFilePath = diffChange
                        }
                    }
                case .missing: EmptyView()
                case .conflicted: EmptyView()
                }
                
            }
        }
            .padding(.vertical, 2)
            .contentShape(Rectangle())  
            .onTapGesture(count: 2) {
                viewModel.doubleClicked(change: change, staged: staged)
            }
            .onHover { isHovering in
                showButton = isHovering
            }
            .contextMenu {
                if (change.leftItem.changeKind.conflict) {
                    Button("mark as solved") {
                        viewModel.stage(change: change.leftItem.change)
                    }
                }
                if (change.leftItem.changeKind.deletable) {
                    Button("delete file") {
                        viewModel.delete(change: change.leftItem.change)
                    }
                }
            }
            
    }
    
    @ViewBuilder
    func itemView(for item: ChangeItem, isLeft: Bool, change: ChangeLine, staged: Bool) -> some View {
        HStack {
            Text(item.changeKind.infoString)
                .font(Font.system(size: 12).monospaced())
                .foregroundColor(item.changeKind.infoColor)
            VStack(alignment: .leading) {
                Text(
                    item.change.additionals.isEmpty ?
                    (item.change.path.lastPathComponent ?? "") :
                        (item.change.path.lastPathComponent ?? "") + " (\(item.change.additionals))"
                )
                    .lineLimit(1)
                    .fontWeight(.bold)
                
                // TODO: this is not a good idea.
                Text(item.change.path.trimmingPrefix("/\(item.change.path.lastPathComponent ?? "")"))
                    .lineLimit(1)
                    .font(.caption)
            }
            if item.change.kind.leftRight {
                Spacer()
                
                Button("select") {
                    Task {
                        await MainActor.run(body: {
                            self.viewModel.use(item: item, in: change, left: isLeft)
                        })
                    }
                    
                }
                if isLeft {
                    if item.change.kind.mergable {
                        Button("merge") {
                            Task {
                                await MainActor.run(body: {
                                    viewModel.startMerging(change: item.change)
                                })
                            }
                        }
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct LocalChangesView_Previews: PreviewProvider {
    static var previews: some View {
        LocalChangesView(
            viewModel: LocalChangesViewModel(
                status: StatusResult.getTestStatus()
            )
        )
        .onAppear {
            DoseBindings[\.repository] = SingletonProvider(PreviewRepo())
        }
    }
}

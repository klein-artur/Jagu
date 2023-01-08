//
//  CommitListView.swift
//  GitBuddy
//
//  Created by Artur Hellmann on 05.01.23.
//

import SwiftUI
import GitCaller

struct CommitListView: View {
    @ObservedObject var commitListViewModel: CommitListViewModel
    
    var body: some View {
        if let commitList = commitListViewModel.commitList {
            ScrollView {
                LazyVStack {
                    ForEach(commitList.indices, id: \.self) { index in
                        CommitItemView(commitInfo: commitList[index])
                            .padding(0)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .padding(.trailing, 16)
            }
        }
    }
}

struct CommitListView_Previews: PreviewProvider {
    static var previews: some View {
        CommitListView(
            commitListViewModel: CommitListViewModel(
                gitLog: LogResult(
                    originalOutput: "",
                    commits: [
                        Commit(
                            objectHash: "OneSomeHash",
                            shortHash: "OneSome",
                            subject: "Some Message",
                            message: "Some Message",
                            author: Person(name: "John Doe", email: "john@doe.com"),
                            authorDate: .now,
                            committer: Person(name: "John Doe", email: "john@doe.com"),
                            committerDate: .now,
                            branches: ["main", "origin/main"],
                            tags: ["onetag", "seocndTag"],
                            parents: ["FourSomeHashFour", "TwoSomeHashTwo"]
                        ),
                        Commit(
                            objectHash: "TwoSomeHashTwo",
                            shortHash: "OneSome",
                            subject: "Some Message",
                            message: "Some Message",
                            author: Person(name: "John Doe", email: "john@doe.com"),
                            authorDate: .now,
                            committer: Person(name: "John Doe", email: "john@doe.com"),
                            committerDate: .now,
                            branches: ["main", "origin/main"],
                            tags: ["onetag", "seocndTag"],
                            parents: ["ThreeSomeHashThree"]
                        ),
                        Commit(
                            objectHash: "ThreeSomeHashThree",
                            shortHash: "OneSome",
                            subject: "Some Message",
                            message: "Some Message",
                            author: Person(name: "John Doe", email: "john@doe.com"),
                            authorDate: .now,
                            committer: Person(name: "John Doe", email: "john@doe.com"),
                            committerDate: .now,
                            branches: ["main", "origin/main"],
                            tags: ["onetag", "seocndTag"],
                            parents: ["FourSomeHashFour"]
                        ),
                        Commit(
                            objectHash: "FourSomeHashFour",
                            shortHash: "OneSome",
                            subject: "Some Message",
                            message: "Some Message",
                            author: Person(name: "John Doe", email: "john@doe.com"),
                            authorDate: .now,
                            committer: Person(name: "John Doe", email: "john@doe.com"),
                            committerDate: .now,
                            branches: ["main", "origin/main"],
                            tags: ["onetag", "seocndTag"],
                            parents: ["FiveSomeHashFive"]
                        ),
                        Commit(
                            objectHash: "FiveSomeHashFive",
                            shortHash: "OneSome",
                            subject: "Some Message",
                            message: "Some Message",
                            author: Person(name: "John Doe", email: "john@doe.com"),
                            authorDate: .now,
                            committer: Person(name: "John Doe", email: "john@doe.com"),
                            committerDate: .now,
                            branches: ["main", "origin/main"],
                            tags: ["onetag", "seocndTag"],
                            parents: []
                        )
                    ]
                )
            )
        )
    }
}

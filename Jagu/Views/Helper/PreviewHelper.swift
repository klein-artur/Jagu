//
//  PreviewHelper.swift
//  Jagu
//
//  Created by Artur Hellmann on 15.01.23.
//

import Foundation
import GitCaller
import Combine

class PreviewRepo: Repository {
    var repositoryUpdated = PassthroughSubject<Void, Never>()

    var listOfSubmodules: SubmoduleResult {
        return try! SubmoduleParser().parse(result: "").get()
    }
    func stage(files paths: [String]) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func unstage(files paths: [String]) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func rebase(onto branch: String) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func abortRebase() async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func continueRebase() async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func getRebaseCommitMessage() async throws -> String {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func pushTags() async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func deleteTag(name: String) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func getConfig(scope: GitCaller.ConfigScope, key: GitCaller.ConfigKey) async throws -> String {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func setConfig(scope: GitCaller.ConfigScope, key: GitCaller.ConfigKey, value: String) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func unsetConfig(scope: GitCaller.ConfigScope, key: GitCaller.ConfigKey) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func continueMerge() async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func clone(url: String) async throws -> GitCaller.CloneResult {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    static let previewCommits = [
        Commit(
            objectHash: "OneSomeHash",
            shortHash: "OneSome",
            subject: "Some Message",
            message: "Some Message\nBut now with more text.",
            author: Person(name: "John Doe", email: "john@doe.com"),
            authorDateString: "Sun Feb 12 00:03:05 2023 +0100",
            committer: Person(name: "John Doe", email: "john@doe.com"),
            committerDateString: "Sun Feb 12 00:03:05 2023 +0100",
            branches: ["main", "origin/main"],
            tags: ["onetag", "seocndTag"],
            parents: ["FourSomeHashFour", "TwoSomeHashTwo"],
            diff: """
            diff --git a/test b/test
            index cf7acc3..017b47c 100644
            --- a/test
            +++ b/test
            @@ -1,4 +1,4 @@
            -asdfasdf
            +fdsaasdf
             asdf
             asdfasdf
             asdfasdfasdf
            """
        ),
        Commit(
            objectHash: "TwoSomeHashTwo",
            shortHash: "OneSome",
            subject: "Some Message",
            message: "Some Message",
            author: Person(name: "John Doe", email: "john@doe.com"),
            authorDateString: "Sun Feb 12 00:03:05 2023 +0100",
            committer: Person(name: "John Doe", email: "john@doe.com"),
            committerDateString: "Sun Feb 12 00:03:05 2023 +0100",
            branches: ["main", "origin/main"],
            tags: ["onetag", "seocndTag"],
            parents: ["ThreeSomeHashThree"],
            diff: ""
        ),
        Commit(
            objectHash: "ThreeSomeHashThree",
            shortHash: "OneSome",
            subject: "Some Message",
            message: "Some Message",
            author: Person(name: "John Doe", email: "john@doe.com"),
            authorDateString: "Sun Feb 12 00:03:05 2023 +0100",
            committer: Person(name: "John Doe", email: "john@doe.com"),
            committerDateString: "Sun Feb 12 00:03:05 2023 +0100",
            branches: ["main", "origin/main"],
            tags: ["onetag", "seocndTag"],
            parents: ["FourSomeHashFour"],
            diff: ""
        ),
        Commit(
            objectHash: "FourSomeHashFour",
            shortHash: "OneSome",
            subject: "Some Message",
            message: "Some Message",
            author: Person(name: "John Doe", email: "john@doe.com"),
            authorDateString: "Sun Feb 12 00:03:05 2023 +0100",
            committer: Person(name: "John Doe", email: "john@doe.com"),
            committerDateString: "Sun Feb 12 00:03:05 2023 +0100",
            branches: ["main", "origin/main"],
            tags: ["onetag", "seocndTag"],
            parents: ["FiveSomeHashFive"],
            diff: ""
        ),
        Commit(
            objectHash: "FiveSomeHashFive",
            shortHash: "OneSome",
            subject: "Some Message",
            message: "Some Message",
            author: Person(name: "John Doe", email: "john@doe.com"),
            authorDateString: "Sun Feb 12 00:03:05 2023 +0100",
            committer: Person(name: "John Doe", email: "john@doe.com"),
            committerDateString: "Sun Feb 12 00:03:05 2023 +0100",
            branches: ["main", "origin/main"],
            tags: ["onetag", "seocndTag"],
            parents: [],
            diff: ""
        )
    ]
    
    func show(commitHash: String) async throws -> LogResult {
        try LogResultParser().parse(result:
        """
        <<<----%mCommitm%---->>>da4830b<<<----%mDatam%---->>><<<----%mDatam%---->>>da4830b5ef3697795ec38d59044291a6b2135214<<<----%mDatam%---->>>8258f9663d1fbde63d97ac9a387f6a3dddf4b801<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Fri, 6 Jan 2023 12:15:27 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Fri, 6 Jan 2023 12:15:27 +0100<<<----%mDatam%---->>>improved Hash Handling<<<----%mDatam%---->>>improved Hash Handling<<<----%mDatam%---->>>
        
        diff --git a/test b/test
        index cf7acc3..017b47c 100644
        --- a/test
        +++ b/test
        @@ -1,4 +1,4 @@
        -asdfasdf
        +fdsaasdf
         asdf
         asdfasdf
         asdfasdfasdf
        """
        ).get()
    }
    
    func getLog(branchNames: [String]) async throws -> GitCaller.LogResult {
        try LogResultParser().parse(result:
        """
        <<<----%mCommitm%---->>>67faa10<<<----%mDatam%---->>> (HEAD -> main, origin/main, tag: test)<<<----%mDatam%---->>>67faa10a224db86ef4e796ab0a14b056ad4001a6<<<----%mDatam%---->>>da4830b5ef3697795ec38d59044291a6b2135214<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Fri, 6 Jan 2023 13:07:35 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Fri, 6 Jan 2023 13:07:35 +0100<<<----%mDatam%---->>>More hash handling improvements<<<----%mDatam%---->>>More hash handling improvements<<<----%mDatam%---->>>
        
        <<<----%mCommitm%---->>>da4830b<<<----%mDatam%---->>><<<----%mDatam%---->>>da4830b5ef3697795ec38d59044291a6b2135214<<<----%mDatam%---->>>8258f9663d1fbde63d97ac9a387f6a3dddf4b801<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Fri, 6 Jan 2023 12:15:27 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Fri, 6 Jan 2023 12:15:27 +0100<<<----%mDatam%---->>>improved Hash Handling<<<----%mDatam%---->>>improved Hash Handling<<<----%mDatam%---->>>
        
        diff --git a/test b/test
        index cf7acc3..017b47c 100644
        --- a/test
        +++ b/test
        @@ -1,4 +1,4 @@
        -asdfasdf
        +fdsaasdf
         asdf
         asdfasdf
         asdfasdfasdf
        <<<----%mCommitm%---->>>8258f96<<<----%mDatam%---->>><<<----%mDatam%---->>>8258f9663d1fbde63d97ac9a387f6a3dddf4b801<<<----%mDatam%---->>>b4dd6c93eec0df86b12055739db31491c59c8517 1050a3c5f6343e1bb6073df2a67566d47c11e6b2<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Thu, 5 Jan 2023 01:37:33 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Thu, 5 Jan 2023 01:37:33 +0100<<<----%mDatam%---->>>Merge branch 'main' of github.com:klein-artur/GitParser<<<----%mDatam%---->>>Merge branch 'main' of github.com:klein-artur/GitParser<<<----%mDatam%---->>>
        <<<----%mCommitm%---->>>b4dd6c9<<<----%mDatam%---->>><<<----%mDatam%---->>>b4dd6c93eec0df86b12055739db31491c59c8517<<<----%mDatam%---->>>258ae77965e33e9885dcc8072db5f53e3bd7f22f<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Thu, 5 Jan 2023 01:37:17 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Thu, 5 Jan 2023 01:37:17 +0100<<<----%mDatam%---->>>Adding parent commits to commit<<<----%mDatam%---->>>Adding parent commits to commit
        And more
        
        lines of
        
        message
        
        stuff<<<----%mDatam%---->>>
        <<<----%mCommitm%---->>>1050a3c<<<----%mDatam%---->>><<<----%mDatam%---->>>1050a3c5f6343e1bb6073df2a67566d47c11e6b2<<<----%mDatam%---->>>258ae77965e33e9885dcc8072db5f53e3bd7f22f<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Wed, 4 Jan 2023 22:15:24 +0100<<<----%mDatam%---->>>GitHub<<<----%mDatam%---->>>noreply@github.com<<<----%mDatam%---->>>Wed, 4 Jan 2023 22:15:24 +0100<<<----%mDatam%---->>>Update README.md<<<----%mDatam%---->>>Update README.md<<<----%mDatam%---->>><<<----%mCommitm%---->>>258ae77<<<----%mDatam%---->>><<<----%mDatam%---->>>258ae77965e33e9885dcc8072db5f53e3bd7f22f<<<----%mDatam%---->>>3c393184a116f4cbfa55aeb68ca39818e76dd870<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Wed, 4 Jan 2023 14:17:40 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Wed, 4 Jan 2023 14:17:40 +0100<<<----%mDatam%---->>>parsing commitlist<<<----%mDatam%---->>>parsing commitlist<<<----%mDatam%---->>>
        <<<----%mCommitm%---->>>3c39318<<<----%mDatam%---->>><<<----%mDatam%---->>>3c393184a116f4cbfa55aeb68ca39818e76dd870<<<----%mDatam%---->>>01edf9e57f55d457ca84072b1a0702ba97b58c98<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Tue, 3 Jan 2023 23:26:46 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Tue, 3 Jan 2023 23:26:46 +0100<<<----%mDatam%---->>>Parsing logs<<<----%mDatam%---->>>Parsing logs<<<----%mDatam%---->>>
        <<<----%mCommitm%---->>>01edf9e<<<----%mDatam%---->>><<<----%mDatam%---->>>01edf9e57f55d457ca84072b1a0702ba97b58c98<<<----%mDatam%---->>><<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Tue, 3 Jan 2023 00:18:13 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Tue, 3 Jan 2023 17:14:57 +0100<<<----%mDatam%---->>>Initial Commit<<<----%mDatam%---->>>Initial Commit<<<----%mDatam%---->>>
        """
        ).get()
    }
    
    func getLog(commitHash: String) async throws -> GitCaller.LogResult {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func getLog() async throws -> GitCaller.LogResult {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func getStatus() async throws -> GitCaller.StatusResult {
        let input = """
        On branch main
        Your branch is ahead of 'origin/main' by 1 commit.
          (use "git push" to publish your local commits)

        Changes to be committed:
          (use "git restore --staged <file>..." to unstage)
            modified:   shared/ContentView.swift
            deleted:    shared/DeviceDetail/EditDevicePrioView.swift
            new file:   shared/DeviceDetail/Test2.swift
            renamed:    test/testfile -> test/testfileNew

        Changes not staged for commit:
          (use "git add/rm <file>..." to update what will be committed)
          (use "git restore <file>..." to discard changes in working directory)
            modified:   Home.xcodeproj/project.pbxproj
            modified:   shared/DataRepository.swift
            deleted:    shared/DeviceDetail/DeviceDetailView.swift

        Untracked files:
          (use "git add <file>..." to include in what will be committed)
            shared/DeviceDetail/Test.swift
            shared/DeviceDetail/Test2.swift
        """
        return try! StatusParser().parse(result: input).get()
    }
    
    func getBranches() async throws -> GitCaller.BranchResult {
        return try BranchResultParser().parse(result: """
        * (HEAD detached at fadce24)
          Savebranch                             8667982e1 fixed issue
          main                                   8667982e1 [ahead 2] fixed issue
          other                                  8667982e1 [behind 2] fixed issue
          test/nested                            8667982e1 [ahead 3, behind 2] fixed issue
          remotes/origin/HEAD -> origin/main
          remotes/origin/main
        """).get()
    }
    
    func checkout(branch: GitCaller.Branch) async throws -> GitCaller.CheckoutResult {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func delete(branch: GitCaller.Branch, force: Bool) async throws -> GitCaller.BranchResult {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func stage(file path: String?) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func unstage(file path: String) async throws -> RestoreResult {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func revert(unstagedFile path: String) async throws -> RestoreResult {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func revert(unstagedFiles paths: [String]) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func revertDeleted(unstagedFile path: String) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func commit(message: String) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func fetch() async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func pull(force: Bool) async throws -> PullResult {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    public func push(force: Bool, createUpstream: Bool = false, remoteName: String? = nil, newName: String? = nil) async throws -> PushResult {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func newBranchAndCheckout(name: String) async throws -> CheckoutResult {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func diff(path: String?, staged: Bool = false, rightPath: String? = nil) async throws -> DiffResult {
        try DiffResultParser().parse(result: Self.simpleOneFileDiff).get()
    }
    
    func needsUpdate() {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func merge(branch: String) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func abortMerge() async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func mergetool(file: String, tool: String) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func useOurs(path: String) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func useTheirs(path: String) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
    
    func getMergeCommitMessage() async throws -> String {
        return "asdf"
    }
    
    static let simpleTwoFileDiff: String = """
    diff --git a/some/file/diffFile b/some/file/diffFile2
    index 2959c86..1f2aa9f 100644
    --- a/some/file/diffFile
    +++ b/some/file/diffFile2
    @@ -1,5 +1,5 @@
     asdf
     
    -asdf
    +asdfasdf
     
     asdf
    diff --git a/some/file/diffFile2 b/some/file/diffFile2
    index 2959c86..91b7927 100644
    --- a/some/file/diffFile2
    +++ b/some/file/diffFile2
    @@ -3 +3 @@ asdf
     
     asdf
     
    -
    +asdf this is some very very long line that should be scrollable to the right if possible. So no elliptizes, no shortinging. Just scrolling to the right should be possible whenever the user wants to scroll.
     
     @@ -1,5 +1,5 @@
     asdf
    @@ -33,7 +33,7 @@ asdf
     
     
     
    -asdf
    +asdffdsa
     
     
     
    """
    
    static let simpleOneFileDiff: String = """
    diff --git a/some/file/diffFile2 b/some/file/diffFile2
    index 2959c86..91b7927 100644
    --- a/some/file/diffFile2
    +++ b/some/file/diffFile2
    @@ -3 +3 @@ asdf
     
     asdf
     
    -
    +asdf this is some very very long line that should be scrollable to the right if possible. So no elliptizes, no shortinging. Just scrolling to the right should be possible whenever the user wants to scroll.
     
     @@ -1,5 +1,5 @@
     asdf
    @@ -33,7 +33,7 @@ asdf
     
     
     
    -asdf
    +asdffdsa
     
     
     
    """
    
    func update(submodule path: String) async throws {
        fatalError("Preview and Test Repo implementation used in productive code!")
    }
}


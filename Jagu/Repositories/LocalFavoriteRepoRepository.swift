//
//  LocalFavoriteRepoRepository.swift
//  Jagu
//
//  Created by Artur Hellmann on 08.02.23.
//

import Foundation
import SwiftDose

class LocalFavoriteRepoRepository: FavoriteRepoRepository, UserDefaultsRepo {
    
    static let defaultsKey: String = "LOCAL_FAVORITE_REPOSITORIES_KEY"
    
    @Dose(of: \.userDefaults) var userDefaults
    
    func setAsFavorite(path: String) {
        var currentList = Set(getFavorites())
        currentList.insert(path)
        userDefaults.set(Array(currentList), forKey: Self.defaultsKey)
        userDefaults.synchronize()
    }
    
    func getFavorites() -> [String] {
        return userDefaults.stringArray(forKey: Self.defaultsKey) ?? []
    }
    
    func deleteFavorite(path: String) {
        let currentList = getFavorites().filter { $0 != path }
        userDefaults.set(Array(currentList), forKey: Self.defaultsKey)
        userDefaults.synchronize()
    }
}

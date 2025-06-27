//
//  FavoriteRepoService.swift
//  Jagu
//
//  Created by Artur Hellmann on 08.02.23.
//

import Foundation
import SwiftDose

class FavoriteRepoService {
    @Dose(of: \.favoriteRepoRepository) var repoRepository: FavoriteRepoRepository
    
    var favorites: [RepoFavorite] {
        repoRepository.getFavorites()
            .map { path in
                RepoFavorite(path: path)
            }
    }
    
    func saveFavorite(path: String) {
        repoRepository.setAsFavorite(path: path)
    }
    
    func deleteFavorite(path: String) {
        repoRepository.deleteFavorite(path: path)
    }
}

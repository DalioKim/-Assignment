//
//  FavoriteItemCellModel.swift
//  MovieSearchApp
//
//  Created by κΉλν on 2022/04/27.
//

class FavoriteItemCellModel {
    private let model: FavoriteMovie
    private weak var parentViewModel: FavoriteViewModel?
    
    init(parentViewModel: FavoriteViewModel?, model: FavoriteMovie) {
        self.parentViewModel = parentViewModel
        self.model = model
    }
}

extension FavoriteItemCellModel {
    var title: String {
        model.title ?? ""
    }
    
    var thumbnailImagePath: String? {
        model.thumbnailImagePath
    }
    
    var director: String? {
        model.director
    }

    var actorList: String? {
        model.actorList
    }
    
    var userRating: String? {
        model.userRating
    }
}

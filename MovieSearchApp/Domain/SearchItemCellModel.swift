//
//  SearchItemCellModel.swift
//  MovieSearchApp
//
//  Created by 김동현 on 2022/04/25.
//

class SearchItemCellModel {
    typealias Content = SearchResponse.Movie
    private let model: Content
    private weak var parentViewModel: DefaultSearchViewModel?
    
    init(parentViewModel: DefaultSearchViewModel?, model: Content) {
        self.parentViewModel = parentViewModel
        self.model = model
    }
}

extension SearchItemCellModel {
    var title: String {
        model.title ?? ""
    }
    
    var thumbnailImagePath: String? {
        model.image
    }
    
    var director: String? {
        model.director
    }
    
    var actor: String? {
        model.actor
    }
    
    var userRating: Int? {
        model.userRating
    }
    
    var link: String? {
        model.link
    }
}

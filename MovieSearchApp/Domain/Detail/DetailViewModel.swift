//
//  DetailViewModel.swift
//  MovieSearchApp
//
//  Created by 김동현 on 2022/04/26.
//

class DetailViewModel {
    private let model: SearchItemCellModel
    
    init(model: SearchItemCellModel) {
        self.model = model
    }
}

extension DetailViewModel {
    var title: String {
        model.title
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
    
    var link: String? {
        model.link
    }
}

//
//  FavoriteViewModel.swift
//  MovieSearchApp
//
//  Created by 김동현 on 2022/04/26.
//

import RxSwift
import RxRelay

class FavoriteViewModel {
    private let realmManager = RealmManager()
    private let cellModelsRelay = BehaviorRelay<[FavoriteItemCellModel]?>(value: nil)
    
    var cellModelsObs: Observable<[FavoriteItemCellModel]> {
        cellModelsRelay.map { $0 ?? [] }
    }
    
    var cellModels: [FavoriteItemCellModel] {
        cellModelsRelay.value ?? []
    }
    
    // MARK: - Init
    
    init() {
        bind()
    }
}

extension FavoriteViewModel {
    private func bind() {
        let list = realmManager.getFavoriteList().map {
            FavoriteItemCellModel(parentViewModel: self, model: $0)
        }
        self.cellModelsRelay.accept(list)
    }
}

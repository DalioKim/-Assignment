//
//  FavoriteViewModel.swift
//  MovieSearchApp
//
//  Created by 김동현 on 2022/04/26.
//

import RxSwift
import RxRelay
import RxRealm
import RealmSwift

class FavoriteViewModel {
    private let realmManager = RealmManager()
    private let cellModelsRelay = BehaviorRelay<[String]?>(value: nil)
    
    var cellModelsObs: Observable<[String]> {
        cellModelsRelay.map { $0 ?? [] }
    }
    
    var cellModels: [String] {
        cellModelsRelay.value ?? []
    }
    
    // MARK: - Init
    
    init() {
        bindFetch()
    }
}

extension FavoriteViewModel {
    private func bindFetch() {
        guard let realm = try? Realm() else { return }
        print("count \(realm.objects(FavoriteMovie.self).toArray().count)")
        let list = realm.objects(FavoriteMovie.self).toArray().map { $0.title }
        self.cellModelsRelay.accept(list)
    }
}

//
//  RealmManager.swift
//  MovieSearchApp
//
//  Created by 김동현 on 2022/04/26.
//

import RealmSwift
import RxSwift
import RxRealm

class FavoriteMovie: Object {
    @Persisted var title: String = ""
    @Persisted var thumbnailImagePath: String = ""
    @Persisted var director: String = ""
    @Persisted var actorList: String = ""
    @Persisted var userRating: String = ""

    convenience init(model: SearchItemCellModel) {
        self.init()
        
        title = model.title.removeTag
        thumbnailImagePath = model.thumbnailImagePath ?? ""
        director = model.director ?? ""
        actorList = model.actorList ?? ""
        userRating = model.userRating ?? ""
    }
}

struct RealmManager {
    let disposeBag = DisposeBag()
    
    func isFavorite(title: String) -> Observable<Results<FavoriteMovie>>{
        return favorites(title: title)
    }
    
    func favorite(model: SearchItemCellModel) {
        let favorite = FavoriteMovie(model: model)
        Observable.just(favorite)
            .observe(on: MainScheduler.instance)
            .subscribe(Realm.rx.add())
            .disposed(by: disposeBag)
    }
    
    func favorites(title: String) -> Observable<Results<FavoriteMovie>> {
        guard let realm = try? Realm() else {
            return Observable.empty()
        }
        //filter 2개 
        let result = realm.objects(FavoriteMovie.self).filter(NSPredicate(format: "title == %@", title))
        return Observable.collection(from: result)
    }
    
    func unfavorite(title: String) {
        favorites(title: title)
            .subscribe(Realm.rx.delete())
            .dispose()
    }
    
    func getFavoriteList() -> [FavoriteMovie] {
        guard let realm = try? Realm() else {
            return []
        }
        return realm.objects(FavoriteMovie.self).toArray()
    }
}

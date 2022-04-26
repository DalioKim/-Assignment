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
    @objc dynamic var title = ""
    
    convenience init(model: SearchItemCellModel) {
        self.init()

        self.title = model.title.removeTag
    }
}

struct RealmManager {
    let disposeBag = DisposeBag()
    
    func isFavorite(title: String) -> Observable<Results<FavoriteMovie>>{
        return favorites(title: title)
    }
    
    func favorite(model: SearchItemCellModel) {
        print(#function)
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

        let result = realm.objects(FavoriteMovie.self).filter(NSPredicate(format: "title == %@", title))
        return Observable.collection(from: result)
    }
    
    func unfavorite(title: String) {
        favorites(title: title)
            .subscribe(Realm.rx.delete())
            .dispose()
    }
}

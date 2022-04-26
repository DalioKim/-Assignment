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
//    @objc dynamic var thumbnailImagePath = ""
//    @objc dynamic var director = ""
    
    convenience init(model: SearchItemCellModel) {
        self.init()
        
        self.title = model.title.removeTag
//        self.thumbnailImagePath = model.thumbnailImagePath ?? ""
//        self.director = model.director ?? ""
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
        //filter 2개 
        let result = realm.objects(FavoriteMovie.self).filter(NSPredicate(format: "title == %@", title))
        return Observable.collection(from: result)
    }
    
    func unfavorite(title: String) {
        guard let realm = try? Realm() else {
            return
        }
        
        print("삭제 전 count \(realm.objects(FavoriteMovie.self).count)")
        
        favorites(title: title)
            .subscribe(Realm.rx.delete())
            .dispose()
        print("삭제 후 count \(realm.objects(FavoriteMovie.self).count)")
        
    }
}

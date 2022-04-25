//
//  SearchViewModel.swift
//  MovieSearchApp
//
//  Created by 김동현 on 2022/04/25.
//

import RxSwift
import RxRelay

protocol SearchViewModelInput {
    func loadMore()
    func refresh()
    func search(_ query: String?)
    func didSelectItem(_ model: SearchItemCellModel)
}

protocol SearchViewModelOutput {
    associatedtype ViewAction
    var cellModels: [SearchItemCellModel] { get }
    var cellModelsObs: Observable<[SearchItemCellModel]> { get }
    var viewActionObs: Observable<ViewAction> { get }
}

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput {}

final class DefaultSearchViewModel: SearchViewModel {
    typealias ViewAction = DefaultSearchViewAction
    
    enum DefaultSearchViewAction {
        case popViewController
        case showDetail(itemNo: Int)
        case showFeature(itemNo: Int)
    }
    
    private var query = ""
    
    // MARK: - Relay & Observer
    
    private let disposeBag = DisposeBag()
    
    private let cellModelsRelay = BehaviorRelay<[SearchItemCellModel]?>(value: nil)
    private let viewActionRelay = PublishRelay<ViewAction>()
    
    var cellModelsObs: Observable<[SearchItemCellModel]> {
        cellModelsRelay.map { $0 ?? [] }
    }
    
    var cellModels: [SearchItemCellModel] {
        cellModelsRelay.value ?? []
    }
    
    var viewActionObs: Observable<ViewAction> {
        viewActionRelay.asObservable()
    }
    
    
    // MARK: - paging
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var nextPage: Int { (cellModels.count > 10) ? currentPage + 1 : currentPage }
    
    // MARK: - Init
    
    init() {
        bindFetch()
    }
    
    // MARK: - Private
    
    private func bindFetch() {}
}
// MARK: - INPUT. View event methods

extension DefaultSearchViewModel {
    func loadMore() {}
    
    func refresh() {}
    
    func search(_ query: String?) {
        guard let query = query, query.count > 1 else { return }
        self.query = query
        refresh()
    }
    
    func didSelectItem(_ model: SearchItemCellModel) {}
}

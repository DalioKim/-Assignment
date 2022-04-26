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
        case showDetail(viewModel: DetailViewModel)
        case showFeature(itemNo: Int)
    }
    
    private var query = ""
    
    // MARK: - Relay & Observer
    
    private let disposeBag = DisposeBag()
    
    private let cellModelsRelay = BehaviorRelay<[SearchItemCellModel]?>(value: nil)
    private let viewActionRelay = PublishRelay<ViewAction>()
    private let fetchStatusTypeRelay = BehaviorRelay<FetchStatusType>(value: .none(.initial))
    private let fetch = PublishRelay<FetchType>()
    
    var cellModelsObs: Observable<[SearchItemCellModel]> {
        cellModelsRelay.map { $0 ?? [] }
    }
    
    var cellModels: [SearchItemCellModel] {
        cellModelsRelay.value ?? []
    }
    
    var viewActionObs: Observable<ViewAction> {
        viewActionRelay.asObservable()
    }
    
    var fetchStatusTypeObs: Observable<FetchStatusType> {
        fetchStatusTypeRelay.asObservable()
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
    
    private func bindFetch() {
        fetch
            .do(onNext: { [weak self] fetchType in
                self?.fetchStatusTypeRelay.accept(.fetching(fetchType))
            })
            .flatMapLatest { [weak self] _ -> Observable<Result<[SearchItemCellModel], Error>> in
                guard let self = self else { return .empty() }
                return API.search(self.query)
                    .asObservable()
                    .map { [weak self] in
                        $0.items.compactMap { SearchItemCellModel(parentViewModel: self, model: $0) }
                    }
                    .map { .success($0) }
                    .catch { .just((.failure($0))) }
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                let fetchType = self.fetchStatusTypeRelay.value.type
                switch result {
                case .success(let models):
                    let list = fetchType == .more ? (self.cellModelsRelay.value ?? []) + models : models
                    self.cellModelsRelay.accept(list)
                    self.fetchStatusTypeRelay.accept(.success(fetchType))
                case .failure(let error):
                    self.fetchStatusTypeRelay.accept(.failure(fetchType, error: error))
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - INPUT. View event methods

extension DefaultSearchViewModel {
    func loadMore() {}
    
    func refresh() {
        fetch.accept(.refresh)
    }
    
    func search(_ query: String?) {
        guard let query = query, query.count > 1 else { return }
        self.query = query
        refresh()
    }
    
    func didSelectItem(_ model: SearchItemCellModel) {
        viewActionRelay.accept(ViewAction.showDetail(viewModel: DetailViewModel(model: model)))
    }
}

//
//  MainSearchViewController.swift
//  Assignment
//
//  Created by 김동현 on 2022/04/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainSearchViewController: UIViewController {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchBar, collectionView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        return stackView
    }()
    
    private let searchBar = UISearchBar()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private var viewModel: DefaultSearchViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(viewModel: DefaultSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindTitle()
        bindCollectionView()
        bindSearchBar()
        bindViewAction()
    }
    
    // MARK: - private
    
    private func setupViews() {
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindTitle() {
        rx.methodInvoked(#selector(viewWillAppear(_:)))
            .subscribe(onNext: { [weak self] _ in
                self?.title = "네이버 영화 검색"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        searchBar.rx.searchButtonClicked
            .asObservable()
            .withLatestFrom(searchBar.rx.text)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.search($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewAction() {
        viewModel.viewActionObs
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .showDetail(_):
                    break
                case .popViewController:
                    self.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 20
        return CGSize(width: width, height: 200)
    }
}

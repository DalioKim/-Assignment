//
//  FavoriteViewController.swift
//  MovieSearchApp
//
//  Created by 김동현 on 2022/04/26.
//

import UIKit
import RxSwift

class FavoriteViewController: UIViewController {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [collectionView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        return stackView
    }()
        
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavoriteItemCell.self, forCellWithReuseIdentifier: FavoriteItemCell.className)
        return collectionView
    }()

    private var viewModel = FavoriteViewModel()
    private let disposeBag = DisposeBag()

    init() {
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
    }
    
    private func setupViews() {
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindTitle() {
        rx.methodInvoked(#selector(viewWillAppear(_:)))
            .subscribe(onNext: { [weak self] _ in
                self?.title = "즐겨찾기 목록"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.cellModelsObs
            .bind(to: collectionView.rx.items) { collectionView, index, cellModel in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteItemCell.className, for: indexPath)
                (cell as? Bindable).map { $0.bind(cellModel) }
                return cell
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 20
        return CGSize(width: width, height: 120)
    }
}

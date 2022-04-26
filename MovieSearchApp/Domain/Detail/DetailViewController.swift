//
//  DetailViewController.swift
//  MovieSearchApp
//
//  Created by 김동현 on 2022/04/26.
//

import UIKit
import RxSwift
import WebKit

class DetailViewController: UIViewController {
    
    // MARK: - nested type
    
    enum Size {
        static let horizontalPadding: CGFloat = 20
        static let verticalPadding: CGFloat = 10
        static let spacing: CGFloat = 5
        enum Thumbnail {
            static let width: CGFloat = 60
            static let height: CGFloat = 80
        }
    }
    
    enum Style {
        enum Title {
            static let lineBreakMode: NSLineBreakMode = .byTruncatingTail
        }
    }
    
    // MARK: - private
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, titleStackView])
        stackView.axis = .horizontal
        stackView.spacing = Size.spacing
        stackView.alignment = .center
        
        thumbnailImageView.snp.makeConstraints {
            $0.width.equalTo(Size.Thumbnail.width)
            $0.height.equalTo(Size.Thumbnail.height)
        }
        titleStackView.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        return stackView
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [directorLabel,actorLabel,userRatingLabel])
        stackView.axis = .vertical
        stackView.spacing = Size.spacing
        return stackView
    }()
    
    private let directorLabel: UILabel = {
        let directorLabel = UILabel()
        directorLabel.textAlignment = .left
        return directorLabel
    }()
    
    private let actorLabel: UILabel = {
        let actorLabel = UILabel()
        actorLabel.textAlignment = .left
        actorLabel.lineBreakMode = Style.Title.lineBreakMode
        return actorLabel
    }()
    
    private let userRatingLabel: UILabel = {
        let userRatingLabel = UILabel()
        userRatingLabel.textAlignment = .left
        return userRatingLabel
    }()
    
    private let wkWebView = WKWebView()
    
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    private func setupViews() {
        view.addSubview(stackView)
        view.addSubview(wkWebView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(120)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        wkWebView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        bindTitle()
        setupContent()
        loadWebView()
    }
    
    private func bindTitle() {
        rx.methodInvoked(#selector(viewWillAppear(_:)))
            .subscribe(onNext: { [weak self] _ in
                self?.title = self?.viewModel.title.removeTag
            })
            .disposed(by: disposeBag)
    }
    
    private func setupContent() {
        directorLabel.text = "감독: " + (viewModel.director ?? "").dropLast().replacingOccurrences(of: "|", with: ", ")
        actorLabel.text = "출연: " + (viewModel.actorList ?? "").dropLast().replacingOccurrences(of: "|", with: ", ")
        userRatingLabel.text = "평점: " + (viewModel.userRating  ?? "")
        thumbnailImageView.setImage(viewModel.thumbnailImagePath)
    }
    
    private func loadWebView() {
        guard let link = viewModel.link, let linkURL = URL(string: link) else { return }
        wkWebView.load(URLRequest(url: linkURL))
    }
}

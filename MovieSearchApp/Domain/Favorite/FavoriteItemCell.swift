//
//  FavoriteItemCell.swift
//  MovieSearchApp
//
//  Created by 김동현 on 2022/04/26.
//

import UIKit
import RxSwift
import RxRelay

class FavoriteItemCell: UICollectionViewCell {
    
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
    
//    private lazy var stackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [titleStackView])
//        stackView.axis = .horizontal
//        stackView.spacing = Size.spacing
//        stackView.alignment = .center
//
//        //        thumbnailImageView.snp.makeConstraints {
//        //            $0.width.equalTo(Size.Thumbnail.width)
//        //            $0.height.equalTo(Size.Thumbnail.height)
//        //        }
//        titleStackView.snp.makeConstraints {
//            $0.width.equalTo(100)
//        }
//        //        favoriteView.snp.makeConstraints {
//        //            $0.width.equalTo(20)
//        //            $0.height.equalTo(20)
//        //        }
//
//        return stackView
//    }()
//
//    private lazy var titleStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [titleLabel])
//        stackView.axis = .vertical
//        stackView.spacing = Size.spacing
//        return stackView
//    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = Style.Title.lineBreakMode
        return titleLabel
    }()
    
//    private let directorLabel: UILabel = {
//        let directorLabel = UILabel()
//        directorLabel.textAlignment = .left
//        return directorLabel
//    }()
//
//    private let actorLabel: UILabel = {
//        let actorLabel = UILabel()
//        actorLabel.textAlignment = .left
//        actorLabel.lineBreakMode = Style.Title.lineBreakMode
//        return actorLabel
//    }()
//
//    private let userRatingLabel: UILabel = {
//        let userRatingLabel = UILabel()
//        userRatingLabel.textAlignment = .left
//        return userRatingLabel
//    }()
//
    private var model: String?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        titleLabel.text = nil
//        directorLabel.text = nil
//        actorLabel.text = nil
//        userRatingLabel.text = nil
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.horizontalPadding)
            $0.top.bottom.equalToSuperview().inset(Size.verticalPadding)
        }
    }
    
}

extension FavoriteItemCell: Bindable {
    func bind(_ model: Any?) {
        guard let model = model as? String else { return }
        
        self.model = model
        
        print("FavoriteItemCell title \(model)")
        titleLabel.text = model
    }
}

//
//  SearchItemCell.swift
//  MovieSearchApp
//
//  Created by 김동현 on 2022/04/26.
//

import UIKit
import Kingfisher

class SearchItemCell: UICollectionViewCell {
    
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
        let stackView = UIStackView(arrangedSubviews: [titleLabel,directorLabel,actorLabel,userRatingLabel])
        stackView.axis = .vertical
        stackView.spacing = Size.spacing
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = Style.Title.lineBreakMode
        return titleLabel
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
        thumbnailImageView.image = nil
        titleLabel.text = nil
        directorLabel.text = nil
        actorLabel.text = nil
        userRatingLabel.text = nil
    }
    
    func setupViews() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Size.horizontalPadding)
            $0.top.bottom.equalToSuperview().inset(Size.verticalPadding)
        }
    }
}

extension SearchItemCell: Bindable {
    func bind(_ model: Any?) {
        guard let model = model as? SearchItemCellModel else { return }
        
        titleLabel.text = model.title.removeTag
        directorLabel.text = "감독: " + (model.director ?? "").dropLast().replacingOccurrences(of: "|", with: ", ")
        actorLabel.text = "출연: " + (model.actorList ?? "").dropLast().replacingOccurrences(of: "|", with: ", ")
        userRatingLabel.text = "평점: " + (model.userRating  ?? "")
        guard let path = model.thumbnailImagePath, let url = URL(string: path) else { return }
        
        thumbnailImageView.kf.setImage(with: url)
    }
}

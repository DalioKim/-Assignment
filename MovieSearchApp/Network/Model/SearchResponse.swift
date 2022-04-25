//
//  SearchResponse.swift
//  MovieSearchApp
//
//  Created by 김동현 on 2022/04/25.
//

import Foundation

struct SearchResponse: Decodable {
    let statusCode: Int
    let items: [Movie]
    
    enum Keys: String, CodingKey {
        case statusCode
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode) ?? 404
        items = try container.decodeIfPresent([Movie].self, forKey: .items) ?? []
    }
    
    struct Movie: Decodable {
        let title: String?
        let image: String?
        let director: String?
        let actor: String?
        let userRating: Int?
        let link: String?
        
        enum Keys: String, CodingKey {
            case title
            case image
            case director
            case actor
            case userRating
            case link
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
            image = try? container.decodeIfPresent(String.self, forKey: .image)
            director = try container.decodeIfPresent(String.self, forKey: .director) ?? ""
            actor = try container.decodeIfPresent(String.self, forKey: .actor) ?? ""
            userRating = try container.decodeIfPresent(Int.self, forKey: .userRating) ?? 0
            link = try container.decodeIfPresent(String.self, forKey: .link) ?? ""
        }
    }
}

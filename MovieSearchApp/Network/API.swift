//
//  API.swift
//  MovieSearchApp
//
//  Created by κΉλν on 2022/04/25.
//

import RxSwift
import Moya

class API {
    static private let provider = MoyaProvider<APITarget>()
        
    static func search(_ query: String) -> Single<SearchResponse> {
        return API.provider.rx.request(.search(query: query))
            .filterSuccessfulStatusCodes()
            .map(SearchResponse.self)
    }
}

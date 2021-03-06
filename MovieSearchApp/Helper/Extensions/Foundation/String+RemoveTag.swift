//
//  String+RemoveTag.swift
//  MovieSearchApp
//
//  Created by κΉλν on 2022/04/26.
//

import Foundation

extension String {
    var removeTag: String {
        let tagRegex = "(<|</)[a-z0-9]*>+"
        return self.replacingOccurrences(of: tagRegex, with: "", options: .regularExpression)
    }
}

//
//  NSObject+ClassName.swift
//  MovieSearchApp
//
//  Created by κΉλν on 2022/04/26.
//

import Foundation

@objc
extension NSObject {
    class var className: String {
        String(describing: self)
    }
}

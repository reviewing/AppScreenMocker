//
//  NSURL+Params.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 9/20/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import Foundation

extension URL {
    var queryItems: [String: String]? {
        var params = [String: String]()
        return URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce([:], { (_, item) -> [String: String] in
                params[item.name] = item.value
                return params
            })
    }
}

//
//  NSURL+Params.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 9/20/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import Foundation

extension NSURL {
    var queryItems: [String: String]? {
        var params = [String: String]()
        return NSURLComponents(URL: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce([:], combine: { (_, item) -> [String: String] in
                params[item.name] = item.value
                return params
            })
    }
}
//
//  DateFormatterExtensions.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import ObjectMapper

extension DateFormatterTransform {
    convenience init(with format: String, locale: String = "en_US_POSIX") {
        let dateFormatter = DateFormatter(withFormat: format, locale: locale)
        self.init(dateFormatter: dateFormatter)
    }
}

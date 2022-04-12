//
//  Tv.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 12.04.2022.
//

import Foundation

struct TrendyTvResponse: Codable {
    let results: [Tv]
}

struct Tv: Codable {
    let id: Int
    let media_type: String?
    let original_tutle: String?
    let title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

//
//  YoutubeSearchResponce.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 14.04.2022.
//

import Foundation



struct YoutubeSearchResponce: Codable {
    let items: [Video]
}

struct Video: Codable {
    let id: IdVideo
}

struct IdVideo: Codable {
    let kind: String
    let videoId: String
}

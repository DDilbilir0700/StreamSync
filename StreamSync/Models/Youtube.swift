//
//  Youtube.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 21/02/2024.
//

import Foundation

struct Youtube: Codable {
    let items: [YoutubeVideos]
}

struct YoutubeVideos: Codable {
    let id: IdYoutubeVideos
}

struct IdYoutubeVideos: Codable {
    let kind: String
    let videoId: String
}


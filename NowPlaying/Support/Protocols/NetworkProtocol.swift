//
//  NetworkProtocol.swift
//  NowPlaying
//
//  Created by Marek Hac on 09/09/2024.
//

import Foundation

protocol NetworkProtocol {
    func buildURLRequest(_ path: String, _ parameters: [String: Any]) -> URLRequest
    func get(request: URLRequest) async throws -> Data?
    static func getPosterFullURL(for posterPath: String) -> URL?
}

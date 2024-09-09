//
//  URLSessionProtocol.swift
//  NowPlaying
//
//  Created by Marek Hac on 09/09/2024.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

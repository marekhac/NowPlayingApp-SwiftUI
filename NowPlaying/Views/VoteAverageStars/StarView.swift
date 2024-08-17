//
//  StarView.swift
//  NowPlaying
//
//  Created by Marek Hac on 15/08/2024.
//

import SwiftUI

struct StarView: View {
    var filled: Bool
    var halfFilled: Bool = false

    var body: some View {
        Image(systemName: starImageName)
            .foregroundColor(.yellow)
    }

    private var starImageName: String {
        if filled {
            return "star.fill"
        } else if halfFilled {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}

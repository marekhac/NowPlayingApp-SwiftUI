//
//  VoteStarsView.swift
//  NowPlaying
//
//  Created by Marek Hac on 15/08/2024.
//

import SwiftUI

struct VoteAverageStarsView: View {
    var rating: Double
    var maxRating: Int = 10

    var body: some View {
        HStack {
            ForEach(0..<maxRating, id: \.self) { index in
                if Double(index) < rating {
                    if rating - Double(index) >= 1 {
                        StarView(filled: true)
                    } else {
                        StarView(filled: false, halfFilled: true)
                    }
                }
            }
        }
    }
}

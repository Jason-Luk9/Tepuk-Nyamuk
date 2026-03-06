//
//  TutorialTextStyle.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 20/2/26.
//
import SwiftUI

struct TutorialTextStyle: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: "play.fill")
                .foregroundColor(.primaryButton)
                .font(.system(size: 16))
                .offset(y: 6)

            Text(text)
                .font(.custom("VT323-Regular", size: 26))
                .fontWeight(.medium)
                .foregroundColor(.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

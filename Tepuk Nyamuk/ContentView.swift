//
//  ContentView.swift
//  Tepuk Nyamuk
//
//  Created by Jason LUK on 15/2/26.
//
import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstTimeUser") private var isFirstTimeUser = true
    var body: some View {
        if isFirstTimeUser {
            TutorialView()
        } else {
            HomeView()
        }
    }
}

//
//  Main.swift
//  testGitHubApi
//
//  Created by ALIEV Dmitry on 06.08.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        Text("Главная страница")
            .navigationBarTitle("Главная")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView()
        }
    }
}

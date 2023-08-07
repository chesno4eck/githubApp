//
//  ContentView.swift
//  testGitHubApi
//
//  Created by ALIEV Dmitry on 05.08.2023.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Главная")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Настройки")
                }
            
            ProfileView(
                store: Store(initialState: Profile.State()) {
                    Profile()
                }
            )
                .tabItem {
                    Image(systemName: "person")
                    Text("Профиль")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

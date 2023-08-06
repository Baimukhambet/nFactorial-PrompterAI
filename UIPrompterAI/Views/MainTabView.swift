//
//  MainTabView.swift
//  UIPrompterAI
//
//  Created by Timur Baimukhambet on 06.07.2023.
//

import SwiftUI
import UIKit

struct MainTabView: View {
    //initialize ViewModel object in parent view
    @StateObject var viewModel = ViewModel()
    @Environment(\.scenePhase) var scenePhase
    @State var selectedTab = 1
    @State var language: String = "en"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HistoryView()
                .preferredColorScheme(.light)
                .tabItem {
                    Image(systemName: "archivebox.fill")
                }
                .tag(0)
            ContentView()
                .preferredColorScheme(.light)
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(1)
            
            SettingsView()
                .preferredColorScheme(.light)
                .tabItem {
                    Image(systemName: "gear")
                }
                .tag(2)
        }
        .tint(.black)
        .environmentObject(viewModel)
        .onAppear {
            viewModel.setup()
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .background || newValue == .inactive {
                viewModel.saveHistory()
            }
        }
        
    }
    
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

//
//  SettingsView.swift
//  UIPrompterAI
//
//  Created by Timur Baimukhambet on 30.07.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: ViewModel
    var temperatureLevels = ["Low": 0.5, "Medium": 1.0, "High": 1.5]
    
    
    
    var body: some View {
        List {
            HStack {
                Text((Texts.getLanguage(viewModel.language))["temperature"] ?? "Creativity")
                    .tag("")
                Picker("", selection: $viewModel.temperature) {
                    Text("Low")
                        .tag("low")
                    Text("Medium")
                        .tag("medium")
                    Text("High")
                        .tag("high")
                }
            }
            HStack {
                Text((Texts.getLanguage(viewModel.language))["language"] ?? "Language")
                Picker("", selection: $viewModel.language) {
                    Text("English")
                        .tag("en")
                    Text("Русский")
                        .tag("ru")
                }
            }
            HStack {
                Text((Texts.getLanguage(viewModel.language))["autocopy"] ?? "Auto-copy prompt")
                Toggle(isOn: $viewModel.autocopy) {
                    
                }
            }
            
        }
        .background(Color.somewhite)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

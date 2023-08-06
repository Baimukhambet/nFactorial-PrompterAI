//
//  HistoryView.swift
//  UIPrompterAI
//
//  Created by Timur Baimukhambet on 11.07.2023.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State var close = false
    var body: some View {
        NavigationStack {
            if viewModel.getHistory().count > 0{
                List {
                    ForEach(viewModel.getHistory(), id: \.self) { chat in
                        NavigationLink {
                            PromptResponseView(promptResponse: chat, answerReady: .constant(false))
                        } label: {
                            withAnimation {
                                Text(chat.title)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteResponse(indexSet)
                    }
                }
                .navigationTitle(
                    Text((Texts.getLanguage(viewModel.language))["history title"]!)
                )
                .navigationBarTitleDisplayMode(.inline)
            } else {
                Text((Texts.getLanguage(viewModel.language))["empty history"]!)
                    .navigationTitle(
                        Text((Texts.getLanguage(viewModel.language))["history title"]!)
                    )
                    .navigationBarTitleDisplayMode(.inline)
            }
            
        }
        .background(Color.somewhite)
    }
    
}




struct HistoryView_Previews: PreviewProvider {
    static let previewModel = addPreviewHistory(ViewModel())
    static var previews: some View {
        HistoryView()
            .environmentObject(previewModel)
    }
    
    static func addPreviewHistory(_ previewModel: ViewModel) -> ViewModel {
        previewModel.addResponse(response: ResponseModel(prompt: "How to become iOS developer?", questions: [], title: "How to become iOS developer"))
        previewModel.addResponse(response: ResponseModel(prompt: "How to become iOS developer?", questions: [], title: "How to cool uzbek plov"))
        previewModel.addResponse(response: ResponseModel(prompt: "How to become iOS developer?", questions: [], title: "3D shapes explained in UIKit"))
        previewModel.addResponse(response: ResponseModel(prompt: "How to become iOS developer?", questions: [], title: "Core animation and Core Graphics frameworks"))
        return previewModel
    }
}


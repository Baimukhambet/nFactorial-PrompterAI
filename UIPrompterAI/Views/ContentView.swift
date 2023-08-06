import SwiftUI
import Neumorphic

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    let accentColorMain = Color("AccentColorMain")

    @State var text = ""
    @State var isLoading = false
    @State var answerReady = false
    @State var promptResponse: ResponseModel?
    @State var copied = false
    @FocusState private var promptIsFocused: Bool
    private let pasteboard = UIPasteboard.general
    @State var questions = [String]()
    @State var error = false
    
    @State var addingKeyword = false
    @State var editingKeyword = false
    
    @State var keywords = [String]()
    @State var currentKeyword: String = ""
    @State var keywordLength: Int = 0
    
    var body: some View {
        NavigationStack{
            VStack{
                if answerReady {
                    Spacer()
                    PromptResponseView(promptResponse: self.promptResponse!, answerReady: $answerReady)
                } else {
                    HStack(spacing: 0){

                        
                        Image("robotimage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 54, height: 54)
                        
                        Text("PrompterAI")
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .padding(.top, 4)
                            
                        Spacer()
                        
                        Picker("Language", selection: $viewModel.language) {
                            Text("EN")
                                .tag("en")
                                .font(.system(size: 12, design: .monospaced))
                            Text("RU")
                                .tag("ru")
                                .font(.system(size: 12, design: .monospaced))
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 24)
 
                    
                
                    Text((Texts.getLanguage(viewModel.language))["description"] ?? "Nothing")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 16, design: .monospaced))
                        .padding(.horizontal, 28)
                    
                    Spacer()
                        .frame(height: 140)
                        
                    
    
                    
                   HStack {
                        Button {
                            addingKeyword = true
                        } label: {
                            HStack(spacing: 2) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 8, height: 8)
                                Text("keyword")
                                    .font(.system(size: 14))
                                
                            }
                        }
                        .softButtonStyle(RoundedRectangle(cornerRadius: 10), padding: 6, textColor: Color.gray, darkShadowColor: Color.white)
                        .alert("Enter a keyword", isPresented: $addingKeyword) {
                                    TextField("", text: $currentKeyword)
                                        .textInputAutocapitalization(.never)
                            
                            Button("Add") {
                                keywords.append(currentKeyword)
                                currentKeyword = ""
                            }
                                    Button("Cancel", role: .cancel) { }
                                } message: {
                                    Text("")
                                }
                       
                       ScrollView([.horizontal]) {
                           HStack {
                               ForEach(keywords, id: \.self) { kw in
                                   Text(kw)
                                       .font(.system(size: 14))
                                       .padding(6)
                                       .foregroundColor(Color.black.opacity(0.8))
                                       .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 0.925, green: 0.941, blue: 0.953)))
                                       .onTapGesture {
                                           currentKeyword = kw
                                           editingKeyword = true
                                       }
          
                                       .onLongPressGesture {
                                           keywords.remove(at:keywords.firstIndex(of: kw)!)
                                       }
                                       
                                       .alert("Change the keyword", isPresented: $editingKeyword) {
                                                   TextField("", text: $currentKeyword)
                                                       .textInputAutocapitalization(.never)
                                                       .preferredColorScheme(.light)
                                           
                                           Button("Save") {
                                               keywords[keywords.firstIndex(of: kw)!] = currentKeyword
                                               currentKeyword = ""
                                           }
                                           .preferredColorScheme(.light)
                                                   Button("Cancel", role: .cancel) { currentKeyword = "" }
                                               } message: {
                                                   Text("")
                                               }
                                               .preferredColorScheme(.light)
                               }
                           }
                           
                       }

                       
                       Spacer()
                        
                    }
                   .padding(.horizontal, 36)
                    
                    TextField((Texts.getLanguage(viewModel.language))["placeholder"] ?? "Type your prompt here...", text: $text)
                        .frame(width: 300)
                        .padding(.all, 12)
                        .font(.system(size: 16, design: .monospaced))
                        .focused($promptIsFocused)
                        .cornerRadius(10)
                        .background(
                           RoundedRectangle(cornerRadius: 16)
                            .fill(Color.offwhite)
                            .softInnerShadow(RoundedRectangle(cornerRadius: 16), darkShadow: .black, lightShadow: .offwhite, spread: 0.05, radius: 2)
                         )
                        .padding(.horizontal, 16)
                        
                                 
                    if isLoading {
                        HStack(spacing: 4) {
                            Text((Texts.getLanguage(viewModel.language))["loading"] ?? "Loading")
                                .font(.system(size: 16, design: .monospaced))
                            ProgressView()
                                .controlSize(.regular)
                                
                        }
                        .padding(.top, 54)
                        
                    } else {
                        
                        HStack(spacing: 24) {
                            if !keywords.isEmpty {
                                Button{
                                    keywords = []
                                } label: {
                                    Image(systemName: "trash.fill").renderingMode(.template)
                                        .foregroundColor(.black.opacity(0.9))
                                    
                                }
                                .softButtonStyle(RoundedRectangle(cornerRadius: 12), padding: 12,  mainColor: Color.red)
                                
                                
                            }
                            //GENERATE PROMPT
                            Button{
                                promptIsFocused = false
                                send()
                            } label: {
                                Text((Texts.getLanguage(viewModel.language))["generate_prompt"] ?? "Generate Prompt")
                                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                    .foregroundColor(.black)
                                
                            }
                            .softButtonStyle(RoundedRectangle(cornerRadius: 12), mainColor: .offwhite)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 54)
                    }
                    if viewModel.getHistory().count > 0 && !promptIsFocused {
                        Text((Texts.getLanguage(viewModel.language))["last prompt"] ?? "Last prompt:")
                            .padding(.top, 88)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 24)
                            .font(.system(size: 18, weight: .semibold,  design: .monospaced))
                        NavigationLink{
                            PromptResponseView(promptResponse: viewModel.getHistory().last!, answerReady: .constant(false))
                        } label: {
                            Text(viewModel.getHistory().last!.title)
                                .foregroundColor(accentColorMain)
                                
                                .padding(.horizontal, 24)
                        }

                        .padding(.top, 24)
                    }
                    Spacer()
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .padding(.top, 32)
            .onTapGesture {
                promptIsFocused = false
            }
        }
        .background(Color.somewhite)
        .overlay {
            if error {
                Text("An error occured")
                    .padding(12)
                    .background(Rectangle().fill(Color.red.opacity(0.9)).cornerRadius(14))
                    .font(.system(size: 18, design: .monospaced))
                    .padding(.top, 16)
            }
        }

    }
        
    
    
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let promptLanguage = viewModel.language
        isLoading = true
        viewModel.send(text: text, viewModel.language, keywords: keywords) { response in
            DispatchQueue.main.async {
                self.text = ""
                //decode string to ResponseModel object
                guard let jsonData = response.data(using: .utf8) else {
                    error = true
                    isLoading = false
                    return
                }
                let finalResponse = try? JSONDecoder().decode(ResponseModel.self, from: jsonData)
                
                if let finalResponse = finalResponse {
                    //set promptResponse
                    self.promptResponse = finalResponse
                    self.promptResponse?.language = promptLanguage

                    isLoading = false
                    
                    //save to history
                    viewModel.addResponse(response: promptResponse!)
                    if viewModel.autocopy {
                        pasteboard.string = promptResponse?.prompt
                    }
                    
                    withAnimation {
                        answerReady.toggle()
                    }
                } else {
                    withAnimation {
                        error = true
                        isLoading = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            error = false
                        }
                    }
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}



extension Color {
    static let offwhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    static let somewhite = Color(red: 255/255, green: 253/255, blue: 250.255)
}

struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(
                Group {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.offwhite)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(RoundedRectangle(cornerRadius: 12).fill(LinearGradient(Color.black, Color.clear)))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(RoundedRectangle(cornerRadius: 12).fill(LinearGradient(Color.clear, Color.black)))
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.offwhite)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
            )
            .padding(.top, 24)
    }
}


extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

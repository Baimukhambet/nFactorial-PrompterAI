import SwiftUI
import Neumorphic

struct PromptResponseView: View {
    //response object
    let promptResponse: ResponseModel
    
    @Environment(\.dismiss) var dismiss
    
    //@State vars to track which view to show and if user has copied text
    @State var isCopied = false
    @State var showQuestions = false
    
    //@Binding var to track if user closes current view
    @Binding var answerReady: Bool
    
    //pasteboard object to store copied text on device
    private let pasteboard = UIPasteboard.general
    
    //track what text to show depending on a view a user is currently on
    @State var nextWindow = "Questions"
    
    private let cardColor = Color(#colorLiteral(red: 0.7130188346, green: 0.6905894279, blue: 1, alpha: 1))
    private let leftButtonColor = Color(#colorLiteral(red: 0.6335971951, green: 0.5130764842, blue: 1, alpha: 1)).opacity(0.7)
    private let rightButtonColor = Color(#colorLiteral(red: 0.9999868274, green: 0.003372059204, blue: 0.03615048155, alpha: 1)).opacity(0.8)
    //Color(red: 234/255, green: 26/255, blue: 11/255).opacity(0.85)
    private let rightButtonDark = Color(#colorLiteral(red: 0.7869700789, green: 0.07712619752, blue: 0.1003863737, alpha: 1))
    private let rightButtonLight = Color(#colorLiteral(red: 0.9724728465, green: 0.9079138041, blue: 0.9109911323, alpha: 1))
    private let copiedColor = Color(#colorLiteral(red: 0.4215438068, green: 0.733666718, blue: 0.9079594016, alpha: 1)).opacity(0.8)
    
    
    var body: some View {
        VStack(spacing: 12) {
            Text((Texts.getLanguage(promptResponse.language!))["hint"]!)
                .font(.system(size: 14, design: .monospaced))
                .padding(.top, 24)
                .padding(.horizontal, 16)
                .opacity(0.9)
            
            if !showQuestions{
                
                HStack {
                    Text((Texts.getLanguage(promptResponse.language!))["generated prompt"] ?? "Generated Prompt:")
                        .font(.system(size: 18, design: .monospaced))
                        
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)
                ScrollView {
                    Text(promptResponse.prompt)
                        .font(.system(size: 14, design: .monospaced))
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.offwhite)
                                .softOuterShadow()
                        )
                        .padding(.horizontal, 24)
                    
                    
                        .onTapGesture(count: 2) {
                            pasteboard.string = promptResponse.prompt
                            withAnimation {
                                isCopied = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation {
                                    isCopied = false
                                }
                            }
                        }
                }
                .padding(.top, 16)
            } else {
               HStack {
                    Text((Texts.getLanguage(promptResponse.language!))["additional questions"] ?? "Additional Questions:")
                        .font(.system(size: 18, design: .monospaced))
                        
                   Spacer()
                }
               .padding(.top, 24)
               .padding(.bottom, 10)
               .frame(width: 340)
               
                
                
                ScrollView {
                    ForEach(promptResponse.questions, id: \.self) { question in
                        Text(question)
                            .font(.system(size: 14, design: .monospaced))
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.offwhite)
                                    .softOuterShadow()
                                    .frame(width: 350)
                            )
                            .frame(width: 340)
                            .padding(.top, 6)
                            .padding(.horizontal, 24)
                            .onTapGesture(count: 2) {
                                pasteboard.string = question
                                withAnimation {
                                    isCopied = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        isCopied = false
                                    }
                                }
                            }
                    }
                }
                
                
            }
            Spacer()
            HStack(spacing: 44) {
                Button {
                    showQuestions.toggle()
                } label: {
                    Text(!showQuestions ? (Texts.getLanguage(promptResponse.language!))["questions"]! : (Texts.getLanguage(promptResponse.language!))["prompt"]!)
                        .frame(width: 120, height: 26)
                        .font(.system(size: 18, design: .monospaced))
                }.softButtonStyle(RoundedRectangle(cornerRadius: 12), textColor: .black)
                
                Button{
                    answerReady = false
                    dismiss()
                } label: {
                    Text((Texts.getLanguage(promptResponse.language!))["close"]!)
                        .frame(width: 100, height: 26)
                }.softButtonStyle(RoundedRectangle(cornerRadius: 12), mainColor: rightButtonColor, textColor: .black, darkShadowColor: rightButtonDark, lightShadowColor: rightButtonLight)
                    .font(.system(size: 18, design: .monospaced))
            }
            .padding(.bottom, 52)
            
            
            
        }
        .overlay {
            if isCopied {
                Text((Texts.getLanguage(promptResponse.language!))["copied"]!)
                    .padding(12)
                    .background(Rectangle().fill(copiedColor).cornerRadius(14))
                    .font(.system(size: 18, design: .monospaced))
                    .padding(.top, 16)
            }
        }
        
    }
}

struct PromptResponseView_Previews: PreviewProvider {
    static var previews: some View {
        PromptResponseView(promptResponse: ResponseModel(prompt: "How to manage my budget properly, provide step-by-step guide on how to become fully aware of my finances", questions: ["question1", "question2"], title: "hello world", language: "en"), answerReady: .constant(true))
    }
}



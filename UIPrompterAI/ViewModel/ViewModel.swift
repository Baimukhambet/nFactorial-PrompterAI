import Foundation
import SwiftUI
import OpenAISwift

enum Language {
    case ru
    case en
}

final class ViewModel: ObservableObject {
    init() {}
    private var client: OpenAISwift?
    @Published private var history: [ResponseModel]?
    @Published var language: String = "en"
    @Published var autocopy: Bool = false
    @Published var temperature: String = "medium"
    var temps = ["low": 0.5, "medium": 1.0, "high": 1.5]
    
    func setup() {
        client = OpenAISwift(authToken: "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")
        history = UserDefaults.standard.history
        language = UserDefaults.standard.language
        autocopy = UserDefaults.standard.autocopy
        temperature = UserDefaults.standard.temperature
    }
    
    func getHistory() -> [ResponseModel] {
        guard let history = self.history else { return [] }
        return history
    }
    
    func addResponse(response: ResponseModel) {
        self.history?.append(response)
    }
    
    func deleteResponse(_ indexSet: IndexSet) {
        self.history?.remove(atOffsets: indexSet)
        return
    }
    
    func saveHistory() {
        UserDefaults.standard.history = self.history!
        UserDefaults.standard.language = self.language
        UserDefaults.standard.autocopy = self.autocopy
        UserDefaults.standard.temperature = self.temperature
    }
    
    func getPreviewHistory() -> [ResponseModel] {
        return [
            ResponseModel(prompt: "", questions: [], title: "How to become iOS developer", language: "en"),
            ResponseModel(prompt: "", questions: [], title: "How to become iOS developer", language: "en"),
            ResponseModel(prompt: "", questions: [], title: "How to become iOS developer", language: "en")
        ]
    }
    
    func send(text: String, _ language: String, keywords: [String]?, completion: @escaping (String) -> Void) {
        
        let chat: [ChatMessage]
        
        if language == "ru" {
            if let keywords = keywords, keywords.count > 0 {
                
                chat = [
                    ChatMessage(role: .user, content: "Действуй как промпт инженер. Я предоставлю тебе промпт, который я хочу отправить в ChatGPT. Твоя задача — улучшить мой промпт, чтобы получить наилучший ответ. Измени мой промпт, чтобы он был в формате профессионального промпта, который написал промпт инженер, включая все возможные темы, связанные с моим промптом, чтобы получить наилучшие результаты. Также предоставь 5 коротких вопросов, связанных с темой. Ты должен вернуть только финальный промпт и 5 вопросов, также сгенерировать короткий и лаконичный заголовок для промпта, чтобы я сразу понял контекст. Вывод должен быть в формате json: {prompt: _enhanced_prompt_, questions: [_question1_, _question2_, _question3_, _question4_, _question5_], title: _title_}. Мой промпт: '\(text)'. Включи следующие ключевые слова в свой ответ: \(keywords). Ответ:")
                ]
            } else {
                chat = [ChatMessage(role: .user, content: "Действуй как промпт инженер. Я предоставлю тебе промпт, который я хочу отправить в ChatGPT. Твоя задача — улучшить мой промпт, чтобы получить наилучший ответ. Измени мой промпт, чтобы он был в формате профессионального промпта, который написал промпт инженер, включая все возможные темы, связанные с моим промптом, чтобы получить наилучшие результаты. Также предоставь 5 коротких вопросов, связанных с темой. Ты должен вернуть только финальный промпт и 5 вопросов, также сгенерировать короткий и лаконичный заголовок для промпта, чтобы я сразу понял контекст. Вывод должен быть в формате json: {prompt: _enhanced_prompt_, questions: [_question1_, _question2_, _question3_, _question4_, _question5_], title: _title_}. Мой промпт: '\(text)'. Ответ:")]
            }
        }
        
        else {
            if let keywords = keywords, keywords.count > 0 {
                chat = [
                    ChatMessage(role: .user, content: "Act like a prompt engineer. I will provide you with a prompt I would like to send to ChatGPT. Your task is to improve my prompt to get the best response. Modify my prompt to be in a prompt engineering-like format, including all possible topics related to my prompt in order to get the best results. If a ask about formatting text, provide direct examples in your response. Also provide user with 5 short questions related to the topic. You have to return only the final prompt and 5 questions, also generate a short and concise title for the prompt, so that I will immediately understand the context, nothing more. Your output should be in a json-like format: {prompt: _enhanced_prompt_, questions: [_question1_, _question2_, _question3_, _question4_, _question5_], title: _title_} My prompt is: '\(text)'. Include next keywords in the generated prompt: \(keywords). Output:")
                ]
            }
            else {
                chat = [
                    ChatMessage(role: .user, content: "Act like a prompt engineer. I will provide you with a prompt I would like to send to ChatGPT. Your task is to improve my prompt to get the best response. Modify my prompt to be in a prompt engineering-like format, including all possible topics related to my prompt in order to get the best results. If a ask about formatting text, provide direct examples in your response. Also provide user with 5 short questions related to the topic. You have to return only the final prompt and 5 questions, also generate a short and concise title for the prompt, so that I will immediately understand the context, nothing more. Your output should be in a json-like format: {prompt: _enhanced_prompt_, questions: [_question1_, _question2_, _question3_, _question4_, _question5_], title: _title_} My prompt is: '\(text)'. Output:")
                ]
            }
        }
        

        
        client?.sendChat(with: chat, temperature: self.temps[self.temperature], completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.message.content ?? ""
                completion(output)
            case .failure:
                completion("request timeout")
                
            }
            print("Temperature: \(self.temperature)")
            
        })
    }
}

extension UserDefaults {
    var history: [ResponseModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "history") else { return [] }
            return (try? PropertyListDecoder().decode([ResponseModel].self, from: data)) ?? []
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "history")
        }
    }
    
    var language: String {
        get {
            guard let language = UserDefaults.standard.string(forKey: "language") else {
                return "en"
            }
            return language
            
            
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "language")
        }
    }
    var autocopy: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "autocopy")
            
            
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "autocopy")
        }
    }
    
    var temperature: String {
        get {
            guard let temp = UserDefaults.standard.string(forKey: "temp") else {
                return "medium"
            }
            return temp
            
            
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "temp")
        }
    }
}


/*
1. Create EnvironmentObject to track a chosen language
2. Depending on the language, update UI
3. In send() function create language parameter to send off instructions in selected language
4.
 
 */

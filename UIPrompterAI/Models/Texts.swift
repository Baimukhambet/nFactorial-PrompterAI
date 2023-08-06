//
//  Texts.swift
//  UIPrompterAI
//
//  Created by Timur Baimukhambet on 25.07.2023.
//

import Foundation

typealias ViewText = [String: String]

struct Texts {
    static let en: ViewText = [
        "description": "Improve your experience with AI with the help of PrompterAI!",
        "placeholder": "Type your prompt here...",
        "generate_prompt": "Generate Prompt",
        "loading": "Loading",
        "last prompt": "Last prompt:",
        "clean kw": "keywords",
        
        "history title": "History",
        "prompt": "Prompt",
        "additional questions": "Questions:",
        "questions": "Questions",
        "hint": "Hint: double tap on a card to copy text",
        "close": "Close",
        "copied": "Copied!",
        "generated prompt": "Prompt:",
        
        "empty history": "Your history is empty!",
        "temperature": "Сreativity",
        "language": "Language",
        "autocopy": "Auto-copy prompt",
    ]
    
    static let ru: ViewText = [
        "description": "Получите максимум пользы от AI с помощью PrompterAI!",
        "placeholder": "Напишите свой промпт здесь...",
        "generate_prompt": "Сгенерировать промпт",
        "loading": "Загрузка",
        "last prompt": "Последний промпт:",
        "clean kw": "ключ. слова",
        
        "history title": "История",
        "prompt": "Промпт",
        "additional questions": "Вопросы:",
        "questions": "Вопросы",
        "hint" : "Подсказка: тапните два раза на карточку чтобы скопировать текст",
        "close": "Закрыть",
        "copied": "Скопировано!",
        "generated prompt": "Промпт:",
        
        "empty history": "У вас пустая история!",
        "temperature": "Креативность",
        "language": "Язык",
        "autocopy": "Авто-копия промпта",
    ]
    
    static func getLanguage(_ language: String) -> ViewText{
        if language == "en" {
            return en
        } else if language == "ru" {
            return ru
        }
        return [:]
        
    }
}

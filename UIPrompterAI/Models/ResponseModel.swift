//
//  ResponseModel.swift
//  UIPrompterAI
//
//  Created by Timur Baimukhambet on 11.07.2023.
//

import Foundation


struct ResponseModel: Codable, Hashable {
    var prompt: String
    var questions: [String]
    var title: String
    var language: String?
}


//
//  TabItems.swift
//  UIPrompterAI
//
//  Created by Timur Baimukhambet on 22.07.2023.
//

import Foundation


enum TabbedItems: Int, CaseIterable {
    case main = 0
    case history
    
    var title: String {
        switch self {
        case .main:
            return "Main"
        case .history:
            return "History"
        }
    }
    
    var imageName: String {
        switch self {
        case .main:
            return "house.fill"
        case .history:
            return "archivebox.fill"
        }
    }
}

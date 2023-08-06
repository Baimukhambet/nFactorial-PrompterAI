//
//  HistoryViewCell.swift
//  UIPrompterAI
//
//  Created by Timur Baimukhambet on 20.07.2023.
//

import SwiftUI

struct HistoryViewCell: View {
    @State var title: String
    
    var body: some View {
        ZStack{
            HStack {
                Text(title)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(">")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
            .padding(12)
            
        }
        .padding(8)
        .background(
           RoundedRectangle(cornerRadius: 12)
            .fill(Color.offwhite)
            .frame(width: 380)
         )
    }
}

struct HistoryViewCell_Previews: PreviewProvider {
    static var previews: some View {
        HistoryViewCell(title: "HEllo")
    }
}

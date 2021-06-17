//
//  AddReviewView.swift
//  adidas-case
//
//  Created by PaulVaughan on 17/06/2021.
//

import SwiftUI

class AddReviewViewModel: ObservableObject {
    var productId: String
    @Published var rank = 10.0
    @Published var comment = ""
    
    init(productId: String) {
        self.productId = productId
    }
}


struct AddReviewView: View {
    var dismissAction: (() -> Void)
    @EnvironmentObject var review: AddReviewViewModel
    @State private var speed = 50.0
    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text("Select a rating")
            VStack {
                Slider(
                    value: $review.rank,
                    in: 0...10,
                    onEditingChanged: { editing in
                        isEditing = editing
                    }
                )
                Text("\(Int(review.rank))")
                    .foregroundColor(isEditing ? .red : .blue)
                
            }
            Text("Add a comment")
            TextEditor(text: $review.comment).frame(minHeight: 250.0)
            HStack{
                Button("Cancel") {
                    print("Button tapped!")
                    dismissAction()
                }
                Spacer()
                Button("Submit review") {
                    print("Button tapped!")
                    dismissAction()
                }
            }
            Spacer()
        }.padding(25.0)
       
    }
}



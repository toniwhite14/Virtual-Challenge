//
//  KeyboardResponder.swift
//  Virtual Challenge
//
//  Created by Mac on 09/07/2020.
//  Copyright © 2020 Toni. All rights reserved.
//
import Foundation
import SwiftUI

class KeyboardResponder: ObservableObject {
    
    @Published var currentHeight: CGFloat = 0
    
    var _center: NotificationCenter
    
    init(center: NotificationCenter = .default) {
    _center = center
    
    _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    @objc func keyBoardWillShow(notification: Notification) {
        if let keyBoardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            withAnimation {
                currentHeight = keyBoardSize.height
            }
        }
    }
  
    @objc func keyBoardWillHide(notification: Notification) {
        withAnimation {
            currentHeight = 0
        }
    }
}

/*
struct KeyboardResponder_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardResponder()
    }
}  */

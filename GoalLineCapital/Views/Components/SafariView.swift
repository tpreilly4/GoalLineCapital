//
//  SafariView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/12/24.
//


import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        // Customize the Safari view controller if needed
        return safariVC
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No dynamic updates required
    }
}

//
//  HomeView.swift
//  biblioteca
//
//  Created by yoset on 22/08/1403 AP.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userSession: UserSession
   
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome, \(userSession.username)!")
                    .font(.largeTitle)
                    .padding()
               
                Image("gallery_image")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
               
                Text("Explore the art gallery and discover amazing artworks.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
               
                Spacer()
               
                Button(action: {
                    userSession.logout()
                }) {
                    Text("Logout")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(5.0)
                }
                .padding()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}
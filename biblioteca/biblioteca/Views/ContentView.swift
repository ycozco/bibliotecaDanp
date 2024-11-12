//
//  ContentView.swift
//  biblioteca
//
//  Created by yoset on 22/08/1403 AP.
//
import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSession: UserSession
   
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
           
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
           
            ScanQRView()
                .tabItem {
                    Label("ScanQR", systemImage: "qrcode.viewfinder")
                }
           
            PaintingDetailView()
                .tabItem {
                    Label("Painting", systemImage: "paintbrush")
                }
        }
    }
}
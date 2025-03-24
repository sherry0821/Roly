////
////  LoadingView.swift
////  Roly
////
////  Created by 劉采璇 on 3/13/25.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    @EnvironmentObject var viewModel: AuthViewModel
//    @State private var hasSeenIntro = false // Track if intro has been seen
//    
//    var body: some View {
//        Group {
//            if viewModel.isLoading {
//                ZStack {
//                    Color.black.opacity(0.8) // 深色背景，增加對比度
//                        .ignoresSafeArea()
//                    
//                    ProgressView("Loading...")
//                        .progressViewStyle(CircularProgressViewStyle(tint: .white)) // 明確指定白色動畫
//                        .font(.headline)
//                        .foregroundColor(.white) // 文字顏色
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(Color.gray.opacity(0.3)) // 半透明灰色背景
//                        )
//                }
//            } else if !hasSeenIntro {
//                IntroView(onComplete: { hasSeenIntro = true })
//            } else if viewModel.userSession != nil {
//                RolyView()
//            } else {
//                LoginView()
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .environmentObject(AuthViewModel())
//}

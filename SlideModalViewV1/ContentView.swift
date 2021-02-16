//
//  ContentView.swift
//  SlideModalViewV1
//
//  Created by yorifuji on 2021/02/16.
//

import SwiftUI

struct ContentView: View {
    @State private var isShow = false

    var body: some View {
        ZStack {
            Color(red: 241/255, green: 238/255, blue: 229/255, opacity: 1.0)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Button("show") {
                    isShow.toggle()
                }
                    .font(.title)
                .padding(.bottom, 50)
            }
            if isShow {
                SlideModalView() {
                    print("close")
                    isShow = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SlideModalView: View {
    let onClose: () -> Void
    private let viewHeight: CGFloat = 300
    @State private var didAppear: Bool = false
    @State private var offset: CGFloat = .zero
    @State private var lastOffset: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            VStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.gray)
                    .frame(width: 40, height: 5)
                    .padding(.top, 5)
                Text("SlideModalView")
                    .foregroundColor(.black)
                Spacer()
                Button("close") {
                    onClose()
                }
                Spacer()
            }
            .frame(width: geometry.size.width, height: viewHeight)
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .animation(.interactiveSpring())
            .onAppear {
                self.lastOffset = geometry.size.height - viewHeight
                self.offset = geometry.size.height - viewHeight
                self.didAppear = true
            }
            .offset(y: didAppear ? self.offset : geometry.size.height)
            .gesture(DragGesture(minimumDistance: 2)
                .onChanged { v in
                    let newOffset = self.lastOffset + v.translation.height
                    if (geometry.size.height - viewHeight < newOffset && newOffset < geometry.size.height) {
                        self.offset = newOffset
                    }
                }
                .onEnded{ v in
                    if self.offset < (geometry.size.height - (viewHeight / 2)) {
                        self.offset = geometry.size.height - viewHeight
                    }
                    else {
                        self.offset = geometry.size.height
                    }
                    self.lastOffset = self.offset
                    if self.offset == geometry.size.height {
                        onClose()
                    }
                }
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}

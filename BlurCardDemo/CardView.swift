//
//  CardView.swift
//  BlurCardDemo
//
//  Created by Brian Masse on 5/25/24.
//

import Foundation
import SwiftUI

struct Card: View {
//    MARK: Constants
    struct Constants {
        static let width: CGFloat = 300
        static let aspectRatio: CGFloat = 4/3
        
        static let titleFont = "SpaceGrotesk-Medium"
        static let mainFont = "SpaceGrotesk-Regular"
    }
    
//    MARK: Vars
    let image: String = "Mojave"
    
    @State var xRotation: Angle = Angle(degrees: 0)
    @State var yRotation: Angle = Angle(degrees: 0)
    
    @State var scale: CGFloat = 1
    
    private func checkIsOnBack() -> Bool {
        return floor((abs(xRotation.degrees) + 90) / 180).remainder(dividingBy: 2) != 0
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                xRotation = Angle(degrees: value.translation.width)
                yRotation = Angle(degrees: -value.translation.height / 10)
            }
            .onEnded { value in
                withAnimation {
                    xRotation = Angle(degrees: 0)
                    yRotation = Angle(degrees: 0)
                }
            }
    }
    
//    MARK: Overlay
    @ViewBuilder
    private func makeDottedOverlay() -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.65, color: .white))
            context.addFilter(.luminanceToAlpha)
            context.addFilter(.blur(radius: 0.4))
            
            context.drawLayer { ctx in
                let image = ctx.resolveSymbol(id: 2)!
                
                ctx.draw(image, at: .init(x: size.width / 2, y: size.height / 2))
            }
            
        } symbols: {
            ZStack {
                makeImage(image)
                    .grayscale(1)
                
                makeImage("texture")
                    .scaleEffect(2)
                    .clipped()
                    .blendMode( .colorDodge )
            }
            .tag(2)
        }
        .frame(height: 450)
    }
    
//    MARK: Background
    @ViewBuilder
    private func makeImage(_ image: String) -> some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: Constants.width, height: Constants.width * Constants.aspectRatio)
            .clipped()
    }
    
    @ViewBuilder
    private func makeBackground() -> some View {
        ZStack {
            makeImage(image)
                .blur(radius: 30)
            
            makeDottedOverlay()
                .blendMode(.overlay)
                .opacity(0.2)
            
            makeImage("noise")
                .opacity(0.1)
                .blendMode(.overlay)
        }
        .scaleEffect(1.3)
        .blur(radius: 0.2)
        .background(.white)
        .frame(width: Constants.width, height: Constants.aspectRatio * Constants.width)
        .overlay(.white.opacity(0.1))
        .clipShape( RoundedRectangle(cornerRadius: 25) )
        
        .shadow(color: .black.opacity(0.3), radius: 0.5, x: 1, y: 1)
        .shadow(color: .white.opacity(0.2), radius: 0.5, x: -1, y: -1)
    }
    
//    MARK: Content
    @ViewBuilder
    private func makeTitle() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Brian")
                    .textCase(.uppercase)
                    .font(Font.custom(Constants.titleFont, size: 35))
                Text("Masse")
                    .textCase(.uppercase)
                    .font(Font.custom(Constants.titleFont, size: 35))
                    .offset(y:-15)
            }
            
            Image(systemName: "staroflife.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func makeDetail(title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 0 ) {
            Text(title)
                .textCase(.uppercase)
                .font(Font.custom(Constants.mainFont, size: 10))
            
            Text(detail)
                .textCase(.uppercase)
                .font(Font.custom(Constants.titleFont, size: 20))
                .padding(.bottom)
        }
    }
    
    @ViewBuilder
    private func makeDetails() -> some View {
        makeDetail(title: "card number", detail: "2821 **** **** 1002")
        
        makeDetail(title: "card holder", detail: "Brain J. Masse")
        
        HStack(spacing: 15) {
            makeDetail(title: "Exp. Date", detail: "10/28")
            makeDetail(title: "CCV", detail: "***")
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func makeContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if !checkIsOnBack() {
                makeTitle()
                
                Spacer()
                
                makeDetails()
            }
        }
        .padding(30)
        .foregroundStyle(.white)
    }
    
//    MARK: Body
    var body: some View {
        makeBackground()
            .overlay { makeContent() }
        
            .rotation3DEffect( xRotation, axis: (x: 0, y: 0.5, z: 0), perspective: 0.1 )
            .rotation3DEffect( yRotation, axis: (x: 0, y: 0, z: 1), perspective: 0 )
            .gesture(dragGesture)
            .scaleEffect(scale)
        
            .shadow(color: .black.opacity(0.35), radius: 25, x: 0, y: 10)
            .animation(
                .easeInOut
                , value: scale)
            
            .onTapGesture {
                scale = 1.05
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { scale = 1 }
            }
    }
}


//
//  ContentView.swift
//  TinderSwipe
//
//  Created by Aakash on 30/06/2020.
//  Copyright © 2020 Minhasoft. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var scheme
    
    let data: [Profile] = [
        .init(name: "Sara Hamish", age: "18+", photo: "s1"),
        .init(name: "Iqra Ali", age: "19+", photo: "s2"),
        .init(name: "Syed Mavra", age: "21+", photo: "s3"),
        .init(name: "Karishma Rani", age: "15+", photo: "s4"),
        .init(name: "Nandita", age: "21+", photo: "s5"),
        .init(name: "Kajal Keswani", age: "23+", photo: "s6")
    ]
    
    var body: some View {
        
        ZStack{
            Color.black
                .opacity(scheme == .light ? 0.05 : 1).edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Button(action: {}) {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .padding(10)
                            .frame(width:40 , height : 40)
                            .foregroundColor(scheme == .light ? .black : .white)
                            .cornerRadius(5)
                    }
                    
                    Text("Tinder Dating")
                        .foregroundColor(scheme == .light ? .black : .white)
                        .font(.title)
                        .bold()
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}) {
                        Image(systemName: scheme == .light ? "moon.fill" : "sun.min.fill")
                            .foregroundColor(scheme == .light ? .black : .white)
                    }
                }.padding(.horizontal)
                    .padding(.top, 10)
                
                GeometryReader{ g in
                    
                    ZStack{
                        ForEach(self.data, id: \.id){ profile in
                            ProfileView(profile: profile, frame: g.frame(in : .global))
                        }
                    }
                }.padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Profile{
    
    var id = UUID()
    var name:String
    var age:String
    var photo:String
    var offset:CGFloat = -1
    
}


struct ProfileView: View{
    
    @State var profile : Profile
    var frame: CGRect
    
    var body: some View{
        
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)){
            
            Image(profile.photo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: frame.width, height: frame.height)
            
            LinearGradient(gradient: .init(colors: [Color.black.opacity(0.5), .clear]), startPoint: .bottom, endPoint: .center)
            
            if profile.offset > 0{
                
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)){
                    Color.red.opacity(0.3)
                    
                    Text("Rejected")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .padding()
                }
                
            }else if profile.offset < 0{
                
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
                    Color.green.opacity(0.3)
                    
                    Text("Liked")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .padding()
                }
            }
            VStack{
                
                HStack{
                    VStack(alignment: .leading){
                        
                        Text(profile.name)
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        Text(profile.age)
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                }
                .padding()
                
                HStack(spacing : 30){
                    
                    Button(action: {
                        withAnimation(.easeIn) {
                            self.profile.offset = -UIScreen.main.bounds.width - 200
                        }
                    }) {
                        Image(systemName: "checkmark")
                            .resizable()
                            .foregroundColor(Color.white)
                            .frame(width: 25, height: 25)
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                        
                    }
                    
                    Button(action: {
                        withAnimation(.easeIn) {
                            self.profile.offset = UIScreen.main.bounds.width + 200
                        }
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(Color.white)
                            .frame(width: 25, height: 25)
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
                        
                    }
                    
                }.padding()
            }
        }
        .cornerRadius(15)
        .rotationEffect(.init(degrees: profile.offset == 0 ? 0: (profile.offset > 0 ? 12 : -12)))
        .offset(x: profile.offset)
        .gesture(DragGesture()
        .onChanged({ (value) in
            withAnimation(.default) {
                self.profile.offset = value.translation.width
            }
            
        })
            .onEnded({ (value) in
                withAnimation(.easeIn) {
                    if value.translation.width > 150{
                        self.profile.offset = UIScreen.main.bounds.width + 200
                    }else if value.translation.width < -150{
                        self.profile.offset = -UIScreen.main.bounds.width - 200
                    }else{
                        self.profile.offset = 0
                    }
                }
            })
        )
    }
    
}

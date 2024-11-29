//
//  RootMainView.swift
//  Imakoko
//
//  Created by t&a on 2022/09/07.
//

import SwiftUI

struct RootMainView: View {
    
    // MapModels：
    @StateObject private var locationManager = LocationManager.shared
    // メッセージバルーンクラス：
    @StateObject private var messageBalloon = MessageBalloon()
    
    // 現在地表示用真偽値
    @State private var isPreview: Bool = false
    // フィルターボタンを押されたかによってListLocationViewのNavigationLinkを操作
    @State private var isClick: Bool = false
    
    @State private var tapAddress: String = ""
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Group {
                    if isPreview {
                        HStack {
                            Spacer()
                            Text((locationManager.address != "" ?  (tapAddress != "" ? tapAddress : locationManager.address) : "位置情報をONにしてください" ) ?? "取得できないエリアです…")
                            ZStack {
                                if messageBalloon.isPreview {
                                    Text("コピーしました")
                                        .font(.system(size: 9))
                                        .padding(4)
                                        .background(Color(red: 0.3, green: 0.3 ,blue: 0.3))
                                        .opacity(messageBalloon.castOpacity())
                                        .cornerRadius(5)
                                        .offset(x: -5, y: -24)
                                }
                                Button {
                                    UIPasteboard.general.string = (tapAddress != "" ? tapAddress : locationManager.address)
                                    messageBalloon.isPreview = true
                                    messageBalloon.vanishMessage()
                                } label: {
                                    Image(systemName: "doc.on.doc")
                                        .frame(width: 70)
                                }.disabled(messageBalloon.isPreview)
                            }
                        }
                    } else {
                        Text(tapAddress != "" ? "選択した住所は...?" : "現在地は...?")
                    }
                }.foregroundColor(.white)
                    .fontWeight(.bold)
                    .textSelection(.enabled)
                    .font(.system(size: 17))
                    .frame(width: DeviceSizeUtility.deviceWidth - 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .background(Color("clear_thema_color"))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("ThemaColor"), style: StrokeStyle(lineWidth: 2))
                    }
                    .padding(.top)
                    .zIndex(2)
                    .onTapGesture {
                        isPreview.toggle()
                    }
                
                // MapView
                UIMapAddressGetView(tapAddress: $tapAddress)
                    .zIndex(1)
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 30) {
                        
                        VStack {
                            Button {
                                isClick.toggle()
                            } label: {
                                VStack{
                                    Image(systemName: "figure.wave")
                                        .font(.system(size: 20))
                                        .frame(width: 40 , height: 40)
                                        .background(tapAddress != "" ? Color.white : .gray)
                                        .cornerRadius(40)
                                    
                                    Text("現在地")
                                        .foregroundColor(tapAddress != "" ? Color.white : .gray)
                                }
                            }.disabled(tapAddress == "")
                            
                        }.frame(width: 80, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .background(Color("clear_thema_color"))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("ThemaColor"), style: StrokeStyle(lineWidth: 2))
                            }
                        
                        Spacer()
                        
                    }.foregroundColor(Color("ThemaColor"))
                        .padding(.leading)
                        .padding(.bottom, 30)
                    
                }.zIndex(2)
            }
            
            
        }
        .background(Color("ThemaColor"))
        .toolbar() {
            ToolbarItem(placement: .bottomBar, content: {
                // バナー広告
                AdMobBannerView()
                    .frame(width: DeviceSizeUtility.deviceWidth, height: 60)
            })
        }
        .onChange(of: isClick, perform: { _ in
            // Headerボタンクリック時の処理
            locationManager.reloadRegion()
            tapAddress = "" // タップアドレスを空にする
        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootMainView()
    }
}

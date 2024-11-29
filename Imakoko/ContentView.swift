//
//  ContentView.swift
//  Imakoko
//
//  Created by t&a on 2022/09/07.
//

import SwiftUI

struct ContentView: View {
    
    // MapModels：
    @ObservedObject private var locationManager = LocationManager()
    // メッセージバルーンクラス：
    @ObservedObject private var messageBalloon = MessageBalloon()
    
    // 現在地表示用真偽値
    @State private var isPreview: Bool = false
    // フィルターボタンを押されたかによってListLocationViewのNavigationLinkを操作
    @State private var isClick: Bool = false
    // デバイスの横幅と高さ
    private let deviceWidth = UIScreen.main.bounds.width
    private let deviceHeight = UIScreen.main.bounds.height
    
    @State private var tapAddress: String = ""
    
    var body: some View {
        VStack {
            
            
            VStack {
    
                ZStack(alignment: .top) {
                    // MARK: - Header
                    Group {
                        if isPreview {
                            HStack {
                                Spacer()
                                Text((locationManager.address != "" ?  (tapAddress != "" ? tapAddress : locationManager.address) : "位置情報をONにしてください" ) ?? "取得できないエリアです…")
                                ZStack {
                                    if (messageBalloon.isPreview){
                                        Text("コピーしました")
                                            .font(.system(size: 9))
                                            .padding(4)
                                            .background(Color(red: 0.3, green: 0.3 ,blue: 0.3))
                                            .opacity(messageBalloon.castOpacity())
                                            .cornerRadius(5)
                                            .offset(x: -5, y: -24)
                                    }
                                    Button(action: {
                                        UIPasteboard.general.string = (tapAddress != "" ? tapAddress : locationManager.address)
                                        messageBalloon.isPreview = true
                                        messageBalloon.vanishMessage()
                                    }, label: {
                                        Image(systemName: "doc.on.doc")
                                            .frame(width: 70)
                                    }).disabled(messageBalloon.isPreview)
                                }
                            }
                        } else {
                            Text(tapAddress != "" ? "選択した住所は...?" : "現在地は...?")
                        }
                    }.foregroundColor(.white)
                        .fontWeight(.bold)
                        .textSelection(.enabled)
                        .font(.system(size: 20))
                        .frame(width: deviceWidth - 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .background(Color("clear_thema_color"))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("ThemaColor"), style: StrokeStyle(lineWidth: 4))
                        }
                        .padding(.top)
                        .zIndex(2)
                    
                    // MapView
                    UIMapAddressGetView(tapAddress: $tapAddress)
                        .zIndex(1)
                    
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 30) {
                            Button {
                                isClick.toggle()
                            } label: {
                                VStack{
                                Image(systemName: "figure.wave")
                                    .font(.system(size:40))
                                    .frame(width: 60 , height: 60)
                                        .background(tapAddress != "" ? Color.white : Color("FontColor"))
                                        .cornerRadius(60)
                                        
                                    Text(tapAddress != "" ? "現在地に戻る" : "現在地")
                                        .foregroundColor(tapAddress != "" ? Color.white : Color("FontColor"))
                                }
                            }.disabled(tapAddress == "")
                            
                            Button(action: {
                                isPreview.toggle()
                            }, label: {
                                VStack{
                                    
                                
                                    Image("Imakoko-logo-pin")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .background(!isPreview ? Color.white : Color("FontColor"))
                                    .cornerRadius(60)
                                    Text(!isPreview ? "表示OFF" : "表示ON").foregroundColor(!isPreview ? Color.white : Color("FontColor"))
                                }
                            }).frame(width: 70 , height: 60)
                            
                        }.foregroundColor(Color("ThemaColor"))
                            .frame(width: deviceWidth, height:100)
                    }.zIndex(2)
                }
                
            
            }
            .background(Color("ThemaColor"))
            .toolbar(){
                ToolbarItem(placement: .bottomBar, content: {
                    // バナー広告
                    AdMobBannerView()
                        .frame(width: deviceWidth, height: 60)
                })
            }
            .onChange(of: isClick, perform: { _ in
                // Headerボタンクリック時の処理
                locationManager.reloadRegion()
                tapAddress = "" // タップアドレスを空にする
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

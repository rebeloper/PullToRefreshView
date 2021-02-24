//
//  PullToRefreshView.swift
//  
//
//  Created by Alex Nagy on 24.02.2021.
//

import SwiftUI

@available(iOS 14.0, *)
public struct PullToRefreshView<RefreshView: View>: View {
    
    public var coordinateSpaceName: String
    public var refreshView: () -> RefreshView
    public var onRefresh: () -> Void
    
    @State public var needRefresh: Bool = false
    
    public init(coordinateSpaceName: String, refreshView: @escaping () -> RefreshView, onRefresh: @escaping () -> Void) {
        self.coordinateSpaceName = coordinateSpaceName
        self.refreshView = refreshView
        self.onRefresh = onRefresh
    }
    
    public init(coordinateSpaceName: String, onRefresh: @escaping () -> Void) {
        self.coordinateSpaceName = coordinateSpaceName
        self.refreshView = { Image(systemName: "arrow.down") as! RefreshView }
        self.onRefresh = onRefresh
    }
    
    public var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                } else {
                    refreshView()
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}


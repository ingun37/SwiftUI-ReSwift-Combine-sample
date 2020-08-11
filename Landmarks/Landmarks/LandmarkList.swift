/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import SwiftUI

struct LandmarkList: View {
    @State var showFavoritesOnly = false
    @ObservedObject var state: SelectionPublisher<AppState>
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    AppStateManager.dispatchAction(action: .FetchLandmarks)
                }) {
                    Text("Refresh")
                }
                List {
                    Toggle(isOn: $showFavoritesOnly) {
                        Text("Show Favorites Only")
                    }
                    
                    ForEach(state.state.landmarks) { landmark in
                        if !self.showFavoritesOnly || landmark.isFavorite {
                            NavigationLink(
                                destination:
                                LandmarkDetail(
                                    landmark: AppStateManager.selectListener(initialValue: landmark, transform: {$0.landmarks.first{$0.id == landmark.id} ?? landmark}),
                                    isFavorite: AppStateManager.selectListener(initialValue: false, transform: {$0.favorites.contains(landmark.id)}))
                            ) {
                                LandmarkRow(landmark: landmark, isFavorite: AppStateManager.selectListener(initialValue: false, transform: { (state) in
                                    state.favorites.contains(landmark.id)
                                }))
                            }
                        }
                    }
                }
                .navigationBarTitle(Text("Landmarks"))
            }
        }
    }
}

struct LandmarksList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            LandmarkList(state: AppStateManager.selectListener(initialValue: AppState(), transform: {$0}))
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        .environmentObject(UserData())
    }
}


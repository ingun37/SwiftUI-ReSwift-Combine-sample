/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a landmark.
*/

import SwiftUI

struct LandmarkDetail: View {
    @ObservedObject var landmark: ObservableState<Landmark>
    @ObservedObject var isFavorite: ObservableState<Bool>
    var body: some View {
        VStack {
            MapView(coordinate: landmark.state.locationCoordinate)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)
            
            CircleImage(image: landmark.state.image)
                .offset(x: 0, y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.state.name)
                        .font(.title)
                    
                    Button(action: {
                        AppStateManager.dispatchAction(action: .ToggleFavorite(self.landmark.state.id))
                    }) {
                        if self.isFavorite.state {
                            Image(systemName: "star.fill")
                            .foregroundColor(Color.yellow)
                        } else {
                            Image(systemName: "star")
                            .foregroundColor(Color.gray)
                        }
                    }
                }
                
                HStack(alignment: .top) {
                    Text(landmark.state.park)
                        .font(.subheadline)
                    Spacer()
                    Text(landmark.state.state)
                        .font(.subheadline)
                }
            }
            .padding()
            
            Spacer()
        }
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return LandmarkDetail(landmark: AppStateManager.selectObservableObjectFor(initialValue: userData.landmarks[0], transform: {$0.landmarks[0]}), isFavorite: AppStateManager.selectObservableObjectFor(initialValue: true, transform: {_ in true}))
            .environmentObject(userData)
    }
}

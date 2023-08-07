//
//  Profile.swift
//  testGitHubApi
//
//  Created by ALIEV Dmitry on 07.08.2023.
//

import ComposableArchitecture
import SwiftUI

struct Profile: Reducer {
    struct State: Equatable {
        @BindingState var bio = ""
        var login: String = ""
        var avatarUrl: String?

        var isFetchUserRequestInFlight = false
        var inputHasBeenChanged = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case viewWillAppear
        case userFetchResponse(TaskResult<GHUser>)
        case updateBioTapped
    }
    
    @Dependency(\.ghUserClient) var ghUserClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .viewWillAppear:
                state.isFetchUserRequestInFlight = true
                return .run { send in
                    await send(.userFetchResponse(TaskResult { try await self.ghUserClient.fetchUser() }))
                }
            case let .userFetchResponse(.success(user)):
                state.login = user.login
                state.bio = user.bio ?? ""
                state.avatarUrl = user.avatarUrl
                state.inputHasBeenChanged = false
                return .none
            case let .userFetchResponse(.failure(error)):
                print(error)
                return .none
            case .updateBioTapped:
                if !state.inputHasBeenChanged {
                    return .none
                }
                return .run { [bio = state.bio] send in
                    await send(.userFetchResponse(TaskResult { try await self.ghUserClient.updateBio(bio) }))
                }
            case .binding:
                state.inputHasBeenChanged = true
                return .none
            }
        }
    }
}

struct ProfileView: View {
    let store: StoreOf<Profile>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                AsyncImage(url: URL(string: viewStore.avatarUrl ?? "")) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .foregroundColor(.secondary)
                }
                .frame(width: 100, height: 100)
                
                Text(viewStore.login)
                    .font(.title)
                TextField("Bio", text: viewStore.$bio)
                    .disableAutocorrection(true)
                Button("Update bio") {
                    viewStore.send(.updateBioTapped)
                }
            }
            .task {
                viewStore.send(.viewWillAppear)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(
                store: Store(initialState: Profile.State()) {
                    Profile()
                }
            )
        }
    }
}

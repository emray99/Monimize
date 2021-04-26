//
//  MovieDetails.swift
//  Monimize
//
//  Created by Ray Liu on 4/25/21.
//

import SwiftUI

struct NowPlayingDetails: View {
   
    //@EnvironmentObject var userData: UserData
    @State private var showMovieAddedAlert = false
    
    // Input Parameter
    let movie: Movie
   
    var body: some View {
        // A Form cannot have more than 10 Sections.
        // Group the Sections if more than 10.
        Form {
            Group {
                Section(header: Text("MOVIE TITLE")) {
                    Text(movie.title)
                }
                Section(header: Text("MOVIE POSTER")){
                    getImageFromUrl(url: "https://image.tmdb.org/t/p/w500/\(movie.posterFileName)" , defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                        .padding()
                    
                }
                
                Section(header: Text("YOUTUBE MOVIE TRAILER")) {
                    NavigationLink(destination: WebView(url: "http://www.youtube.com/embed/\(movie.youTubeTrailerId)")
                            
                            .navigationBarTitle(Text("Play Movie Trailer"), displayMode: .inline)

                    ){
                        HStack {

                            Image(systemName: "play.rectangle.fill")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.red)

                            Text("Play YouTube Movie Trailer")
                                .font(.system(size: 16))
                               // .foregroundColor(.blue)

                        }

                        .frame(minWidth: 300, maxWidth: 500, alignment: .leading)

                    }

                }
                Section(header: Text("MOVIE OVERVIEW")) {
                    Text(movie.overview)
                }
                
                Section(header: Text("LIST MOVIE CAST MEMBERS")) {
                    
                    NavigationLink(destination: AnyView(CharacterList(movieName: movie.title, namePile: giveCharacterList()))

                    ){
                        HStack {

                            Image(systemName: "rectangle.stack.person.crop")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.blue)

                            Text("List Movie Cast Members")
                                .font(.system(size: 16))
                                //.foregroundColor(.blue)

                        }

                        .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                    }
                }
                
                
                Section(header: Text("MOVIE RUNTIME")) {
                    Text(timeFormat(time: movie.runtime))
                }
                
                Section(header: Text("MOVIE GENRES")) {
                    Text(movie.genres)
                }
                
                Section(header: Text("MOVIE RELEASE DATE")) {
                    Text(movie.releaseDate)
                }
                
                Section(header: Text("MOVIE DIRECTOR")) {
                    Text(movie.director)
                }
                
                
            }
            .font(.system(size: 14))
            .alert(isPresented: $showMovieAddedAlert, content: {self.movieAddedAlert})
            
            Group{
                Section(header: Text("Get More Info And Purchase A Ticket!")) {

                    Link(destination: URL(string: "https://www.google.com/search?q=\(formatMovieTitle())+Movie")!) {

                    HStack {

                        Image(systemName: "globe")

                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))

                        Text("Show Google Search")

                            .font(.system(size: 16))

                    }
                    .foregroundColor(.blue)

                }
                    
                    Link(destination: URL(string: "https://www.imax.com/movies/\(formatMovieTitle2())")!) {

                    HStack {

                        Image(systemName: "globe")

                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))

                        Text("Show IMAX Details (If Available)")

                            .font(.system(size: 16))

                    }
                    .foregroundColor(.blue)

                }

            }
                
                
                Section(header: Text("MOVIE TOP ACTORS")) {
                    Text(movie.actors)
                }
                
                Section(header: Text("MOVIE MPAA RATING")) {
                    Text(movie.mpaaRating)
                }
                
                Section(header: Text("MOVIE IMDB RATING")) {
                    Text(movie.imdbRating)
            }
                
                
                /*Section(header: Text("Add This National Park As A Future Trip!")) {

                        Button(action: {
                                        self.saveNewTrip()
                                        self.showCocktailAddedAlert = true
                                    }) {

                                        HStack {
                                            Image(systemName: "plus")
                                                .imageScale(.medium)
                                                .font(Font.title.weight(.regular))
                                                .foregroundColor(.blue)
                                            Text("Add To Future Expense")
                                                .font(.system(size: 16))

                                        }
                                    }
                                }*/
                
                
                
                
 
        }   // End of Form
       // .navigationBarTitle(Text(movie.title), displayMode: .inline)
          //  .font(.system(size: 14))
       
    }   // End of body
        .navigationBarTitle(Text(movie.title), displayMode: .inline)
            .font(.system(size: 14))
        .navigationBarItems(trailing:
                                NavigationLink(destination: AddMovie(movie: movie)) {
                //Image(systemName: "plus")
                 Text("SaveToExpenses")
            })
        
    
    
}

    
    
    func formatMovieTitle() -> String{
        
        let searchQuery = movie.title.replacingOccurrences(of: " ", with: "+")
        
        return searchQuery
    }
    
    func formatMovieTitle2() -> String{
        
        let searchQuery = movie.title.replacingOccurrences(of: " ", with: "-")
        
        return searchQuery
    }
    
    var movieAddedAlert: Alert {

            Alert(title: Text("Movie Added!"),

                  message: Text("This movie is added to your favorites list!"),

                  dismissButton: .default(Text("OK")) )

        }
    
    func timeFormat(time: Int) -> String {
       
        let hours = String(Int(time / 60))
        let minute = String(time % 60)
        
        return "\(hours) hours \(minute) mins"
    }
    
    func giveCharacterList() -> [String] {
        
        //let names = movie.actors
        
        //let array = names.components(separatedBy: ", ")
        
        let array = actorsInMovie[movie.title]!
        
        return array
    }
    
    func searchAndGiveCharacterList() -> [String] {
        
        obtainTmdbDataFromApi(category: "ID", query: String(movie.tmdbID))
        
        let names = movie.actors
        let array = names.components(separatedBy: ", ")
        return array
        
    }
   
 
}

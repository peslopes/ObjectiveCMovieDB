//
//  MovieDBAPI.m
//  ObjectiveCMovieDB
//
//  Created by Pedro Lopes on 18/03/20.
//  Copyright © 2020 Rafael Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieDBAPI.h"

@implementation MovieDBAPI

- (id)init {
    self.apiKey = @"ad28148852ee2cbbb8766d7babbf7c5e";
    return self;
}

- (void) getMoviesFromURL: (NSURL *) url completionHandler:(void(^)(QTMovies * _Nullable movies, NSError * _Nullable error))completionHandler {
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL: url
              completionHandler:^(NSData *data,
                                  NSURLResponse *response,
                                  NSError *error) {
        if (error == nil) {
            NSError *error;
            QTMovies *movies = [QTMovies fromData:data error:&error];
            completionHandler(movies, nil);
        } else {
            completionHandler(nil,error);
        }
                

      }] resume];
}

- (void)getNowPlayingMovies:(void (^)(QTMovies * _Nullable, NSError * _Nullable))completionHandler {
    [self getMoviesFromURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@%@", @"https://api.themoviedb.org/3/movie/now_playing?api_key=", self.apiKey, @"&language=en-US&page=1"]] completionHandler:^(QTMovies *movies, NSError *error) {
        completionHandler(movies, error);
    }];
}

//- (void) getNowPlayingMovies {

//}
- (void)getPopularMovies:(void (^)(QTMovies * _Nullable, NSError * _Nullable))completionHandler {
    [self getMoviesFromURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@%@", @"https://api.themoviedb.org/3/movie/popular?api_key=", self.apiKey, @"&language=en-US&page=1"]] completionHandler:^(QTMovies *movies, NSError *error) {
        completionHandler(movies, error);
    }];
}

@end

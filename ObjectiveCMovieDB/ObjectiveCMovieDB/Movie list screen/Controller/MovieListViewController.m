//
//  ViewController.m
//  ObjectiveCMovieDB
//
//  Created by Rafael Ferreira on 16/03/20.
//  Copyright © 2020 Rafael Ferreira. All rights reserved.
//

#import "MovieListViewController.h"
#import "MovieTableViewCell.h"
#import "MovieDetailViewController.h"
#import "MovieDBAPI.h"

@interface MovieListViewController ()

@end

@implementation MovieListViewController {
    NSArray *popularMovies;
    NSArray *nowPlayingMovies;
    BOOL requestDone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setHidden:YES];
    requestDone = NO;
    popularMovies = [NSArray array];
    nowPlayingMovies = [NSArray array];
    
    MovieDBAPI *movieDBAPI = [[MovieDBAPI alloc] init];
    [movieDBAPI getNowPlayingMovies: ^(QTMovies *movies, NSError *error){
        if (error == nil) {
            self->nowPlayingMovies = [movies results];
            for (QTResult *movie in self->nowPlayingMovies) {
                movie.coverData = [movieDBAPI getCoverFrom: movie.posterPath];
            }
            if (self->requestDone) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //Run UI Updates
                    [self.tableView setHidden:NO];
                    [self.tableView reloadData];
                });
            } else {
                self->requestDone = YES;
            }
        }
    }];
    
    [movieDBAPI getPopularMovies: ^(QTMovies *movies, NSError *error){
        if (error == nil) {
            self->popularMovies = [movies results];
            for (QTResult *movie in self->popularMovies) {
                movie.coverData = [movieDBAPI getCoverFrom: movie.posterPath];
            }
            if (self->requestDone) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //Run UI Updates
                    [self.tableView setHidden:NO];
                    [self.tableView reloadData];
                });
            } else {
                self->requestDone = YES;
            }
            
        }
    }];
    
//    QTResult *movie1 = [[QTResult alloc] init];
//    movie1.overview = @"bla bla bla";
//    movie1.voteAverage = 5.5;
//    movie1.title = @"hehe";
//
//    QTResult *movie2 = [[QTResult alloc] init];
//    movie2.overview = @"chica sjdnlsdl lkjdflkd jlkj kj lkjdlk jdlskj lksdjl kjdlk jsdlk jslkdj lksj kj lksj lksjdlks jlkdj kljdlksj dlksdlskn dln lkdsn lkndlkn slkdnslkndl kn lndnskdnslkdnlkn lksdnslkndlks nlkdnslknd lknsdlkn lkdnlksnddlksnd lkndlkn lkdnslkndlk nldknslkdn lkndlksndkl snkdnkl nsklnd lk nlkd nskldnlsk";
//    movie2.voteAverage = 8.5;
//    movie2.title = @"Chica da silva";
//
//    QTResult *movie3 = [[QTResult alloc] init];
//    movie3.overview = @"chica sjdnlsdl lkjdflkd jlkj kj lkjdlk jdlskj lksdjl kjdlk jsdlk jslkdj lks";
//    movie3.voteAverage = 8.5;
//    movie3.title = @"Chica";
//
//    QTResult *movie4 = [[QTResult alloc] init];
//    movie4.overview = @"oi cueio";
//    movie4.voteAverage = 8.5;
//    movie4.title = @"Cueio";
    
    
//    popularMovies = [NSArray arrayWithObjects: movie1, movie2, nil];
//
//    nowPlayingMovies = [NSArray arrayWithObjects: movie3, movie4, nil];
    
    //[_tableView.tableHeaderView setBackgroundColor:[UIColor clearColor]];
    
    // Do any additional setup after loading the view.
}

- (void)setupNavBar {
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.title = @"Movies";
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.navigationItem.searchController = searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    searchController.obscuresBackgroundDuringPresentation = NO;
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"movieCell";
    
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (cell == nil) {
        return [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
        reuseIdentifier: cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        [cell configure: [popularMovies objectAtIndex: [indexPath row]]];
    } else {
        [cell configure: [nowPlayingMovies objectAtIndex: [indexPath row]]];
    }
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [popularMovies count];
    } else {
        return [nowPlayingMovies count];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // Background color
    view.tintColor = [UIColor whiteColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Popular Movies";
    } else {
        return @"Now Playing Movies";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _rowSelected = [indexPath row];
    _sectionSelected = [indexPath section];
    [self performSegueWithIdentifier: @"movieDetailsSegue" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //colocar aqui os dados a serem passados adiante
    UINavigationController *nav = [segue destinationViewController];
    MovieDetailViewController *detailsViewController = nav.topViewController;
    if (_sectionSelected == 0) {
        detailsViewController.receivedMovie = [popularMovies objectAtIndex: _rowSelected];
    } else {
        detailsViewController.receivedMovie = [nowPlayingMovies objectAtIndex: _rowSelected];
    }
}

@end

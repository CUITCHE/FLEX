//
//  FLEXAppLogViewController.m
//  FLEX
//
//  Created by He,Junqiu on 2018/8/10.
//  Copyright © 2018年 Flipboard. All rights reserved.
//

#import "FLEXAppLogViewController.h"
#import "FLEXAppLogSearchView.h"

static NSFileHandle *pipeOutHandle = nil;
static NSFileHandle *pipeErrHandle = nil;
static NSMutableData *logs = nil;

__attribute__((constructor)) static void foo() {
//    int std_out = dup(STDOUT_FILENO);
//    int std_err = dup(STDERR_FILENO);

    stdout->_flags = 10;
    NSPipe *out_pipe = [NSPipe pipe];
    pipeOutHandle = out_pipe.fileHandleForReading;
    dup2(out_pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO);

    stderr->_flags = 10;
    NSPipe *err_pipe = [NSPipe pipe];
    pipeErrHandle = err_pipe.fileHandleForReading;
    dup2(err_pipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO);

    logs = [NSMutableData data];
}

@interface FLEXAppLogViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) FLEXAppLogSearchView *searchBar;
@property (nonatomic, strong) NSArray<NSValue *> *searchRanges;
@property (nonatomic, strong) NSString *text;

@end

@implementation FLEXAppLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"App Log";

    self.textView.text = [[NSString alloc] initWithData:logs encoding:NSUTF8StringEncoding];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" ⬇︎ " style:UIBarButtonItemStylePlain target:self action:@selector(scrollToLastRow)];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(redirectOutNotificationHandle:) name:NSFileHandleReadCompletionNotification object:pipeOutHandle];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(redirectOutNotificationHandle:) name:NSFileHandleReadCompletionNotification object:pipeErrHandle];
    [pipeOutHandle readInBackgroundAndNotify];
    [pipeErrHandle readInBackgroundAndNotify];
}

-(void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)initViews {
//    _searchBar = ({
//        FLEXAppLogSearchView *searchBar = [[FLEXAppLogSearchView alloc] init];
//        searchBar.searchBar.delegate = self;
//        searchBar.translatesAutoresizingMaskIntoConstraints = NO;
//        searchBar.searchBar.placeholder = @"Search Logs";
//
//        [self.view addSubview:searchBar];
//
//        UIView *view = searchBar;
//        [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
//        [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:48].active = YES;
//        if (@available(iOS 11, *)) {
//            [view.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0].active = YES;
//        } else {
//            [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0].active = YES;
//        }
//        searchBar;
//    });

    _textView = ({
        UITextView *view = [[UITextView alloc] init];
//        view.backgroundColor = [UIColor blackColor];
//        view.textColor = [UIColor whiteColor];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.editable = NO;
        [self.view addSubview:view];
        [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
        if (@available(iOS 11, *)) {
            [view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0].active = YES;
        } else {
            [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0].active = YES;
        }
        view;
    });
}

- (void)redirectOutNotificationHandle:(NSNotification *)notification {
    NSData *data = [notification.userInfo objectForKey:NSFileHandleNotificationDataItem];
    @synchronized(logs) {
        [logs appendData:data];
        _text = [[NSString alloc] initWithData:logs encoding:NSUTF8StringEncoding];
        [[notification object] readInBackgroundAndNotify];
    }
    if ([NSThread isMainThread]) {
        [self updateContent];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self updateContent];
        });
    }
}

- (void)updateContent {
    _textView.text = _text;
    [self scrollToLastRow];
}

- (void)scrollToLastRow
{
   [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length, 1)];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSAssert([NSThread isMainThread], @"Must be main thread");
    if (searchText.length == 0) {
        _searchRanges = nil;
        return;
    }
    NSMutableArray<NSValue *> *array = [NSMutableArray array];
}

@end

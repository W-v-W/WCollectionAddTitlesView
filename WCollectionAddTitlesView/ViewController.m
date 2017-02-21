//
//  ViewController.m
//  WCollectionAddTitlesView
//
//  Created by Zhibo Wang on 2017/2/7.
//
//

#import "ViewController.h"
#import "WInteractCV.h"
#import "WTitleScrollView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    WInteractCV *cv = [[WInteractCV alloc]initWithFrame:CGRectMake(0, 104, w_screen_width, w_screen_height - 20 - 40)];
    WTitleScrollView *titleView = [[WTitleScrollView alloc]initWithFrame:CGRectMake(0, 64, w_screen_width, 40) titles:@[@{@"name":@"Business"},@{@"name":@"Technology"},@{@"name":@"Science"},@{@"name":@"Health"},@{@"name":@"Sports"},@{@"name":@"Entertainment"}]];
    
//    titleView.titleFont = [UIFont systemFontOfSize:30];
//    titleView.highlightColor = [UIColor blackColor];
//    titleView.normalColor = [UIColor lightGrayColor];
//    [titleView setMarginsLeft:20 center:20 right:20];
    
    cv.combinedTitleView = titleView;
    
    __weak typeof(cv)weakCV = cv;
    cv.shouldAddContentBlock = ^(NSUInteger index){
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, 300, 50)];
        content.font = [UIFont systemFontOfSize:50];
        content.text = @(index).stringValue;
        [weakCV addContent:content toIndex:index];
    };
    cv.turnedPageBlock = ^(NSUInteger index){
        NSLog(@"Turned page: %@", @(index));
    };
    
    [self.view addSubview:titleView];
    [self.view addSubview:cv];
    
}



@end

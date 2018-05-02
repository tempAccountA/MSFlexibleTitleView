//
//  ViewController.m
//  FlexibleTitleViewDEMO
//
//  Created by JZJ on 2016/9/22.
//  Copyright © 2016年 JZJ. All rights reserved.
//

#import "ViewController.h"
#import "MSFlexibleTitleView.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) MSFlexibleTitleView  *titleView;
@property (nonatomic, strong) UIScrollView         *containerView;
@property (nonatomic, strong) NSArray              *titles;
@property (nonatomic, assign) NSInteger             currentIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.titleView;
    [self.view addSubview:self.containerView];
}


- (void)didTapViewIndex:(NSInteger)index {
    if(index<0)return;
    
    CGPoint point = CGPointMake([UIScreen mainScreen].bounds.size.width*index, self.containerView.contentOffset.y);
    [self.containerView setContentOffset:point animated:YES];
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSUInteger page = (NSUInteger) (floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);

    if (page != self.currentIndex) {
        self.titleView.scrollBlock(self.currentIndex, page, 0, YES);
        [self setNewCurrentIndex:page];
    }
    CGFloat f = scrollView.contentOffset.x / pageWidth;
    CGFloat scale = fabs(1 - (f - (NSInteger)f) * 2);
    NSInteger nextPage = self.currentIndex;
    if (scrollView.contentOffset.x > self.currentIndex*pageWidth) {
        nextPage = self.currentIndex + 1;
    }
    else if (scrollView.contentOffset.x < self.currentIndex*pageWidth) {
        nextPage = self.currentIndex - 1;
    }
    self.titleView.scrollBlock(self.currentIndex, nextPage, scale, NO);
}



- (void)setNewCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex == currentIndex) return;
        _currentIndex = currentIndex;
}



#pragma mark -- lazy

- (NSArray *)titles{
    if(!_titles){
        _titles = @[@"One" ,@"Two", @"Three"];
    }
    return _titles;
}

- (UIScrollView *)containerView{
    if(!_containerView){
        _containerView = [UIScrollView new];
        _containerView.delegate = self;
        _containerView.showsVerticalScrollIndicator = NO;
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.pagingEnabled = YES;
        UIScreen* screen = [UIScreen mainScreen];
        _containerView.contentSize = CGSizeMake(screen.bounds.size.width*self.titleView.tapTitles.count, screen.bounds.size.height);
        _containerView.frame = self.view.bounds;
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}


- (MSFlexibleTitleView *)titleView {
    if (!_titleView) {
        __weak typeof(self)weakSelf = self;
        _titleView = [[MSFlexibleTitleView alloc] initWithTitles:self.titles showIndex:MSTitleTypeMoment tapBlock:^(MSFlexibleTitleView *titleView, NSInteger index) {
            [weakSelf didTapViewIndex:index];
        }];
    }
    return _titleView;
}


@end

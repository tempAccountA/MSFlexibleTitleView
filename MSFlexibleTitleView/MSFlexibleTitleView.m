//
//  MSFlexibleTitleView.m
//
//
//  Created by JZJ on 16/5/20.
//  Copyright © 2016年 JZJ. All rights reserved.
//

#import "MSFlexibleTitleView.h"

#if !__has_feature(objc_arc)
#error MSFlexibleTitleView must be built with ARC.
#endif

static NSInteger const kTagForRedMark  =  666;
@interface MSFlexibleTitleView ()
@property (nonatomic, strong) NSMutableArray  *taps;
@property (nonatomic, strong) UIView          *bottomLine;
@property (nonatomic, strong) UILabel         *currentLabel;
@property (nonatomic, strong) NSArray         *tapTitles;
@property (nonatomic, strong) MSTitleTapBlock  tapBlock;

@end

@implementation MSFlexibleTitleView

- (id)initWithTitles:(NSArray*)tapTitles showIndex:(NSInteger)index tapBlock:(MSTitleTapBlock)block{
    
    return [self initWithTitles:tapTitles viewWidth:175. showIndex:index tapBlock:block];
}

- (id)initWithTitles:(NSArray*)tapTitles viewWidth:(CGFloat)viewWidth showIndex:(NSInteger)index tapBlock:(MSTitleTapBlock)block {
    self.tapTitles = tapTitles;
    CGFloat width = (viewWidth > 0) ? viewWidth : 175.;
    CGRect frame = CGRectMake(0, 0, width, 44.);
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tapBlock = block;
        [self setBackgroundColor:[UIColor clearColor]];
        if (tapTitles && tapTitles.count) {
            CGFloat width = self.frame.size.width/tapTitles.count;
            for (int i = 0; i < tapTitles.count; i++) {
                UILabel *tapLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*i, 0, width, self.frame.size.height)];
                tapLabel.userInteractionEnabled = YES;
                tapLabel.backgroundColor = [UIColor clearColor];
                tapLabel.textAlignment = NSTextAlignmentCenter;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
                [tapLabel addGestureRecognizer:tap];
                tapLabel.tag = i;
                if (index==i) {
                    tapLabel.font = [UIFont boldSystemFontOfSize:15.0];
                    [tapLabel setTextColor:[UIColor colorWithRed:52/255.0 green:98/255.0 blue:255/255.0 alpha:1]];
                    self.currentLabel = tapLabel;
                } else {
                    tapLabel.font = [UIFont systemFontOfSize:15.0];
                    [tapLabel setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
                }
                [tapLabel setText:[tapTitles objectAtIndex:i]];
                [self addSubview:tapLabel];
                [self.taps addObject:tapLabel];
            }
        }
        [self bottomLine].center = CGPointMake(self.currentLabel.center.x, self.bottomLine.center.y);
    }
    return self;
}


-(void)setRedMarkAtIndex:(NSInteger)i {
    UILabel *label = [self viewWithTag:i];
    
    UIImageView *redMark = [label viewWithTag:kTagForRedMark];
    if (redMark) {
        return;
    } else {
        redMark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"redDot.png"]];
        redMark.tag = kTagForRedMark;
        
        CGRect frame = redMark.frame;
        frame.origin.x = 50 - frame.size.width;
        redMark.frame = frame;
        
        frame = redMark.frame;
        frame.origin.y = 10;
        redMark.frame = frame;
        [label addSubview:redMark];
    }
}

-(void)cleanRedMark{
    UIImageView *redMark = [self viewWithTag:kTagForRedMark];
    [redMark removeFromSuperview];
}

- (void)didTap:(UITapGestureRecognizer *)recognizer{
    UILabel *tapLabel = (UILabel *)recognizer.view;
    
    if (tapLabel == self.currentLabel) {
        return;
    }
    if (self.tapBlock) {
        self.tapBlock(self, tapLabel.tag);
    }
}

- (HandleHorizontalScrollBlock)scrollBlock {
    
    if (!_scrollBlock) {
        __weak typeof(self)weakSelf = self;
        _scrollBlock = ^ (NSInteger index, NSInteger toIndex, CGFloat scale, BOOL end) {
            if ((index == toIndex && !end) || toIndex < 0 || toIndex >= weakSelf.taps.count) {
                return ;
            }
            
            UILabel *currentLabel = [weakSelf.taps objectAtIndex:index];
            if (end) {
                currentLabel = [weakSelf.taps objectAtIndex:toIndex];
                [weakSelf.taps enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx == toIndex) {
                        weakSelf.currentLabel = obj;
                        weakSelf.currentLabel.font = [UIFont boldSystemFontOfSize:15.0];
                        weakSelf.currentLabel.textColor = [UIColor colorWithRed:52/255.0 green:98/255.0 blue:255/255.0 alpha:1];
                    } else {
                        obj.font = [UIFont systemFontOfSize:15.0];
                        obj.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
                    }
                }];
                CGRect frame = weakSelf.bottomLine.frame;
                frame.size.width = 40.;
                weakSelf.bottomLine.frame = frame;
                weakSelf.bottomLine.center = CGPointMake(CGRectGetMidX(currentLabel.frame), self.frame.size.height-2./2);
            } else {
                currentLabel.textColor = [weakSelf normalColorWith:1-scale];
                CGFloat offset = 40.*0.75;
                CGPoint point = CGPointZero;
                if (toIndex > index) {
                    point = CGPointMake(CGRectGetMidX(currentLabel.frame)+offset*(1-scale), self.frame.size.height-2./2);
                } else {
                    point = CGPointMake(CGRectGetMidX(currentLabel.frame)-offset*(1-scale), self.frame.size.height-2./2);
                }
                CGFloat width = 40. + offset * (1-scale);
                CGRect frame = weakSelf.bottomLine.frame;
                frame.size.width = width;
                weakSelf.bottomLine.frame = frame;
                
                weakSelf.bottomLine.center = point;
            }
        };
    }
    return _scrollBlock;
}

- (UIColor *)normalColorWith:(CGFloat)scale {
    
    NSDictionary *nDic = [self getRGBDictionaryByColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    NSDictionary *sDic = [self getRGBDictionaryByColor:[UIColor colorWithRed:52/255.0 green:98/255.0 blue:255/255.0 alpha:1]];
    CGFloat _r = [[sDic objectForKey:@"R"] floatValue] - [[nDic objectForKey:@"R"] floatValue];
    CGFloat _g = [[sDic objectForKey:@"G"] floatValue] - [[nDic objectForKey:@"G"] floatValue];
    CGFloat _b = [[sDic objectForKey:@"B"] floatValue] - [[nDic objectForKey:@"B"] floatValue];
    return [UIColor colorWithRed:([[sDic objectForKey:@"R"] floatValue]-scale*_r)*255/255.0
                           green:([[sDic objectForKey:@"G"] floatValue]-scale*_g)*255/255.0
                           blue:([[sDic objectForKey:@"B"] floatValue]-scale*_b)*255/255.0
                           alpha:1];
}

- (UIColor *)selectedColorWith:(CGFloat)scale {
    
    NSDictionary *nDic = [self getRGBDictionaryByColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
    NSDictionary *sDic = [self getRGBDictionaryByColor:[UIColor colorWithRed:52/255.0 green:98/255.0 blue:255/255.0 alpha:1]];
    CGFloat _r = [[sDic objectForKey:@"R"] floatValue] - [[nDic objectForKey:@"R"] floatValue];
    CGFloat _g = [[sDic objectForKey:@"G"] floatValue] - [[nDic objectForKey:@"G"] floatValue];
    CGFloat _b = [[sDic objectForKey:@"B"] floatValue] - [[nDic objectForKey:@"B"] floatValue];
  
    return [UIColor colorWithRed:([[nDic objectForKey:@"R"] floatValue]+scale*_r)*255
                    green:([[nDic objectForKey:@"G"] floatValue]+scale*_g)*255
                    blue:([[nDic objectForKey:@"B"] floatValue]+scale*_b)*255
                    alpha:1];
}

- (NSDictionary *)getRGBDictionaryByColor:(UIColor *)originColor{
    
    CGFloat r=0,g=0,b=0,a=0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [originColor getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    return @{@"R":@(r),@"G":@(g),@"B":@(b),@"A":@(a)};
}


#pragma mark --lazy

-(NSMutableArray *)taps{
    if(!_taps){
        _taps = [NSMutableArray array];
    }
    return _taps;
}


- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2., 40., 2.)];
        _bottomLine.backgroundColor = [UIColor colorWithRed:52/255.0 green:98/255.0 blue:255/255.0 alpha:1];
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}


@end



//
//  MSFlexibleTitleView.h
//  
//
//  Created by JZJ on 16/5/20.
//  Copyright © 2016年 JZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MSTitleType){
    MSTitleTypeNone = -1,
    MSTitleTypeMoment,
    MSTitleTypeUsers,
    MSTitleTypeActivity
};

@class MSFlexibleTitleView;
typedef void (^MSTitleTapBlock)   (MSFlexibleTitleView *titleView, NSInteger index);
typedef void (^HandleHorizontalScrollBlock) (NSInteger index, NSInteger toIndex, CGFloat scale, BOOL end);

@interface MSFlexibleTitleView : UIView
@property (nonatomic, strong,readonly)NSArray          *tapTitles;
@property (nonatomic, copy) HandleHorizontalScrollBlock scrollBlock;

- (id)initWithTitles:(NSArray*)tapTitles showIndex:(NSInteger)index tapBlock:(MSTitleTapBlock)block;
- (id)initWithTitles:(NSArray*)tapTitles viewWidth:(CGFloat)viewWidth showIndex:(NSInteger)index tapBlock:(MSTitleTapBlock)block;

//设置红点
-(void)setRedMarkAtIndex:(NSInteger)i;
-(void)cleanRedMark;

@end

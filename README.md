
# MSFlexibleTitleView

[![platform](http://img.shields.io/cocoapods/p/YYKit.svg?style=flat)](https://www.apple.com/nl/ios/)
[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat)](https://github.com/JZJJZJ/MSFlexibleTitleView/blob/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/AFNetworking.svg)](https://github.com/JZJJZJ/MSFlexibleTitleView.git)
[![GitHub stars](https://img.shields.io/github/stars/badges/shields.svg?style=social&logo=github&label=Stars)](https://github.com/JZJJZJ/MSFlexibleTitleView.git)

flexibleAnimationTitleView

## Installation

### Cocoapods(Recommended)

1. Add `pod 'MSFlexibleTitleView'` to your Podfile.
2. Run `pod install`

### Manual

1. Add all files under `MSFlexibleTitleView ` to your project

## Requirements

- iOS 5.0 and greater
- ARC/MRC


## How To Use

### Objective-C

```objc

#import "MSFlexibleTitleView.h”
```


```objc

MSFlexibleTitleView* titleView = [[MSFlexibleTitleView alloc] initWithTitles:@[@"One" ,@"Two", @"Three"]
                                                                   showIndex:MSTitleTypeMoment
                                                                    tapBlock:^(MSFlexibleTitleView *titleView,NSInteger index{

}];

titleView.scrollBlock(NSInteger index, NSInteger toIndex, CGFloat scale, BOOL end);//selecteAnNewItem
```  

## License  

MSFlexibleTitleView is available under the MIT license. See the LICENSE file for more info.

//
//  TrollScrollPickerView.h
//  TestDemo
//
//  Created by cxy on 15/6/9.
//  Copyright (c) 2015年 nandu. All rights reserved.
//




/*
 
 横向滚动栏目
 
 */


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SectionTitleFontState) {
    KSectionTitleFontStateNormal = 0,
    KSectionTitleFontStateSelected = 1
};

@interface TrollScrollPickerView : UIScrollView

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign, readonly) NSUInteger selectedIndex;
@property (nonatomic, strong, readonly) NSString *selectedSectionTitle;
@property (nonatomic, strong) UIColor *sectionSelectedBGColor;

/*
    设置栏目Ttitle
*/
- (void)SetSections:(NSArray *)sections;
/*
    重置内容后，需要调用此方法刷新
 */
- (void)ReloadData;
/*
    设置不同状态下的字体
 */
- (void)SetSectionTitleFont:(UIFont *)font forState:(SectionTitleFontState)state;
/*
    设置不同状态下的字体颜色
 */
- (void)SetSectionTitleColor:(UIColor *)color forState:(SectionTitleFontState)state;
/*
    添加点击响应事件
 */
- (void)SectionAddTarget:(id)target forSelector:(SEL)selector;
/*
    设定被选中的栏目
 */
- (void)SetSectionSelectedAtIndex:(NSInteger)index;

@end

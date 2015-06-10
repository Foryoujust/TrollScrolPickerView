//
//  TrollScrollPickerView.m
//  TestDemo
//
//  Created by cxy on 15/6/9.
//  Copyright (c) 2015年 nandu. All rights reserved.
//

#import "TrollScrollPickerView.h"

static CGFloat const Height = 45;
static CGFloat const Blank = 8;
static CGFloat const BGViewBlank = 5;
static CGFloat const LAndRBlank = 5;

@interface TrollScrollPickerView()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *itemLabels;
@property (nonatomic, assign) NSUInteger lastSelectedIndex;
@property (nonatomic, assign, readwrite) NSUInteger selectedIndex;
@property (nonatomic, strong, readwrite) NSString *selectedSectionTitle;
@property (nonatomic, strong) UIView *selectedIndicatedView;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) UIView *selectedBGView;

@end

@implementation TrollScrollPickerView

- (instancetype)init{
    CGRect frame = CGRectMake(CGRectGetMinX(CGRectZero), CGRectGetMinY(CGRectZero), CGRectGetWidth([[UIScreen mainScreen] bounds]), Height);
    
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, Height);
        self.frame = frame;
        _normalFont = [UIFont systemFontOfSize:13];
        _selectedFont = [UIFont systemFontOfSize:16];
        _normalColor = [UIColor grayColor];
        _selectedColor = [UIColor colorWithRed:0 green:158./255. blue:183./255. alpha:1];
        _sectionSelectedBGColor = [UIColor lightGrayColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    
    return self;
}

#pragma  mark - Instance Method

- (void)SetSections:(NSArray *)sections{
    
    if(!sections){
        return;
    }
    
    if(!_items){
        _items = [NSArray array];
    }
    
    _items = sections;
}

- (void)ReloadData{
    [self CreateItems:_items];
}

- (void)SetSectionTitleColor:(UIColor *)color forState:(SectionTitleFontState)state{
    switch (state) {
        case KSectionTitleFontStateNormal:
            _normalColor = color;
            break;
        case KSectionTitleFontStateSelected:
            _selectedColor = color;
            break;
        default:
            break;
    }
}

- (void)SetSectionTitleFont:(UIFont *)font forState:(SectionTitleFontState)state{
    switch (state) {
        case KSectionTitleFontStateSelected:
            _selectedFont = font;
            break;
        case KSectionTitleFontStateNormal:
            _normalFont = font;
            break;
        default:
            break;
    }
}

- (void)SectionAddTarget:(id)target forSelector:(SEL)selector{
    _target = target;
    _selector = selector;
}

- (void)SetSectionSelectedAtIndex:(NSInteger)index{
    if(index < _itemLabels.count){
        UILabel *label = _itemLabels[index];
        [self selectLabel:label];
    }
}

#pragma mark - Private Method
//创建Sections
- (void)CreateItems:(NSArray *)items{
    if(!items){
        return;
    }
    
    if(_itemLabels == nil){
        _itemLabels = [NSMutableArray array];
    }
    
    [_itemLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_itemLabels removeAllObjects];
    
    NSAssert(_itemWidth > 0, @"TrollScrollPickerView:the itemWidth must be more than zero");
    
    //创建背景View
    if(_selectedBGView == nil){
        _selectedBGView = [[UIView alloc] initWithFrame:CGRectMake(LAndRBlank, BGViewBlank, _itemWidth, Height-2*BGViewBlank)];
        _selectedBGView.backgroundColor = _sectionSelectedBGColor;
        _selectedBGView.layer.cornerRadius = 10.0f;
        _selectedBGView.hidden = YES;
        [self addSubview:_selectedBGView];
    }

    //创建Sections
    for(NSInteger i=0; i<items.count; i++){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LAndRBlank+_itemWidth*i, Blank, _itemWidth, Height-2*Blank)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = _normalColor;
        label.font = _normalFont;
        label.text = items[i];
        label.userInteractionEnabled = YES;
        label.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLableSection:)];
        tap.numberOfTapsRequired = 1;
        [label addGestureRecognizer:tap];
        [self addSubview:label];
        [_itemLabels addObject:label];
    }
    
    if(items.count*_itemWidth+LAndRBlank*2 > self.frame.size.width){
        self.contentSize = CGSizeMake(items.count*_itemWidth+LAndRBlank*2, self.frame.size.height);
    }
}

//Section 点击事件
- (void)tapOnLableSection:(UITapGestureRecognizer *)tap{
    
    UILabel *label = (UILabel *)tap.view;
    
    if(_target && _selector){
        [_target performSelector:_selector withObject:label];
    }
    
    [self selectLabel:label];
}

- (void)selectLabel:(UILabel *)label{
    _selectedIndex = [_itemLabels indexOfObject:label];
    
    if(_selectedIndex == _lastSelectedIndex){
        [self ChangeFontAndColorWithSelectedLabel:label];
        if(_selectedBGView.hidden){
            _selectedBGView.hidden = NO;
        }
    }else{
        if(_selectedBGView.hidden){
            [self ChangeFontAndColorWithSelectedLabel:label];
            _selectedBGView.frame = CGRectMake(_selectedIndex*_itemWidth, BGViewBlank, _itemWidth, Height-2*BGViewBlank);
            _selectedBGView.hidden = NO;
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                _selectedBGView.frame = CGRectMake(label.frame.origin.x, BGViewBlank, label.frame.size.width, Height-2*BGViewBlank);
            } completion:^(BOOL finished){
                [self ChangeFontAndColorWithSelectedLabel:label];
            }];
        }
    }
}

- (void)ChangeFontAndColorWithSelectedLabel:(UILabel *)label{
    UILabel *lasetSelectedLabel = [_itemLabels objectAtIndex:_lastSelectedIndex];
    lasetSelectedLabel.textColor = _normalColor;
    lasetSelectedLabel.font = _normalFont;
    
    label.textColor = _selectedColor;
    label.font = _selectedFont;
    _lastSelectedIndex = _selectedIndex;
}

@end

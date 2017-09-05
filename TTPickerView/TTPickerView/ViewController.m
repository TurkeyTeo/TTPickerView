//
//  ViewController.m
//  TTPickerView
//
//  Created by Thinkive on 2017/9/5.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerV;
@property (weak, nonatomic) IBOutlet UILabel *label;

//Extension
//数组用于保存三个Component的数据
@property (nonatomic,strong) NSArray *provinceArray;//省份
@property (nonatomic,strong) NSArray *cityArray;    //城市
@property (nonatomic,strong) NSArray *townArray;    //县镇

//用于记录当前PickerView选中的row
@property (assign) NSInteger provinceIndex;
@property (assign) NSInteger cityIndex;
@property (assign) NSInteger townIndex;


@end

@implementation ViewController

/**
1）当第一列省份滑动时，需要获取与省份对应的城市数组，而provinceIndex随滑动改变，我们可以根据provinceIndex来获取对应的cityArray，即self.cityArray[_provinceIndex] 。

2）当第二列城市滑动时，需要获取对应的城镇数组。同上，我们利用provinceIndex和cityIndex获取当前城市对应的城镇数组。计算可以分两步：
 （1）计算当前省份前的省份中城市的数量。
 （2）加上当前省份中，城市的序号。
**/



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pickerV.delegate = self;
    self.pickerV.dataSource = self;
    
    
    _provinceIndex = 0;
    _cityIndex = 0;
    _townIndex = 0;
    
    _provinceArray = @[@"湖南",@"湖北",@"广东",@"江西"];
    _cityArray = @[@[@"长沙",@"株洲",@"湘潭"],@[@"武汉",@"宜昌",@"黄冈"],@[@"广州",@"深圳",@"珠海"],@[@"赣州",@"吉安"]];
    _townArray = @[@[@"雨花区",@"芙蓉区",@"天心区"],
                   @[@"攸县",@"醴陵",@"茶陵"],
                   @[@"湘乡",@"韶山"],
                   @[@"汉阳",@"武昌"],
                   @[@"宜宾",@"三峡"],
                   @[@"黄冈中学",@"黄冈小学",@"黄冈幼儿园"],
                   @[@"广州1",@"广州2",@"广州3"],
                   @[@"深圳1",@"深圳2",@"深圳3"],
                   @[@"珠海1",@"珠海2",@"珠海3"],
                   @[@"赣州1",@"赣州2",@"赣州3"],
                   @[@"吉安1",@"吉安2",@"吉安3"]];
    
    
}

#pragma mark - pickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceArray.count;
        
    } else if (component == 1) {
        NSArray *currentCities = _cityArray[_provinceIndex];
        return currentCities.count;
        
    } else {
        NSInteger currentTownIndex = 0;
        
        //获取前面省份的城市数量
        for (int i=0; i<_provinceIndex; i++) {
            NSArray *arr = _cityArray[i];
            currentTownIndex += arr.count;
        }
        
        //加上当前省份城市序号
        currentTownIndex += _cityIndex;
        
        NSArray *currentTowns = _townArray[currentTownIndex];
        return currentTowns.count;
    }
}


#pragma mark - pickerViewDataSorce

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceArray[row];
        
    } else if (component == 1) {
        NSArray *currentCities = _cityArray[_provinceIndex];
        return currentCities[row];
    } else {
        NSInteger currentTownIndex = 0;
        
        //获取前面省份的城市数量
        for (int i=0; i<_provinceIndex; i++) {
            NSArray *arr = _cityArray[i];
            currentTownIndex += arr.count;
        }
        
        //加上当前省份城市序号
        currentTownIndex += _cityIndex;
        
        NSArray *currentTowns = _townArray[currentTownIndex];
        return currentTowns[row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //第一级选中变动，我们需要更新后面两列的内容
        _provinceIndex = row; //更新省份序号
        
        _cityIndex = 0; //重设为0，否则当前城市序号在其他省份可能溢出
        _townIndex = 0; //同上
        
        [pickerView reloadComponent:1];//刷新城市列表
        [pickerView reloadComponent:2];
        
    } else if (component == 1) {
        //第二级选中变动，需要更新后面一列内容
        _cityIndex = row;
        
        _townIndex = 0;
        [pickerView reloadComponent:2];
    } else {
        //最后一列，不需要更新列表
        _townIndex = row;
    }
    
    
    NSString *provienceStr = _provinceArray[_provinceIndex];
    
    NSArray *currentCities = _cityArray[_provinceIndex];
    NSString * cityStr = currentCities[_cityIndex];
    
    NSInteger currentTownIndex = 0;
    for (int i=0; i<_provinceIndex; i++) {
        NSArray *arr = _cityArray[i];
        currentTownIndex += arr.count;
    }
    currentTownIndex += _cityIndex;
    
    NSArray *currentTowns = _townArray[currentTownIndex];
    NSString *townStr = currentTowns[_townIndex];
    
    _label.text = [NSString stringWithFormat:@"%@-%@-%@",provienceStr,cityStr,townStr];
    
}


//更改字体颜色，或者将每个选择项设置为自定义view。
- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *titleStr = nil;
    if (component == 0) {
        titleStr = _provinceArray[row];
        
    } else if (component == 1) {
        NSArray *currentCities = _cityArray[_provinceIndex];
        titleStr = currentCities[row];
    } else {
        NSInteger currentTownIndex = 0;
        
        //获取前面省份的城市数量
        for (int i=0; i<_provinceIndex; i++) {
            NSArray *arr = _cityArray[i];
            currentTownIndex += arr.count;
        }
        
        //加上当前省份城市序号
        currentTownIndex += _cityIndex;
        
        NSArray *currentTowns = _townArray[currentTownIndex];
        titleStr = currentTowns[row];
    }
    NSAttributedString *title = [[NSAttributedString alloc]initWithString:titleStr attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return title;
}





@end

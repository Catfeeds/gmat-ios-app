//
//  HTSchoolRoomDetailController.m
//  GMat
//
//  Created by Charles Cao on 2017/11/20.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import "HTSchoolRoomDetailController.h"
#import "HTSchoolRoomDetailCell.h"
#import "NSString+HTString.h"
#import "THShareView.h"

@interface HTSchoolRoomDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation HTSchoolRoomDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.detailModel.contenttitle;
	self.array = [NSMutableArray array];
	self.detailTable.rowHeight = self.view.frame.size.height;
	self.detailTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.detailTable.frame.size.height, 10)];
	[self  loadData];
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"]  style:UIBarButtonItemStylePlain target:self action:@selector(share)];
	self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)share{
	NSString *url = [NSString stringWithFormat:@"http://www.gmatonline.cn/learn/%@-0.html",self.detailModel.contentid];
	[THShareView showTitle:self.detailModel.contenttitle detail:self.detailModel.contenttitle image:@"http://www.smartapply.cn/cn/images/index_kevinIcon.png" url:url type:SSDKContentTypeWebPage];
}

- (void)loadData{
	HTNetworkModel *networkModel = [HTNetworkModel modelForOnlyCacheNoInterfaceForScrollViewWithCacheStyle:HTCacheStyleAllUser];
	
	[HTRequestManager requestKnowledgeDetailWithNetworkModel:networkModel knowledgeContentId:self.detailModel.contentid complete:^(id response, HTError *errorModel) {
		
		if (errorModel.existError) {
			return;
		}
		NSAttributedString *attributeString = [self attributeStringByHtmlString:[response[@"data"][@"contenttext"] ht_htmlDecodeString]];
		self.array = [self pagingwithContentString:attributeString contentSize:CGSizeMake(HTSCREENWIDTH - 50, self.view.frame.size.height - 45)];
		[self.detailTable reloadData];
		
	}];
}

#pragma mark - HTML -> NSAttributedString

- (NSAttributedString *)attributeStringByHtmlString:(NSString *)htmlString {

	NSString *str = [self replaceImageUrl:htmlString];
	
	NSData *htmlData = [str dataUsingEncoding:NSUnicodeStringEncoding];
	NSDictionary *importParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
								   NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]
								   };
	NSError *error = nil;
	NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithData:htmlData options:importParams documentAttributes:NULL error:&error];
	[attributeString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributeString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value) {
            NSTextAttachment *textAttachment = value;
            CGSize size = textAttachment.bounds.size;
            if (size.width > HTSCREENWIDTH - 30) {
                textAttachment.bounds = CGRectMake(0, 0, HTSCREENWIDTH - 50, size.height / size.width * HTSCREENWIDTH - 50);
            }
        }
	}];
	return attributeString;
}

//移除最后 <p><br/></p>
- (NSString *)removeSuffix:(NSString *)str{
    NSString *suffix = @"<p><br/></p>";
    if ([str hasSuffix:suffix]) {
       return  [str stringByReplacingCharactersInRange:NSMakeRange(str.length - suffix.length, suffix.length) withString:@""];
    }
    return str;
}

//替换完整图片地址
- (NSString *)replaceImageUrl:(NSString *)str {
	NSString *returnStr = [self removeSuffix:str];
	NSString *regexString = @"<img.*src=\".*?\"";
	NSRegularExpression *reqular = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionDotMatchesLineSeparators error:nil];
	NSArray *resultArray  = [reqular matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
	if (resultArray && resultArray.count > 0) {
		for (NSTextCheckingResult *result in resultArray) {
			  NSRange range = result.range;
			NSString *subStr = [str substringWithRange:range];
			if (!([subStr containsString:@"http"] || [subStr containsString:@"data:image"])) {
				NSRange srcRange = [subStr rangeOfString:@"src=\""];
				NSMutableString *tempStr =  [[NSMutableString alloc]initWithString:subStr];
				[tempStr insertString:DomainGmatResourceNormal atIndex:NSMaxRange(srcRange)];
			   returnStr = [str stringByReplacingOccurrencesOfString:subStr withString:tempStr];
			}
		}
	}
	return returnStr;
}

#pragma mark - --分页
- (NSMutableArray *)pagingwithContentString:(NSAttributedString *)string contentSize:(CGSize)contentSize  {
	NSMutableArray *textViewArray = [NSMutableArray array];
	
	NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:string];
	NSLayoutManager* layoutManager = [[NSLayoutManager alloc] init];
    
	[textStorage addLayoutManager:layoutManager];
	
	 NSRange range = NSMakeRange(0, 0);
	while (NSMaxRange(range) < layoutManager.numberOfGlyphs) {
		NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:contentSize];
		[layoutManager addTextContainer:textContainer];
		range = [layoutManager glyphRangeForTextContainer:textContainer];
		UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, contentSize.width,contentSize.height) textContainer:textContainer];
        textView.contentSize = contentSize;
        textView.editable = NO;
        textView.scrollEnabled = NO;
        textView.tag = 100;
		[textViewArray addObject:textView];
	}
	return textViewArray;
}

#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	HTSchoolRoomDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTSchoolRoomDetailCell"];
    UIView *view = [cell.content viewWithTag:100];
    if (view) [view removeFromSuperview];
    [cell.content addSubview:self.array[indexPath.section]];
    cell.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.section+1,self.array.count];
    
	return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

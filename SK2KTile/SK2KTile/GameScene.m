//
//  GameScene.m
//  SK2KTile
//
//  Created by Mo DeJong on 4/23/16.
//  Copyright (c) 2016 HelpURock. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

// This method constructs a background node at the exact size of the view.
// Due to view loading issues, this method should not be invoked until
// the scene is actually placed into a window or once resized after having
// been displayed.

// http://www.spritekitlessons.com/tile-a-background-image-with-sprite-kit/

- (void) makeBackgroundNode
{
  // Use new size of SKScene
  
  CGSize sceneSize = self.size;
  
  NSLog(@"makeBackgroundNode at size %d x %d", (int)sceneSize.width, (int)sceneSize.height);

  [self.background removeFromParent];
  self.background = nil; // dealloc memory
  
  SKSpriteNode *background = [self.class generateCGTiledImageNode:sceneSize];
  
  self.background = background;
  
  background.anchorPoint = CGPointMake(0.0,0.0);
  background.position = CGPointZero;
  
  NSLog(@"background.position : %d %d", (int)background.position.x, (int)background.position.y);
  
  NSLog(@"background.size : %d %d", (int)background.size.width, (int)background.size.height);
  
  background.zPosition = 0;
  
  [self addChild:background];
}

-(void)didMoveToView:(SKView *)view {
  self.scene.backgroundColor = [UIColor redColor];
  
  [self makeBackgroundNode];
  
  return;
}

- (void)didChangeSize:(CGSize)oldSize
{
  NSLog(@"SKScene.didChangeSize old size %d x %d", (int)oldSize.width, (int)(int)oldSize.height);
  
  if (self.background) {
    // Resize after initial invocation of didMoveToView
    
    [self makeBackgroundNode];
  }
}

// About 20 megs of memory  on Device

+ (SKSpriteNode*) generateCGTiledImageNode:(CGSize)backgroundSizePoints
{
  NSString *textureFilename = @"tile.png";
  
  UIImage *uiImg = [UIImage imageNamed:textureFilename];
  assert(uiImg);
  CGImageRef tileImgRef = uiImg.CGImage;
  
  // Dimensions of tile image
  
  CGRect textureRect = CGRectMake(0, 0, CGImageGetWidth(tileImgRef), CGImageGetHeight(tileImgRef)); // tile texture dimensions

  // Generate tile that exactly covers the whole screen

  float screenScale = [UIScreen mainScreen].scale;
  
  CGSize coverageSizePixels = CGSizeMake(backgroundSizePoints.width * screenScale, backgroundSizePoints.height * screenScale);
  
  CGSize coverageSizePoints = CGSizeMake(coverageSizePixels.width / screenScale, coverageSizePixels.height / screenScale);
  
  UIGraphicsBeginImageContextWithOptions(coverageSizePixels, TRUE, 1.0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextDrawTiledImage(context, textureRect, tileImgRef);
  UIImage *tiledBackground = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  // Create a CoreGraphics image the size of the entire tiled region
  
  SKTexture *backgroundTexture = [SKTexture textureWithCGImage:tiledBackground.CGImage];
  
  SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
  
  // Define node size in points, exact pixels are 2x this size
  
  node.size = coverageSizePoints;
  
  return node;
}

@end

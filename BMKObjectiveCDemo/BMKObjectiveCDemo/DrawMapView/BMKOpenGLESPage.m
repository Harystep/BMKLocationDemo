//
//  BMKOpenGLESPage.m
//  BMKObjectiveCDemo
//
//  Created by Baidu RD on 2018/3/11.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKOpenGLESPage.h"
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#define MAX_SIZE 1024

char vertexSource[] =
"precision mediump float;\n"
"attribute vec4 aPosition;\n"
"void main() {\n"
"    gl_Position = aPosition;\n"
"}\n";

char fragmentSource[] =
"precision mediump float;\n"
"void main() {\n"
"    gl_FragColor = vec4(1.0, 0.0, 0.0, 0.5);\n"
"}\n";

typedef struct {
    GLfloat x;
    GLfloat y;
} GLPoint; 
//开发者通过此delegate获取mapView的回调方法
@interface BMKOpenGLESPage ()<BMKMapViewDelegate>
{
    BMKMapPoint mapPoints[4];
    GLPoint glPoint[4];
    GLuint _program;
    GLuint _vertexLocation;
    GLuint _indicesLocation;
    GLuint _colorLocation;
    GLint _locationPosition;
    
    float _vertext[24];
    short _indecies[36];
    float _color[32];
    GLuint _program3D;
    GLuint _vertexLocation3D;
    GLuint _indicesLocation3D;
    GLuint _colorLocation3D;
    GLuint _viewMatrixLocation3D;
    GLuint _projectionMatrixLocation3D;
    GLint _locationPosition3D;
}
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, assign) BOOL mapDidFinishLoad; //地图是否加载完成
@property (nonatomic, assign) BOOL glshaderLoaded;
@end

@implementation BMKOpenGLESPage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self createMapView];
}

- (void)viewWillAppear:(BOOL)animated {
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"OpenGL ES绘制";
}

- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    _mapView.showMapScaleBar = YES;
}

#pragma mark - OpenGL ES

- (void)glRender {
    //绘制一个矩形
    [self drawFrameForRectangle];
    //绘制一个正方体
    [self drawFrameFor3DCube];
}

- (void)drawFrameForRectangle {
    /**
     将经纬度坐标转换为投影后的直角地理坐标
     
     @param coordinate 待转换的经纬度坐标
     @return 转换后的直角地理坐标
     */
    mapPoints[0] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.965, 116.604));
    mapPoints[1] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.865, 116.604));
    mapPoints[2] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.865, 116.704));
    mapPoints[3] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.965, 116.704));
    if (_glshaderLoaded == NO) {
        _glshaderLoaded = [self loadShaders:vertexSource fragmentSource:fragmentSource program:&_program];
    }
    BMKMapRect mapRect = _mapView.visibleMapRect;
    for (NSUInteger i = 0; i < 4; i ++) {
        CGPoint tempPt = [_mapView glPointForMapPoint:mapPoints[i]];
        glPoint[i].x = tempPt.x * 2 / mapRect.size.width;
        glPoint[i].y = tempPt.y * 2 / mapRect.size.height;
    }
    
    glUseProgram(_program);
    glEnableVertexAttribArray(_locationPosition);
    glVertexAttribPointer(_locationPosition, 2, GL_FLOAT, 0, 0, glPoint);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(_locationPosition);
}

-(void)drawFrameFor3DCube {
    if (_program3D == 0) {
        [self init3DShader];
        [self init3DVertext];
    }
    
    GLboolean depthMask = 0;
    glGetBooleanv(GL_DEPTH_WRITEMASK,&depthMask);
    
    glUseProgram(_program3D);
    
    glEnable(GL_DEPTH_TEST);
    if (depthMask == GL_FALSE) {
        glDepthMask(GL_TRUE);
    }
    
    glEnableVertexAttribArray(_vertexLocation3D);
    glVertexAttribPointer(_vertexLocation3D, 3, GL_FLOAT, false, 0, _vertext);
    
    glEnableVertexAttribArray(_colorLocation3D);
    glVertexAttribPointer(_colorLocation3D, 4, GL_FLOAT, false, 0, _color);
    
    BMKMapPoint center = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.965, 116.404));
    CGPoint offsetPoint = [self.mapView glPointForMapPoint:center];
    
    float *viewMatrix = [self.mapView getViewMatrix];
    translateM(viewMatrix, 0, offsetPoint.x, offsetPoint.y, 0);
    
    float *projectionMatrix = [self.mapView getProjectionMatrix];
    //传值函数，该函数的第一个参数是该变量在shader中的位置，第二个参数是被赋值的矩阵的数目。第三个参数表明在向uniform变量赋值时该矩阵是否需要转置
    //vec4类型的变量赋值，我们可以使用glUniform4f或者glUniform4fv。v代表数组
    glUniformMatrix4fv(_viewMatrixLocation3D, 1, false, viewMatrix);
    glUniformMatrix4fv(_projectionMatrixLocation3D, 1, false, projectionMatrix);
    
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_SHORT, _indecies);
    
    glDisableVertexAttribArray(_vertexLocation3D);
    glDisableVertexAttribArray(_colorLocation3D);
    glDisable(GL_DEPTH_TEST);
    glDepthMask(depthMask);
}

- (void)init3DShader
{
    //顶点着色器
    NSString *vertexShader = @"precision highp float;\n\
    attribute vec3 aVertex;\n\
    attribute vec4 aColor;\n\
    uniform mat4 aViewMatrix;\n\
    uniform mat4 aProjectionMatrix;\n\
    uniform mat4 aTransformMatrix;\n\
    uniform mat4 aScaleMatrix;\n\
    varying vec4 color;\n\
    void main(){\n\
    gl_Position = aProjectionMatrix * aViewMatrix * vec4(aVertex, 1.0);\n\
    color = aColor;\n\
    }";
    //片段着色器
    NSString *fragmentShader = @"\n\
    precision highp float;\n\
    varying vec4 color;\n\
    void main(){\n\
    gl_FragColor = color;\n\
    }";
    // program对象是可以附加着色器对象的对象
    // 创建一个空program并返回一个可以被引用的非零值（program ID）
    _program3D = glCreateProgram();
    GLuint vShader = glCreateShader(GL_VERTEX_SHADER);
    GLuint fShader = glCreateShader(GL_FRAGMENT_SHADER);
    GLint vlength = (GLint)[vertexShader length];
    GLint flength = (GLint)[fragmentShader length];
    
    const GLchar *vByte = [vertexShader UTF8String];
    const GLchar *fByte = [fragmentShader UTF8String];
    
    glShaderSource(vShader, 1, &vByte, &vlength);
    glShaderSource(fShader, 1, &fByte, &flength);
    //成功编译着色器对象
    glCompileShader(vShader);
    glCompileShader(fShader);
    //成功地将着色器对象附加到program 对象
    glAttachShader(_program3D, vShader);
    glAttachShader(_program3D, fShader);
    //成功的链接program 对象之后
    glLinkProgram(_program3D);
    
    //查询由program指定的先前链接的程序对象
    _vertexLocation3D  = glGetAttribLocation(_program3D, "aVertex");
    //表示程序对象中特定统一变量的位置
    _viewMatrixLocation3D = glGetUniformLocation(_program3D,"aViewMatrix");
    //得到名字为“aProjectionMatrix”在shader中的位置
    _projectionMatrixLocation3D = glGetUniformLocation(_program3D,"aProjectionMatrix");
    _colorLocation3D = glGetAttribLocation(_program3D,"aColor");
    
}

- (void)init3DVertext
{
    //创建vertex
    float vertext[] = {
        0.0, 0.0, 0.0,
        1.0, 0.0, 0.0,
        1.0, 1.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0,
        1.0, 0.0, 1.0,
        1.0, 1.0, 1.0,
        0.0, 1.0, 1.0,
    };
    
    for (int i = 0; i < 24; i++) {
         // 对标墨卡托坐标
        _vertext[i] = vertext[i] * 10000;
    }

    short indices[] = {
        0, 4, 5,
        0, 5, 1,
        1, 5, 6,
        1, 6, 2,
        2, 6, 7,
        2, 7, 3,
        3, 7, 4,
        3, 4, 0,
        4, 7, 6,
        4, 6, 5,
        3, 0, 1,
        3, 1, 2,
    };
    
    for (int i = 0; i < 36; i++) {
        _indecies[i] = indices[i];
    }
    
    float colors[] = {
        1.0f, 0.0f, 0.0f, 1.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 1.0f,
        1.0f, 1.0f, 0.0f, 1.0f,
        0.0f, 1.0f, 1.0f, 1.0f,
        1.0f, 0.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 1.0f, 1.0f,
    };
    
    for (int i = 0; i < 32; i++) {
        _color[i] = colors[i];
    }
}

void translateM(float* m, int mOffset,float x, float y, float z) {
    for (int i=0 ; i<4 ; i++) {
        int mi = mOffset + i;
        m[12 + mi] += m[mi] * x + m[4 + mi] * y + m[8 + mi] * z;
    }
}

void scaleM(float* m, int mOffset,float x, float y, float z) {
    for (int i=0 ; i<4 ; i++) {
        int mi = mOffset + i;
        m[     mi] *= x;
        m[ 4 + mi] *= y;
        m[ 8 + mi] *= z;
    }
}

- (BOOL)loadShaders:(char *)vertexSource fragmentSource:(char *)fragmentSource program:(GLuint *)program{
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    if (!program) {
        return NO;
    }
    if (!(vertexShader && fragmentShader)) {
        NSLog(@"Create Shader failed");
        return NO;
    }
    if (![self compileShader:vertexSource shader:vertexShader] || ![self compileShader:fragmentSource shader:fragmentShader]) {
        return NO;
    }
    *program = glCreateProgram();
    if (!(*program)) {
        NSLog(@"Create program failed");
        return NO;
    }
    glAttachShader(*program, vertexShader);
    glAttachShader(*program, fragmentShader);
    glLinkProgram(*program);
    GLint linked = 0;
    glGetProgramiv(*program, GL_LINK_STATUS, &linked);
    _locationPosition = glGetAttribLocation(_program, "aPosition");
    
    if(!linked) {
        NSLog(@"Link program failed");
        return NO;
    }
    return YES;
}

-(BOOL)compileShader:(char *)shaderSource shader:(GLuint)shader
{
    glShaderSource(shader, 1, (const char**)&shaderSource, NULL);
    glCompileShader(shader);
    GLint compiled = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if(!compiled) {
        int length = MAX_SIZE;
        char log[MAX_SIZE] = {0};
        glGetShaderInfoLog(shader, length, &length, log);
        NSLog(@"Shader compile failed");
        NSLog(@"log: %@", [NSString stringWithUTF8String:log]);
        return NO;
    }
    return YES;
}

#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    _mapDidFinishLoad = YES;
    [self glRender];
}

/**
 地图渲染每一帧画面过程中，以及每次需要重新绘制地图时(例如添加覆盖物)都会调用此方法
 
 @param mapView 地图View
 @param status 地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    if (_mapDidFinishLoad) {
        [self glRender];
    }
}

#pragma mark - Lazy loading
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue)];
//        _mapView.zoomLevel = 18;
    }
    return _mapView;
}

@end

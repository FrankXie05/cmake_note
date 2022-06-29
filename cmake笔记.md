# CMake

# 说明

cmake的定义是什么 ？-----高级编译配置工具

当多个人用不同的语言或者编译器开发一个项目，最终要输出一个可执行文件或者共享库（dll，so等等）

所有操作都是通过编译CMakeLists.txt来完成的—简单

# CMake一个HelloWord

1、步骤一，写一个HelloWord

```cpp
#main.cpp

#include <iostream>

int main(){
std::cout <<  "hello word" << std::endl;
}
```

2、步骤二，写CMakeLists.txt

```cpp
#CMakeLists.txt

cmake_minimum_required(VERSION 3.0)

project(Hello)

add_executable(Hello main.cpp)
```

3、步骤三、使用cmake，生成makefile文件

```
目录下就生成了这些文件-CMakeFiles, CMakeCache.txt, cmake_install.cmake 等文件，并且生成了Makefile.
最关键的是，它自动生成了Makefile.

```

4、使用make命令编译

```
Scanning dependencies of target cmake
[ 50%] Building CXX object CMakeFiles/cmake.dir/main.cpp.o
[100%] Linking CXX executable cmake
[100%] Built target cmake

```

5、最终生成了Hello的可执行程序

## PROJECT关键字

可以用来指定工程的名字和支持的语言，默认支持所有语言

PROJECT (HELLO)   指定了工程的名字，并且支持所有语言—建议

PROJECT (HELLO CXX)      指定了工程的名字，并且支持语言是C++

PROJECT (HELLO C CXX)      指定了工程的名字，并且支持语言是C和C++

## SET关键字

用来显示的指定变量的

SET(SRC_LIST main.cpp)    SRC_LIST变量就包含了main.cpp

也可以 SET(SRC_LIST main.cpp t1.cpp t2.cpp)

## MESSAGE关键字

向终端输出用户自定义的信息

主要包含三种信息：

- SEND_ERROR，产生错误，生成过程被跳过。
- SATUS，输出前缀为—的信息。
- FATAL_ERROR，立即终止所有 cmake 过程.

## ADD_EXECUTABLE关键字

生成可执行文件

ADD_EXECUTABLE(hello ${SRC_LIST})    
生成的可执行文件名是hello，源文件读取变量SRC_LIST中的内容

也可以直接写 ADD_EXECUTABLE(hello main.cpp)


注意：工程名的 HELLO 和生成的可执行文件 hello 是没有任何关系的(工程名字可以自定义的)

# 语法

- 变量使用${}方式取值
- 指令(参数 1 参数 2...) 参数使用括弧括起，参数之间使用空格或分号分开。 以上面的 ADD_EXECUTABLE 指令为例，如果存在另外一个 func.cpp 源文件
    
    就要写成：ADD_EXECUTABLE(hello main.cpp func.cpp)
    一个可执行文件或者共享库可以是由多个文件生成的
- 指令是大小写无关的，参数和变量是大小写相关的。尽量使用大写的.

- SET(SRC_LIST main.cpp) 可以写成 SET(SRC_LIST “main.cpp”)，如果源文件名中含有空格，就必须要加双引号
- ADD_EXECUTABLE(hello main) 后缀一定需要，他会自动去找.c和.cpp，如果有两个文件main.cpp和main，那样会出错.

# 内部构建和外部构建

- 上述例子就是内部构建，他生产的临时文件特别多，不方便清理
- 外部构建，就会把生成的临时文件放在build目录下，不会对源文件有任何影响强烈使用外部构建方式


1、建立一个build目录，可以在任何地方，建议在当前目录下

2、进入build，运行cmake ..    当然..表示上一级目录，你可以写CMakeLists.txt所在的绝对路径，生产的文件都在build目录下了

3、在build目录下，运行make来构建工程

注意外部构建的两个变量

1、HELLO_SOURCE_DIR  还是工程路径

2、HELLO_BINARY_DIR   编译路径 : /cmake/bulid

# 完善工程

- 为工程添加一个子目录 src，用来放置工程源代码
- 添加一个子目录 doc，用来放置这个工程的文档 hello.txt
- 在工程目录添加文本文件 COPYRIGHT, README
- 将构建后的目标文件放入构建目录的 bin 子目录
- 将 doc 目录 的内容以及 COPYRIGHT/README 安装到 share/doc/cmake/

## 将目标文件放入构建目录的 bin 子目录

每个目录下都要有一个CMakeLists.txt说明

```

├── build
├── CMakeLists.txt
└── src
    ├── CMakeLists.txt
    └── main.cpp
```

外层CMakeLists.txt

```cpp
PROJECT(HELLO)
ADD_SUBDIRECTORY(src bin)
```

src下的CMakeLists.txt

```cpp
ADD_EXECUTABLE(hello main.cpp)
```

### ADD_SUBDIRECTORY 指令

ADD_SUBDIRECTORY(source_dir [binary_dir] [EXCLUDE_FROM_ALL])

- 这个指令用于将子目录添加到文件中，binary_dir指定放置输出文件的目录
- EXCLUDE_FROM_ALL函数是将写的目录从编译中排除.(如果子目录中构建的目标为example或者test)
- ADD_SUBDIRECTORY(src bin)
    
    将 src 子目录加入工程并指定编译输出(包含编译中间结果)路径为bin 目录
    
    如果不进行 bin 目录的指定，那么编译结果(包括中间结果)都将存放在build/src 目录
    

### 更改的binary_dir保存路径

SET 指令重新定义 EXECUTABLE_OUTPUT_PATH 和 LIBRARY_OUTPUT_PATH 变量 来指定最终的目标二进制的位置

SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)

## 如何安装HelloWord

CMAKE提供一个指令：INSTALL

INSTALL的安装可以包括：二进制、动态库、静态库以及文件、目录、脚本等

使用CMAKE的一个变量：CMAKE_INSTALL_PREFIX

```
// 目录树结构
.
├── build
├── CMakeLists.txt
├── COPYRIGHT
├── doc
│   └── hello.txt
├── README
├── runhello.sh
└── src
    ├── CMakeLists.txt
    └── main.cpp

```

### 安装文件COPYRIGHT和README

INSTALL(FILES COPYRIGHT README DESTINATION share/doc/cmake/)

FILES：文件名称

DESTINATION：

	1、写绝对路径

	2、可以写相对路径

### 安装 doc 中的 hello.txt

- 一、是通过在 doc 目录建立CMakeLists.txt ，通过install下的file
- 二、是直接在工程目录通过
    
     INSTALL(DIRECTORY doc/ DESTINATION share/doc/cmake)
    

DIRECTORY 后面连接的是所在 Source 目录的相对路径

# 静态库和动态库的构建


１，建立一个静态库和动态库，提供 HelloFunc 函数供其他程序编程使用，HelloFunc 向终端输出 Hello World 字符串。 

２，安装头文件与共享库。

静态库和动态库的区别

- 静态库的扩展名一般为“.a”或“.lib”；动态库的扩展名一般为“.so”或“.dll”。
- 静态库在编译时会直接整合到目标程序中，编译成功的可执行文件可独立运行 (*静态编译)
- 动态库在编译时不会放到连接的目标程序中，即可执行文件无法单独运行。 （*动态编译）

## 构建实例
in file

### ADD_LIBRARY

ADD_LIBRARY(hello SHARED ${LIBHELLO_SRC})

- hello：库名，生成的名字前面会加上lib，最终产生的文件是libhello.so
- SHARED，动态库    STATIC，静态库
- ${LIBHELLO_SRC} ：源文件

### 同时构建静态和动态库

```cpp
// 同时构建的时候，名字不可以相同，下面只会构建出动态库 ***？
ADD_LIBRARY(hello SHARED ${LIBHELLO_SRC})
ADD_LIBRARY(hello STATIC ${LIBHELLO_SRC})

// 正确方式，尽量保证名称一致，后缀为所需要库的名称 
ADD_LIBRARY(hello SHARED ${LIBHELLO_SRC})
ADD_LIBRARY(hello_static STATIC ${LIBHELLO_SRC})
```

### SET_TARGET_PROPERTIES
```
set_target_properties(target1 target2 ...
                      PROPERTIES prop1 value1
                      prop2 value2 ...)
```

设置目标的属性。该命令的语法是列出您要更改的所有目标，然后提供接下来要设置的值

同时构建静态和动态库

```cpp
SET(LIBHELLO_SRC hello.cpp)

ADD_LIBRARY(hello_static STATIC ${LIBHELLO_SRC})

//对hello_static的重名为hello
SET_TARGET_PROPERTIES(hello_static PROPERTIES  OUTPUT_NAME "hello")

```

### 动态库的版本号 ***？

一般动态库都有一个版本号的关联

指定动态库的版本号
`SET_TARGET_PROPERTIES(hello PROPERTIES VERSION 1.2 SOVERSION 1)`

VERSION 指代动态库版本，SOVERSION 指代 API 版本。


### 使用外部共享库和头文件
include<hello/hello.h>

### TARGET_INCLUDE_DIRECTORIES
```
target_include_directories(<target> [SYSTEM] [AFTER|BEFORE]
  <INTERFACE|PUBLIC|PRIVATE> [items1...]
  [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])
  
```
    这条指令可以用来向工程添加多个特定的头文件搜索路径，

	可以某个工程解决找不到头文件的问题


### TARGET_LINK_LIBRARIES
url: https://cmake.org/cmake/help/latest/command/target_link_libraries.html

	指定链接给定目标和/或其依赖项时要使用的库或标志
	
	可以解决使用目标库是无法找到库中的一些函数定义.
	eg：undefined reference to `HelloFunc()'

链接静态库

`TARGET_LINK_LIBRARIES(main libhello.a)`

## 名称定义

### 动态链接库

	DLL  动态链接库文件，是一种不可执行的二进制程序文件，它允许程序共享执行特殊任务所必需的代码和其他资源. 
	也就是说在应用程序启动的时候才会链接，用于动态编译。
	
### 静态编译  

	在编译器编译可执行文件时，将可执行文件需要调用的对应动态链接库中的部分提取出来，链接到可执行文件中.
	
### 动态编译: 

	动态编译的​ ​可执行文件​​需要附带一个的​动态链接库, 在编译器编译可执行文件时，调用其对应动态链接库中的命令.

### 组态档
	
	组态档，或者叫 configuration file,配置文件,组态档是用一种建构软件专用的特殊编程语言写的 CMake 脚本。
	使用组态档能改变程序的设置，而不用重新编译程序。

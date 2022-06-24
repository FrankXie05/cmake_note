cmake_minimum_required(VERSION 3.8)

project(tset)

set(CMAKE_CXX_STANDARD 11)

add_executable(test main.cpp "utils.h")

#[[
	https://cmake.org/cmake/help/latest/command/get_filename_component.html
	1.
	get_filename_component(<var> <FileName> <mode> [CACHE])
		<var>: 保存获取的变量
		<FileName>: 完整的文件名
		<mode>:
			DIRECTORY = Directory without file name : 文件所在路径
			NAME      = File name without directory ： 没有目录的文件名
			EXT       = File name longest extension (.b.c from d/a.b.c) ：最长的扩展名
			NAME_WE   = File name with neither the directory nor the longest extension ：没有目录和扩展名的文件名
			LAST_EXT  = File name last extension (.c from d/a.b.c)：最后一个扩展名
			NAME_WLE  = File name with neither the directory nor the last extension：没有目录和最后一个扩展名的文件名
			PATH      = Legacy alias for DIRECTORY (use for CMake <= 2.8.11)：等同于 DIRECTORY
		[CACHE]: 是否放到缓存当中

	2. get_filename_component(<var> <FileName> <mode> [BASE_DIR <dir>] [CACHE])
		<var>: 保存获取的变量
		<FileName>: 完整的文件名
		<mode>: 
			ABSOLUTE  = Full path to file : 文件的绝对路径
			REALPATH  = Full path to existing file with symlinks resolved：如果文件为符号链接文件，取得实际的文件绝对路径，否则与ABSOLUTE一样
		[BASE_DIR <dir>]: 如果指定路径，则获取到的绝对路径为：指定路径+文件名；未指定的话，则指定路径为{CMAKE_CURRENT_SOURCE_DIR}
		[CACHE]: 获取的变量放到缓存中

	3. get_filename_component(<var> <FileName> PROGRAM [PROGRAM_ARGS <arg_var>] [CACHE])
		<var>:...
		<FileName>:文件名.如果不是完整的文件名会在系统的PATH中进行查找
		[PROGRAM_ARGS <arg_var>]: 将FileName字符串分为程序名和参数，参数存放在<arg_var>当中
		[CACHE]:...

]]

#用例

#设置一个完整的文案名，并加入两个扩展名

set(FullFileName "C:/Users/v-frankxie/Desktop/study/cmake/CMakeLists.txt.sh") #文件加入扩展名后实际不存在
message("原始输出: ${FullFileName}")

#用法1.

#获取文件所在的目录
get_filename_component(directory ${FullFileName} DIRECTORY)
message("文件路径: ${directory}")

#获取没有目录的文件名
get_filename_component(name ${FullFileName} NAME)
message("文件名： ${name}")

#获取最长的扩展名
get_filename_component(ext ${FullFileName} EXT)
message("最长的扩展名： ${ext}")

#获取没有目录和扩展名的文件名
get_filename_component(name_we ${FullFileName} NAME_WE)
message("没有目录和扩展名的文件名: ${name_we}")

#获取最后一个扩展名
get_filename_component(last_ext ${FullFileName} LAST_EXT)
message("最后一个扩展名: ${last_ext}")

#获取没有目录和最后一个扩展名的文件名
get_filename_component(name_wle ${FullFileName} NAME_WLE)
message("没有目录和最后一个扩展名的文件名: ${name_wle}")

#用法2

#获取文件的绝对路径
get_filename_component(absolute_full_path "CMakeLists.txt" ABSOLUTE)

#1)输出的默认路径为${CMAKE_CURRENT_SOURCE_CIR}
message("CMAKE_CURRENT_SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")
message("默认绝对路径： ${absolute_full_path}")
#2)给定自定义的目录获取绝对路径
get_filename_component(absolute_full_path_define "CMakeLists.txt" ABSOLUTE BASE_DIR "/base_dir")  #文件不存在也不影响
message("自定义路径： ${absolute_full_path_define}")

#用法3

#1)获取符号链接文件的实际文件路径

get_filename_component(real_full_path "./link/CMakeLists.txt.link" REALPATH) #文件不存在也不影响
message("real_full_path = ${real_full_path}")

#2)创建一个符号链接文件： CMakeLists.txt.lin
#文件存在的话，路径一致
get_filename_component(real_full_path "CMakeLists.txt.link" REALPATH) 
message("real_full_path = ${real_full_path}")

get_filename_component(absolute_full_path "CMakeLists.txt.link" ABSOLUTE )
message(absolute_full_path = ${absolute_full_path})

#用法4
#获取程序文件的路径
get_filename_component(program_full_path "CMakeLists.txt arg1 arg2" PROGRAM PROGRAM_ARGS programe_args)
#下面两个为空的原因时因为：会从系统的环境变量PATH中寻找程序，找不到为空值.
message("program_full_path = ${program_full_path}")
message("programe_args = ${programe_args}")

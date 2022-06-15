# CMakeList.txt : CMake project for 123456, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.8)

# Add source to this project's executable.
add_executable (123456 "123456.cpp" "123456.h")

if (CMAKE_VERSION VERSION_GREATER 3.12)
  set_property(TARGET 123456 PROPERTY CXX_STANDARD 20)
endif()

# TODO: Add tests and install targets if needed.


#[[ 一般使用cmake_parse_arguments()用来处理给定的宏和函数的参数，并定义一组变量来保存相应选项的值。
1. cmake_parse_arguments(<prefix> <options> <one_value_keywords>
	   				     <multi_value_keywords> <args>...)

	第一种参数是 <options> 表示可选关键词列表，如果传入参数包含此变量名，则为 TRUE，反之为 FALSE。
	第二种参数是 <one_value_keywords> 表示单值关键词列表，每个关键词仅对应一个值。
	第三种参数是 <multi_value_keywords> 表示多值关键词列表，每个关键词可对应多个值。
	<args>为要解析的参数，一般传入${ARGS} -> <options>,<one_value_keywords>,<multi_value_keywords>来解析
	<prefix>: 解析出来的新变量根据<prefix>修改

2. cmake_parse_arguments(PARSE_ARGV <N> <prefix> <options>
					     <one_value_keywords> <multi_value_keywords>)
	PARSE_ARGV 仅用于函数。cmake_parse_arguments首先会解析从函数调用的ARGVn.从<N>开始解析

]]
#[[
3. excutable_process
	execute_process(COMMAND <cmd1> [<arguments>]
					[COMMAND <cmd2> [<arguments>]#]...
					[WORKING_DIRECTORY <directory>]
					[TIMEOUT <seconds>]
					[RESULT_VARIABLE <variable>]
					[RESULTS_VARIABLE <variable>]
					[OUTPUT_VARIABLE <variable>]
					[ERROR_VARIABLE <variable>]
					[INPUT_FILE <file>]
					[OUTPUT_FILE <file>]
					[ERROR_FILE <file>]
					[OUTPUT_QUIET]
					[ERROR_QUIET]
					[COMMAND_ECHO <where>]
					[OUTPUT_STRIP_TRAILING_WHITESPACE]
					[ERROR_STRIP_TRAILING_WHITESPACE]
					[ENCODING <name>]
					[ECHO_OUTPUT_VARIABLE]
					[ECHO_ERROR_VARIABLE]
					[COMMAND_ERROR_IS_FATAL <ANY|LAST>])	 
    :执行命令
]]



#实现一个功能：(第一种)
#[[
 my_stall(TARGETS <targets>... #：多值
	[LIBRARY|RUNTIME|OBJECTS] #可选
    [CONFIGURATIONS [Debug|Release]...] #多值
	DESTINATION <dir>  #单值
	[COMPONENT <component>] #单值
	[RENAME <name>] #单值
	[OPTIONAL] #可选
 )
]]

macro(my_install)
	set(options LIBRARY RUNTIME OBJECTS OPTIONAL)
	set(one_value_keywords DESTINATION COMPONENT RENAME)
	set(multi_value_keywords TARGETS CONFIGURATIONS)
	cmake_parse_arguments(MY_INSTALL "${options}" "${one_value_keywords}" "${multi_value_keywords}" ${ARGN})
	# 多值关键字
	message("MY_STALL_TARGETS: ${MY_INSTALL_TARGETS}")
	# 可选关键字
	message("MY_STALL_LIBRARY: ${MY_INSTALL_LIBRARY}")
	message("MY_STALL_RUNTIME: ${MY_INSTALL_RUNTIME}")
	message("MY_STALL_OBJECTS: ${MY_INSTALL_OBJECTS}")

	message("MY_STALL_OPTION: ${MY_INSTALL_OPTION}")
	# 单值关键字
	message("MY_STALL_DESTINATION: ${MY_INSTALL_DESTINATION}")
	message("MY_STALLOMPONENT: ${MY_INSTALL_COMPONENT}")
	message("MY_STALL_RENAME: ${MY_INSTALL_RENAME}")

	# 特殊变量
	# 未解析的参数 <prefix>_UNPARSED_ARGUMENTS: 表示为解析的参数
	message("MY_INSTALL_UNPARSED_ARGUMENTS: ${MY_INSTALL_UNPARSED_ARGUMENTS}")
	# 关键字缺失值的参数 <prefix>_KEYWORDS_MISSING_VALUES: 仅传入关键字，并未传入值
	message("MY_STALL_KEYWORDS_MISSING_VALUES: ${MY_STALL_KEYWORDS_MISSING_VALUES}")
endmacro()

#my_install(TARGETS foo bar LIBRARY CONFIGURATIONS DESTINATION bin OPYION blub)


# 2.
#[[
	实现：
	my_add_executabnle(<name> [WIN32] [MACOSX_BUNDLE]
		[EXCLUDE_FROM_ALL]
		[source1][source2...]
	)

]]

function(my_add_executabnle name)
	set(options WIN32 MACOSX_BUNDLE EXCLUDE_FROM_ALL)
	set(one_value_keywords)
	set(multi_value_keywords)
	cmake_parse_arguments(PARSE_ARGV 1 MY "${options}" "${one_value_keywords}" "${multi_value_keywords}")

	message("name: ${name}")
	message("MY_WIN32: ${MY_WIN32}")
	message("MY_MACOSX_BUNDLE: ${MY_MACOSX_BUNDLE}")
	message("MY_EXCLUDE_FROM_ALL: ${MY_EXCLUDE_FROM_ALL}")
	
	# 为解析参数
	message("MY_UNPARSED_ARGUMENTS: ${MY_UNPARSED_ARGUMENTS}")
	
	# 关键字缺失值的参数
	message("MY_KEYWORDS_MISSING_VALUES: ${MY_KEYWORDS_MISSING_VALUES}")
endfunction()

my_add_executabnle(myexe WIN32 main1.c main2.c main3.c)

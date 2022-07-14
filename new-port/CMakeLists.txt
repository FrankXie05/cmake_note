# CMakeList.txt : CMake project for timercpp, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.8)
#[[
	1.版本指定分为6中情况： 当前版本 3.12
		1. cmake_minimum_required(VERSION 2.8.0) < 当前版本 -> 结果：成功
		2. cmake_minimum_required(VERSION 3.4.0) > 当前版本 -> 结果： 失败 CMake Error at CMakeLists.txt:1 (cmake_minimum_required):
																		CMake 3.4.0 or higher is required.  You are running version 3.12.0

		3. cmake_minimum_required(VERSION 2.8.0...3.1.0) ： max < 当前版本 -> 结果：成功
		4. cmake_minimum_required(VERSION 3.10.0...3.4.0) : min < 当前版本 < max ->成功
		5. cmake_minimum_required(VERSION 3.2.0...3.4.0) ：min > 当前版本 -> 成功
		6. cmake_minimum_required(VERSION 3.4.0...3.10.2): min > max -> 结果： CMake Error at CMakeLists.txt:1 (cmake_minimum_required):
																		Policy VERSION range "3.4.0...3.10.2" specifies a larger minimum than
	2.[FATAL_ERROR]: 2.6版本以上接受但忽略该选项，2.4版本及以下应该指定，避免出现警告而不是错误
]]
project(timercpp)
#[[
	project(<PROJECT-NAME> [<language-name>...])
	project(<PROJECT-NAME>
#			[VERSION <major>[.<minor>[.<patch>[.<tweak>]]
#			[DESCRIPTION <project-description-string>]
#			[HOMEPAGE_URL <url-string>]
#			[LANGUAGES <language-name>...])

set(PUBLIC_HEADERS 
    ${CMAKE_SOURCE_DIR}/timercpp.h)

set(timercpp_SOURCES 
    ${CMAKE_SOURCE_DIR}/sample.cpp)

#option
option(BUILD_SHARED_LIBS "Build dll")
option(BUILD_STATIC_LIBS "Build lib")

#LIB
if(BUILD_STATIC_LIBS)
    set(TARGET_NAME timercpp_lib)
	add_library(timercpp_lib ${timercpp_SOURCES} STATIC ${PUBLIC_HEADERS})
	install(
		TARGETS timercpp_lib
		EXPORT unoffical-timercppConfig
		RUNTIME DESTINATION bin
		ARCHIVE DESTINATION lib
		LIBRARY DESTINATION lib
	)
endif()

#DLL
if(BUILD_SHARED_LIBS)
    set(TARGET_NAME timercpp_dll)
	add_library(timercpp_dll ${timercpp_SOURCES} ${PUBLIC_HEADERS})
	install(                                 #安装库文件或者可执行文件
		TARGETS timercpp_dll                  
		EXPORT unoffical-timercppConfig
		RUNTIME DESTINATION bin              #包含exe和dll(on windows)
		ARCHIVE DESTINATION lib              #包含lib
		LIBRARY DESTINATION lib              #包含DLLS和FRAMWORK(on macOS)
		#默认相对路径为 CMAKE_INSTALL_PREFIX(VS默认设置了为{CURRENT_PACKAGES_DIR}或者{CURRENT_PACKAGES_DIR}/debug)
	)
endif()

# TODO: Add tests and install targets if needed.

if (CMAKE_VERSION VERSION_GREATER 3.12)
  set_property(TARGET ${TARGET_NAME} PROPERTY CXX_STANDARD 20)
endif()

#Export cmake usage 

target_include_directories(${TARGET_NAME}
	PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> $<INSTALL_INTERFACE:include>)

install(
	EXPORT unoffical-timercppConfig DESTINATION share/timercpp)

install(FILES ${PUBLIC_HEADERS} DESTINATION "include")
vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO FrankXie05/timercpp
	REF fbf911046b46f4fa68e3a94d004acb3d9de41f10 #master
	SHA512 2e7b1f956e2125676ee7d6653df4232d8d3524df301171fcc93c0ffa3bcfa8a00e519f07c096c58010b82e685cabd801037d06b750dc7a355590d2024029d696
	HEAD_REF master
)
set(BUILD_SHARED_LIBS ON)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_cmake_configure(
	SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
       -DBUILD_SHARED_LIBS=ON
)

if(BUILD_SHARED_LIBS)
    SET(VCPKG_POLICY_DLLS_WITHOUT_LIBS enabled)
    SET(VCPKG_POLICY_DLLS_WITHOUT_EXPORTS enabled)
endif()

vcpkg_cmake_install()
    
#Clean
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib" "${CURRENT_PACKAGES_DIR}/lib")

#copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
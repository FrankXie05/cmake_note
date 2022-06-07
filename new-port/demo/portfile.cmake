vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	REPO FrankXie05/vcpkgdemo
	REF e94c048318c1fb1f8b894f8825295ecb03300691 #v1.0.0
	SHA512 f3606b4c77b90e0d974d04957f20cf633cb0479b0b29880c2d152a697be4d21b713428d21d798fac18272a55ab6b83fea4c2b965411586454321d4b021fda027      
	HEAD_REF main
    PATCHES
       export-cmake-targets.patch
)

vcpkg_cmake_configure(
	SOURCE_PATH "${SOURCE_PATH}"

)
vcpkg_cmake_install()

#Clean

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include") 
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

#copyright

file(INSTALL "${SOURCE_PATH}/README.md" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
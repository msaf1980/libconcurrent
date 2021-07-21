string(TOUPPER "${CMAKE_BUILD_TYPE}" BUILD_TYPE)

if(CMAKE_COMPILER_IS_GNU OR CMAKE_COMPILER_IS_CLANG)
	if(NOT CMAKE_BUILD_TYPE STREQUAL "Plain")
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} -Wall)
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} -Wall)
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} -Wextra)
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} -Wextra)
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} -W)
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} -W)
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} -Wpedantic)
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} -Wpedantic)
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} -Wconversion)
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} -Wconversion)
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} -Wdeclaration-after-statement)
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} -Wdeclaration-after-statement)
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} -Wwrite-strings)
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} -Wwrite-strings)

		if(CMAKE_COMPILER_IS_GNU)
			# some warnings we want are not available with old GCC versions
			# note: starting with CMake 2.8 we could use CMAKE_C_COMPILER_VERSION
			# execute_process(COMMAND ${CMAKE_C_COMPILER} -dumpversion
			# 				OUTPUT_VARIABLE GCC_VERSION)
			if (CMAKE_C_COMPILER_VERSION VERSION_GREATER 4.5 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 4.5)
				append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-Wlogical-op")
				append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-Wlogical-op")
			endif()
			if (CMAKE_C_COMPILER_VERSION VERSION_GREATER 4.8 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 4.8)
				append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-Wshadow")
				append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-Wshadow")
			endif()
		endif(CMAKE_COMPILER_IS_GNU)

	endif()

	# if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	# endif()
	# if(CMAKE_BUILD_TYPE STREQUAL "Release")
	# endif()
	if(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-g")
		append_flag(CMAKE_CXX_FLAGS${BUILD_TYPE} "-g")
	endif()
	#ASanDebug RelWithDebInfo MinSizeRel

	if(CMAKE_BUILD_TYPE MATCHES "Debug")
		# Disable optimimization
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-O0")
		#append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-fno-inline")
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-O0")
		#append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-fno-inline")
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-g")
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-g")
		add_definitions(-DDEBUG)
	endif()
	# ASAN
	if(CMAKE_BUILD_TYPE MATCHES "ASan")
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-fsanitize=address")
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-fsanitize=address")
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-fno-omit-frame-pointer")
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-fno-omit-frame-pointer")
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-fno-optimize-sibling-calls")
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-fno-optimize-sibling-calls")
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-fno-common")
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-fno-common")
		#append_flag(CMAKE_EXE_LINKER_FLAGS_${BUILD_TYPE} "-lasan")
	    #append_flag(CMAKE_SHARED_LINKER_FLAGS_${BUILD_TYPE} "-lasan")

	    # For enable UBSan
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-fsanitize=undefined")
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-fsanitize=undefined")
		#append_flag(CMAKE_EXE_LINKER_FLAGS_${BUILD_TYPE} "-lubsan")
	    #append_flag(CMAKE_SHARED_LINKER_FLAGS_${BUILD_TYPE} "-lubsan")

		set(ENABLE_VALGRIND OFF)
	endif()
	
	# TSAN
	if(CMAKE_BUILD_TYPE MATCHES "TSan")
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-fsanitize=thread")
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-fsanitize=thread")
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-fno-omit-frame-pointer")
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-fno-omit-frame-pointer")
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-fno-optimize-sibling-calls")
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-fno-optimize-sibling-calls")
	    #append_flag(CMAKE_EXE_LINKER_FLAGS_${BUILD_TYPE} "-ltsan")
		#append_flag(CMAKE_SHARED_LINKER_FLAGS_${BUILD_TYPE} "-ltsan")

		set(ENABLE_VALGRIND OFF)
	endif()
	
	# Profile
	if(PROFILE)
		append_flag(CMAKE_C_FLAGS_${BUILD_TYPE} "-g")
		append_flag(CMAKE_CXX_FLAGS_${BUILD_TYPE} "-g")
		append_flag(CMAKE_EXE_LINKER_FLAGS_${BUILD_TYPE} "-lprofiler")
	endif()
endif(CMAKE_COMPILER_IS_GNU OR CMAKE_COMPILER_IS_CLANG)
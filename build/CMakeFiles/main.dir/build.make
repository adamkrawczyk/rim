# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/adam/Documents/pw/rim

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/adam/Documents/pw/rim/build

# Include any dependencies generated for this target.
include CMakeFiles/main.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/main.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/main.dir/flags.make

CMakeFiles/main.dir/src/main.cu.o: CMakeFiles/main.dir/flags.make
CMakeFiles/main.dir/src/main.cu.o: ../src/main.cu
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/adam/Documents/pw/rim/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CUDA object CMakeFiles/main.dir/src/main.cu.o"
	/usr/bin/nvcc  $(CUDA_DEFINES) $(CUDA_INCLUDES) $(CUDA_FLAGS) -x cu -dc /home/adam/Documents/pw/rim/src/main.cu -o CMakeFiles/main.dir/src/main.cu.o

CMakeFiles/main.dir/src/main.cu.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CUDA source to CMakeFiles/main.dir/src/main.cu.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE

CMakeFiles/main.dir/src/main.cu.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CUDA source to assembly CMakeFiles/main.dir/src/main.cu.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE

CMakeFiles/main.dir/src/AudioFir.cu.o: CMakeFiles/main.dir/flags.make
CMakeFiles/main.dir/src/AudioFir.cu.o: ../src/AudioFir.cu
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/adam/Documents/pw/rim/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CUDA object CMakeFiles/main.dir/src/AudioFir.cu.o"
	/usr/bin/nvcc  $(CUDA_DEFINES) $(CUDA_INCLUDES) $(CUDA_FLAGS) -x cu -dc /home/adam/Documents/pw/rim/src/AudioFir.cu -o CMakeFiles/main.dir/src/AudioFir.cu.o

CMakeFiles/main.dir/src/AudioFir.cu.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CUDA source to CMakeFiles/main.dir/src/AudioFir.cu.i"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE

CMakeFiles/main.dir/src/AudioFir.cu.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CUDA source to assembly CMakeFiles/main.dir/src/AudioFir.cu.s"
	$(CMAKE_COMMAND) -E cmake_unimplemented_variable CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE

# Object files for target main
main_OBJECTS = \
"CMakeFiles/main.dir/src/main.cu.o" \
"CMakeFiles/main.dir/src/AudioFir.cu.o"

# External object files for target main
main_EXTERNAL_OBJECTS =

CMakeFiles/main.dir/cmake_device_link.o: CMakeFiles/main.dir/src/main.cu.o
CMakeFiles/main.dir/cmake_device_link.o: CMakeFiles/main.dir/src/AudioFir.cu.o
CMakeFiles/main.dir/cmake_device_link.o: CMakeFiles/main.dir/build.make
CMakeFiles/main.dir/cmake_device_link.o: CMakeFiles/main.dir/dlink.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/adam/Documents/pw/rim/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CUDA device code CMakeFiles/main.dir/cmake_device_link.o"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/main.dir/dlink.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/main.dir/build: CMakeFiles/main.dir/cmake_device_link.o

.PHONY : CMakeFiles/main.dir/build

# Object files for target main
main_OBJECTS = \
"CMakeFiles/main.dir/src/main.cu.o" \
"CMakeFiles/main.dir/src/AudioFir.cu.o"

# External object files for target main
main_EXTERNAL_OBJECTS =

main: CMakeFiles/main.dir/src/main.cu.o
main: CMakeFiles/main.dir/src/AudioFir.cu.o
main: CMakeFiles/main.dir/build.make
main: CMakeFiles/main.dir/cmake_device_link.o
main: CMakeFiles/main.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/adam/Documents/pw/rim/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking CUDA executable main"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/main.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/main.dir/build: main

.PHONY : CMakeFiles/main.dir/build

CMakeFiles/main.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/main.dir/cmake_clean.cmake
.PHONY : CMakeFiles/main.dir/clean

CMakeFiles/main.dir/depend:
	cd /home/adam/Documents/pw/rim/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/adam/Documents/pw/rim /home/adam/Documents/pw/rim /home/adam/Documents/pw/rim/build /home/adam/Documents/pw/rim/build /home/adam/Documents/pw/rim/build/CMakeFiles/main.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/main.dir/depend


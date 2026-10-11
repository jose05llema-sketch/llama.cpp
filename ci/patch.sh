#!/bin/bash
set -euo pipefail
cd examples/llama.android
sed -i "s/set(GGML_CPU_KLEIDIAI ON)/set(GGML_CPU_KLEIDIAI OFF)/; s/set(GGML_OPENMP ON)/set(GGML_OPENMP OFF)/" lib/src/main/cpp/CMakeLists.txt
sed -i "s/listOf(\"arm64-v8a\", \"x86_64\")/listOf(\"arm64-v8a\")/" lib/build.gradle.kts
printf "                arguments += \"%s\"\n" "-DGGML_VULKAN=ON" "-DVulkan_GLSLC_EXECUTABLE=$GITHUB_WORKSPACE/vulkan_sdk/x86_64/bin/glslc" "-DVulkan_INCLUDE_DIR=$HOME/Vulkan-Headers/include" "-DVulkan_LIBRARY=$ANDROID_HOME/ndk/29.0.13113456/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/aarch64-linux-android/33/libvulkan.so" "-DSPIRV-Headers_DIR=$HOME/spirv-install/share/cmake/SPIRV-Headers" > /tmp/args.txt
sed -i "/arguments += \"-DGGML_LLAMAFILE=OFF\"/r /tmp/args.txt" lib/build.gradle.kts
sed -i "s/isMinifyEnabled = true/isMinifyEnabled = false/; s/isShrinkResources = true/isShrinkResources = false/" app/build.gradle.kts
git diff --stat
grep -n "Vulkan\|SPIRV\|arm64" lib/build.gradle.kts

# setup.py (Final Version)
from setuptools import setup, Extension
from Cython.Build import cythonize
import os

# Get the absolute path to the directory containing this setup.py file
here = os.path.abspath(os.path.dirname(__file__))

extensions = [
    Extension(
        name="sdk_wrapper.lite3_controller", 
        sources=[
            "sdk_wrapper/lite3_controller.pyx", 
            "third_party/Lite3_MotionSDK/src/motionexample.cpp",
        ],
        include_dirs=[
            ".", 
            "sdk_wrapper",
            "third_party/Lite3_MotionSDK/include",
            "third_party/Lite3_MotionSDK/include/common", 
            "/usr/include/eigen3", 
        ],

        # 1. ADD THIS: Tell the linker where to look for library files
        library_dirs=["third_party/Lite3_MotionSDK/include/lib"],

        # 2. ADD THIS: Tell the linker WHICH library to use
        libraries=['deeprobotics_legged_sdk_x86_64'], 

        language="c++",
        extra_compile_args=["-std=c++17", "-O2"],

        # 3. ADD THIS: This is crucial for runtime. It bakes the path to the library
        # into your compiled wrapper so Python can find it when you import.
        extra_link_args=[f'-Wl,-rpath,{os.path.join(here, "third_party/Lite3_MotionSDK/lib")}'], 
    )
]

setup(
    ext_modules=cythonize(extensions),
)
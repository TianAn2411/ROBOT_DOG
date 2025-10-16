# setup.py (Phiên bản cho cấu trúc thư mục mới)
import os
from setuptools import setup, Extension
from Cython.Build import cythonize

# Lấy đường dẫn tuyệt đối để đảm bảo các đường dẫn khác luôn đúng
SETUP_DIR = os.path.dirname(os.path.abspath(__file__))
# CẬP NHẬT ĐƯỜNG DẪN ĐỂ TRỎ VÀO BÊN TRONG THƯ MỤC "include"
LIB_DIR = os.path.join(SETUP_DIR, 'third_party', 'Lite3_MotionSDK', 'include', 'lib')

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
            # Giả sử Eigen cũng nằm trong thư mục lib mới
            "third_party/Lite3_MotionSDK/include/lib/eigen3", 
        ],
        
        # Sửa lại đường dẫn đến thư mục lib cho đúng
        library_dirs=[LIB_DIR],
        
        libraries=['deeprobotics_legged_sdk_x86_64'], 

        language="c++",
        extra_compile_args=["-std=c++17", "-O2"],
        # Đảm bảo đường dẫn rpath cũng đúng và là đường dẫn tuyệt đối
        extra_link_args=[f'-Wl,-rpath,{LIB_DIR}'], 
    )
]

setup(
    ext_modules=cythonize(extensions),
)
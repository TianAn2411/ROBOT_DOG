# test_robot.py

# Import lớp Lite3Controller từ module .so mà chúng ta vừa tạo!
from sdk_wrapper.lite3_controller import Lite3Controller
import time

print("--- KHỞI TẠO ROBOT CONTROLLER ---")
# Khởi tạo robot. Địa chỉ IP phải là kiểu bytes.
robot = Lite3Controller(remote_ip=b"192.168.1.120") 
# Nếu bạn chạy mô phỏng trên cùng máy, có thể dùng IP 127.0.0.1
# robot = Lite3Controller(remote_ip=b"127.0.0.1") 

print("\n--- BẮT ĐẦU QUÁ TRÌNH CHUẨN BỊ ĐỨNG ---")
time.sleep(1) # Chờ một chút để receiver nhận được dữ liệu đầu tiên
robot.pre_stand_up(duration=1.0)
time.sleep(1)

print("\n--- BẮT ĐẦU QUÁ TRÌNH ĐỨNG DẬY ---")
robot.stand_up(duration=1.5)
time.sleep(2)

print("\n--- THỬ NGHIỆM KẾT THÚC ---")
# Khi biến 'robot' ra khỏi phạm vi, hàm __dealloc__ sẽ tự động được gọi
# để dọn dẹp tài nguyên C++.
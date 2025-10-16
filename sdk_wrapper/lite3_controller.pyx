from sdk_wrapper.sdk_bridge cimport RobotData, RobotCmd, Sender, Receiver, MotionExample

from libcpp.string cimport string
import time

cdef class Lite3Controller:

    cdef Sender* sender_ptr
    cdef Receiver* receiver_ptr
    cdef MotionExample* motion_ptr
    
    # Các biến C++ để chứa dữ liệu, tránh việc tạo mới liên tục
    cdef RobotData current_state
    cdef RobotCmd command_to_send

    # === Các hàm vòng đời của đối tượng ===
    def __cinit__(self, bytes remote_ip=b"192.168.1.120", int port=43893):
        """
        Đây là hàm khởi tạo của Cython, được gọi trước __init__ của Python.
        Nó chịu trách nhiệm cấp phát bộ nhớ và khởi tạo các đối tượng C++.
        """
        # Chuyển đổi bytes của Python thành string của C++
        cdef string ip_str = remote_ip
        
        # cấp phát bộ nhớ cho các đối tượng
        self.sender_ptr = new Sender(ip_str, port)
        self.receiver_ptr = new Receiver()
        self.motion_ptr = new MotionExample()
        
        # Bắt đầu luồng nhận dữ liệu chạy nền của Receiver
        self.receiver_ptr.StartWork()
        

    def __dealloc__(self):
        del self.sender_ptr
        del self.receiver_ptr
        del self.motion_ptr
        print("Đã giải phóng tài nguyên C++.")

    # === Các hàm điều khiển Robot ===
    def stand_up(self, float duration=1.5):
        """
        Thực hiện một vòng lặp điều khiển để ra lệnh cho robot đứng dậy.
        """
        print(f"Bắt đầu quá trình đứng dậy trong {duration} giây...")
        start_time = time.time()
        
        # Lấy trạng thái ban đầu của các khớp để MotionExample tính toán quỹ đạo
        initial_state = self.receiver_ptr.GetState()
        self.motion_ptr.GetInitData(initial_state.joint_data, 0) # Bắt đầu từ thời điểm 0
        
        # --- Vòng lặp điều khiển chính ---
        while True:
            current_time = time.time()
            elapsed_time = current_time - start_time
            
            if elapsed_time > duration:
                break # Hoàn thành hành động

            # 1. Lấy trạng thái mới nhất từ robot
            self.current_state = self.receiver_ptr.GetState()
            
            # 2. Yêu cầu MotionExample tính toán lệnh tiếp theo
            self.motion_ptr.StandUp(self.command_to_send, elapsed_time, self.current_state)
            
            # 3. Gửi lệnh đi
            self.sender_ptr.SendCmd(self.command_to_send)
            
            # Chờ một khoảng thời gian ngắn (tương đương tần số 500Hz)
            time.sleep(0.002) 
        
        print("Quá trình đứng dậy hoàn tất.")

    def pre_stand_up(self, float duration=1.0):
        """
        Thực hiện một vòng lặp điều khiển để robot co chân chuẩn bị đứng.
        """
        print(f"Chuẩn bị đứng trong {duration} giây...")
        start_time = time.time()
        
        initial_state = self.receiver_ptr.GetState()
        self.motion_ptr.GetInitData(initial_state.joint_data, 0)
        
        while True:
            elapsed_time = time.time() - start_time
            if elapsed_time > duration:
                break

            self.current_state = self.receiver_ptr.GetState()
            self.motion_ptr.PreStandUp(self.command_to_send, elapsed_time, self.current_state)
            self.sender_ptr.SendCmd(self.command_to_send)
            time.sleep(0.002)
        
        print("Hoàn tất chuẩn bị.")
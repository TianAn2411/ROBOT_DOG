# sdk_bridge.pxd (phiên bản đã sửa lỗi)

from libcpp.string cimport string

# ===robot_types.h ===
cdef extern from "third_party/Lite3_MotionSDK/include/robot_types.h":
    
    ctypedef struct JointData:
        float position
        float velocity
        float torque
        float temperature
    
    ctypedef struct LegData:
        JointData joint_data[12]

    ctypedef struct ImuData:
        float angle_roll, angle_pitch, angle_yaw

    ctypedef struct RobotData:
        LegData joint_data
        ImuData imu

    ctypedef struct JointCmd:
        float position, velocity, torque, kp, kd
    
    ctypedef struct RobotCmd:
        JointCmd joint_cmd[12]

# ======sender.h, receiver.h motionexample.h=======
cdef extern from "third_party/Lite3_MotionSDK/include/sender.h":
    cdef cppclass Sender:
        Sender(string ip, unsigned short port)
        void SendCmd(RobotCmd& robot_cmd)

cdef extern from "third_party/Lite3_MotionSDK/include/receiver.h":
    cdef cppclass Receiver:
        Receiver()
        void StartWork()
        RobotData& GetState()

cdef extern from "third_party/Lite3_MotionSDK/include/motionexample.h":
    cdef extern from "Eigen/Dense" namespace "Eigen":
        cdef cppclass Vec3 "Eigen::Matrix<double, 3, 1>":
            pass

    cdef cppclass MotionExample:
        MotionExample()
        void PreStandUp(RobotCmd& cmd, double time, RobotData& data_state)
        void StandUp(RobotCmd& cmd, double time, RobotData& data_state)
        void GetInitData(LegData data, double time)
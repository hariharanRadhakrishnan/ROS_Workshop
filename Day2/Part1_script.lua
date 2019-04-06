function subscriber_callback(msg)
    -- This is the subscriber callback function
    print(msg)
    
    velocityFactor = 5
    
    linearVelocity = msg.linear.x * velocityFactor
    angularVelocity = msg.angular.z * velocityFactor
    
    leftWheelVelocity = linearVelocity + ((linearVelocity + 1) * (-1 * angularVelocity))
    rightWheelVelocity = linearVelocity + ((linearVelocity + 1) * angularVelocity)
    
    -- Set the velocities
    sim.setJointTargetVelocity(leftJoint, leftWheelVelocity)
    sim.setJointTargetVelocity(rightJoint, rightWheelVelocity)
end

function sysCall_init()
    leftJoint=sim.getObjectHandle("dr20_leftWheelJoint_")
    rightJoint=sim.getObjectHandle("dr20_rightWheelJoint_")

    -- ROS Subscription to topic /turtle1/cmd_vel 
    subscriber=simROS.subscribe('/turtle1/cmd_vel','geometry_msgs/Twist','subscriber_callback')

end


function sysCall_cleanup() 
end 


function sysCall_actuation()
end 
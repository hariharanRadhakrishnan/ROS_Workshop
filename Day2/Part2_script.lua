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
    camera=sim.getObjectHandle("Vision_sensor")

    -- ROS Subscription to topic /turtle1/cmd_vel 
    subscriber=simROS.subscribe('/turtle1/cmd_vel','geometry_msgs/Twist','subscriber_callback')

    -- ROS Publisher to publish Image 
    pub=simROS.advertise('/d20_image', 'sensor_msgs/Image') -- You created a publisher object
    simROS.publisherTreatUInt8ArrayAsString(pub) -- treat uint8 arrays as strings (much faster, tables/arrays are kind of slow in Lua)
end

function sysCall_sensing()
    -- Publish the image of the active vision sensor:
    local data,w,h=sim.getVisionSensorCharImage(camera)
    d={}
    d['header']={seq=0,stamp=simROS.getTime(), frame_id="Robot_Image"}
    d['height']=w
    d['width']=h
    d['encoding']='rgb8'
    d['is_bigendian']=1
    d['step']= w*3
    d['data']=data
    --print(w,h)
    simROS.publish(pub,d)
end

function sysCall_cleanup() 
end 


function sysCall_actuation()

end 

(import 
    [os [environ]]
    [urlparse [urlparse]]
    [logging [getLogger basicConfig DEBUG INFO]])

(def *debug-mode* true)    

(defn from-env [variable &optional [default-value "tcp://localhost:80"]]
    (.split (.replace (.get environ variable default-value) "tcp://" "") ":"))
    
(def *mqtt-server*
    (get (from-env "MQTT_PORT" "tcp://localhost:1883") 0))

(def *mqtt-port* 
    (int (get (from-env "MQTT_PORT" "tcp://localhost:1883") 1)))
    
(def *redis-server*
    (get (from-env "REDIS_PORT" "tcp://localhost:6379") 0))

(def *redis-port* 
    (int (get (from-env "REDIS_PORT" "tcp://localhost:6379") 1)))
    
(if *debug-mode*
    (apply basicConfig [] {"level" DEBUG})
    (apply basicConfig [] {"level" INFO}))
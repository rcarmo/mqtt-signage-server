(import 
    [os [environ]]
    [urlparse [urlparse]])
    
(defn from-env [variable]
    (.split (.replace (get environ variable) "tcp://" "") ":"))
    
(def *mqtt-server*
    (get (from-env "MQTT_PORT") 0))

(def *mqtt-port* 
    (int (get (from-env "MQTT_PORT") 1)))
    
(def *redis-server*
    (get (from-env "REDIS_PORT") 0))

(def *redis-port* 
    (int (get (from-env "REDIS_PORT") 1)))
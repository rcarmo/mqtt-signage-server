(import 
    [os [environ]]
    [urlparse [urlparse]])
    
(def mqtt-environ
    (.split (.replace (get environ "MQTT_PORT") "tcp://" "") ":"))
    
(def *mqtt-server*
    (get mqtt-environ 0))

(def *mqtt-port* 
    (int (get mqtt-environ 1)))

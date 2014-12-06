; this is a makeshift client for testing
(import 
    [functools [partial]]
    [time [time]]
    [logging [getLogger]]
    [json [dumps loads]]
    [config [*mqtt-server* *mqtt-port*]]
    [paho.mqtt.client [Client]])

(setv log (getLogger))
    
; IP address reported by client
(def *ip-address* "192.168.0.1")

; MAC address reported by client
(def *mac-address* "de:ad:be:ef:00:42")

; our current playlist
(def *playlist* {})

; our current group memberships
(def *groups* [*mac-address*])

(def *message-template* {"ip" *ip-address* "mac" *mac-address*})

(defn on-message [client userdata msg]
    (let [[topic   msg.topic]
          [payload msg.payload]]
          (.debug log (+ topic ":" payload))))
          
(defn on-connect [client userdata flags rc]
    (.debug log "connected")
    (for [subscription *groups*]
        (.subscribe client (str (+ "signage/play/" subscription)) 0))
    (let [[message (dict *message-template*)]]
        (assoc message "timestamp" (time))
        (.publish client 
            (str "signage/report") (dumps message))))  ; TODO: set timer for next report
            
(defmain [&rest args]
    (let [[c (Client)]]
        (setv c.on-connect on-connect)
        (setv c.on-message on-message)
        (.connect c *mqtt-server* *mqtt-port* 60)
        (.loop-forever c)))
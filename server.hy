(import
    [json [loads dumps]]
    [logging [getLogger]]
    [config [*mqtt-server* *mqtt-port* *redis-server* *redis-port*]]
    [redis [StrictRedis :as Redis]]
    [paho.mqtt.client [Client]])

(setv log (getLogger))

(defn on-message [client userdata msg]
    (let [[topic   msg.topic]
          [payload (loads msg.payload)]] ; TODO: handle possible exceptions
          (.debug log (+ topic ":" (str payload)))))

; signage/report
;   {"url" None "duration" 0 "ip" "127.0.0.1" "mac" "de:ad:be:ef:00:42" "playlist" "uuid"}
; signage/setgroup/<id>
; signage/playlist/<id>
; signage/play/<id>
; signage/reset/<id>

(defn on-connect [client userdata flags rc]
    (.debug log "connected.")
    ; paho does not like Unicode strings
    (.subscribe client (str "signage/#") 0))

(defmain [&rest args]
    (let [[c (Client)]
          [r (apply Redis [] {"host" *redis-server* "port" *redis-port*})]]
        (setv c.on-connect on-connect)
        (setv c.on-message on-message)
        (.connect c *mqtt-server* *mqtt-port* 60)
        (.loop-forever c)))

(import
	[paho.mqtt.client [Client]])


(defn on-message [client userdata msg]
	(let [[topic   msg.topic]]
		  [payload (str msg.payload)]]
		  (print topic payload)))

; signage/report
;   {"url" None "duration" 0 "ip" "127.0.0.1" "mac" "de:ad:be:ef:00:42" "playlist" "uuid"}
; signage/setgroup/<id>
; signage/playlist/<id>
; signage/play/<id>

(defn on-connect [client userdata flags rc]
	(.subscribe client "signage/report"))


(defmain [&rest args]
	(let [[c (Client)]]
		(setv c.on-connect on-connect)
		(setv c.on-message on-message)
		(.connect c "localhost" 1883 60)
		(.loop-forever c)))
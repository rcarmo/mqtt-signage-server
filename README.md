# mqtt-signage-server

This is a clean-room re-implementation of our [digital signage server][dss] back-end, focusing on:

* Switching over to [MQTT][mqtt] as the primary protocol for managing devices.
* Rebuilding the system as a set of communicating processes.
* Real-time control and coordination of multiple signage devices into a "videowall".

# Getting Started

This is being developed using [fig][fig], so you should have a [Docker][d]-capable environment.

## Setting up

```
make bootstrap
fig build
```

## Running (Development)

```
fig up
```

# Client Protocol

### Lifecycle

1. Clients connect to the [MQTT][mqtt] broker and report their MAC address, current IP address and other internal state (including timestamp) via the `signage/report` topic.
2. Clients subscribe to `signage/control/<identifier>`, where `identifier` is their (lowercased) MAC address or a group label.
3. Clients then act on received payloads (there is no explicit disconnect notification).

### Commands

Clients can act upon the following commands:

1. Set the current playlist (an ordered tuple of asset/duration items), which is acted upon immediately (the device starts playing it from the initial item). The playlist loops forever.
2. Play a specific asset (with an optional duration) immediately. If the duration is absent or set to zero, the client will not resume its current playlist)
3. Queue a specific asset for playback at a specific time. This works like the above, except that the device will set an internal timer for playing the item. There might be an arbitrary number of assets queued up at any one time, and queueing a `null` item clears the whole queue.
4. Set the current group (i.e., subscribe to an additional broker topic to allow coordinating multiple devices). A `null` group means the device will go back to listening only for direct instructions
5. Reset/reboot the device (if at all possible considering some of the constraints of managed code in Android)

### Assets

Clients can display two kinds of assets, both specified by URLs:

* Web pages
* Video files

Text messages, notices, etc., are merely a matter of handing over the required text as a URL parameter to the web pages themselves.

> There are a number of issues associated with video playback (and being able to interrupt it/ending it cleanly) in clients that merit more notes later.

[mqtt]: http://www.mqtt.org
[dss]: http://github.com/sapo/digital-signage-server
[fig]: http://www.fig.sh
[d]: http://www.docker.com

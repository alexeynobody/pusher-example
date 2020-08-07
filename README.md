# About

Example app using Pusher

## Getting Started

1. Set key and cluster from Pusher in main.dart

```dart
     await Pusher.init(
        "Your App Key here",
        PusherOptions(cluster: "eu"),
        enableLogging: true,
      );
```

2. Send event 'test-event' to 'main' channel 
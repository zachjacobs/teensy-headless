Quickstart
---
```
make arduino-tools && make upload
```

This is still a fairly rough sketch, and makes a few assumptions:
* needs a working Arduino/Teensyduino install at `/usr/local/lib/arduino`
* only tested against my Teensy 3.6
* requires manual installation of Arduino/Teensyduino which is somewhat inconvenient
  for the intended use case of using a Raspberry Pi to (re)program the board
  dynamically

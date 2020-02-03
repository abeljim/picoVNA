# rpi code

## preparing bluez

The bluez library needs to be compiled from source on the rpi with static library enabled because the exposed API doesn't contain GATT implementations. The compiled libraries are in ```.lib``` folders inside ```src``` and ```lib```

```shell
# inside bluez source code
./configure --enable-library --enable-static=yes --disable-datafiles --disable-client --disable-obex --enable-shared=no --disable-cups

make
```

## deps

```shell
sudo apt install libserialport-dev -y
```

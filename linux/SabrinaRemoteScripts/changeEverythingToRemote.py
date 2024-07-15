from bluepy.btle import Peripheral, DefaultDelegate
import time

class MyDelegate(DefaultDelegate):
    def __init__(self):
        DefaultDelegate.__init__(self)

    # This method will be called on every notification received
    def handleNotification(self, handle, data):
        if handle == 70:
            print("Yaaas")

# Initialize the peripheral device
device = Peripheral("E4:E1:12:DB:65:5F")

# Set notification delegate
device.setDelegate(MyDelegate())



# Request to change the MTU size to 250
new_mtu = device.setMTU(192)
print(f"MTU size changed, new MTU size: {new_mtu}")


# Subscribe to notifications
#device.writeCharacteristic(0x0024, b'\x60\x00\x30\x00')
#device.writeCharacteristic(0x0027, b'\x01\x00', True)
#device.writeCharacteristic(0x001f, b'\x01\x00', True)
device.writeCharacteristic(0x0047, b'\x01\x00', True)


device.writeCharacteristic(0x004f, b'\x01', True)
device.writeCharacteristic(0x004f, b'\x00', True)

# Main loop
while True:
    device.waitForNotifications(0)
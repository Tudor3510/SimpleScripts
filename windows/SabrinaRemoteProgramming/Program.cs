using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Windows.Devices.Bluetooth;
using Windows.Devices.Bluetooth.GenericAttributeProfile;
using Windows.Devices.Enumeration;
using Windows.Storage.Streams;

namespace BLEWriteCharacteristic
{
    class Program
    {
        private static Dictionary<Guid, GattCharacteristic> _characteristics = new Dictionary<Guid, GattCharacteristic>();

        static async Task Main(string[] args)
        {
            string deviceName = "Chromecast Remote"; // Replace with your device name
            string serviceUuid = "d343bfc0-5a21-4f05-bc7d-af01f617b664"; // Replace with your service UUID

            bool initResult = await InitializeCharacteristicsAsync(deviceName, serviceUuid, new List<string> {
                "d343bfc1-5a21-4f05-bc7d-af01f617b664",
                "d343bfc2-5a21-4f05-bc7d-af01f617b664",
                "d343bfc3-5a21-4f05-bc7d-af01f617b664"
            });

            if (!initResult)
            {
                Console.WriteLine("Failed to initialize characteristics.");
                return;
            }

            bool result = await WriteCharacteristicAsync("d343bfc1-5a21-4f05-bc7d-af01f617b664", "01");
            Console.WriteLine(result ? "Write successful." : "Write failed.");

            await Task.Delay(1000);



            result = await WriteCharacteristicAsync("d343bfc2-5a21-4f05-bc7d-af01f617b664", "0018");
            Console.WriteLine(result ? "Write successful." : "Write failed.");

            result = await WriteCharacteristicAsync("d343bfc3-5a21-4f05-bc7d-af01f617b664", "0221017c0022106000ab00ad001600400016004000160040001600150016001500160015001600150016001500160040001600400016004000160015001600150016001500160015001600150016001500160040001600150016001500160015001600150016001500160015001600400016001500160040001600400016004000160040001600400016004000160738");
            Console.WriteLine(result ? "Write successful." : "Write failed.");


            result = await WriteCharacteristicAsync("d343bfc2-5a21-4f05-bc7d-af01f617b664", "0019");
            Console.WriteLine(result ? "Write successful." : "Write failed.");

            result = await WriteCharacteristicAsync("d343bfc3-5a21-4f05-bc7d-af01f617b664", "0221017c0022101500ab00ab0016004000160040001600400016001500160015001600150016001500160015001600400016004000160040001600150016001500160015001600150016001500160040001600150016001500160015001600150016001500160015001600150016001500160040001600400016004000160040001600400016004000160040001606ef");
            Console.WriteLine(result ? "Write successful." : "Write failed.");


            result = await WriteCharacteristicAsync("d343bfc2-5a21-4f05-bc7d-af01f617b664", "001a");
            Console.WriteLine(result ? "Write successful." : "Write failed.");

            result = await WriteCharacteristicAsync("d343bfc3-5a21-4f05-bc7d-af01f617b664", "0221017c0022106000ab00ad001600400016004000160040001600150016001500160015001600150016001500160040001600400016004000160015001600150016001500160015001600150016004000160040001600400016001500160015001600150016001500160015001600150016001500160015001600400016004000160040001600400016004000160738");
            Console.WriteLine(result ? "Write successful." : "Write failed.");


            //result = await WriteCharacteristicAsync("d343bfc2-5a21-4f05-bc7d-af01f617b664", "00a4");
            //Console.WriteLine(result ? "Write successful." : "Write failed.");

            //result = await WriteCharacteristicAsync("d343bfc3-5a21-4f05-bc7d-af01f617b664", "0221017c0022106000ab00ad001600400016004000160040001600150016001500160015001600150016001500160040001600400016004000160015001600150016001500160015001600150016004000160040001600400016004000160015001600150016001500160015001600150016001500160015001600150016004000160040001600400016004000160738");
            //Console.WriteLine(result ? "Write successful." : "Write failed.");


            result = await WriteCharacteristicAsync("d343bfc2-5a21-4f05-bc7d-af01f617b664", "00b2");
            Console.WriteLine(result ? "Write successful." : "Write failed.");

            result = await WriteCharacteristicAsync("d343bfc3-5a21-4f05-bc7d-af01f617b664", "0221017c0022106000ab00ad001600400016004000160040001600150016001500160015001600150016001500160040001600400016004000160015001600150016001500160015001600150016004000160040001600150016004000160015001600150016001500160015001600150016001500160040001600150016004000160040001600400016004000160738");
            Console.WriteLine(result ? "Write successful." : "Write failed.");




            result = await WriteCharacteristicAsync("d343bfc1-5a21-4f05-bc7d-af01f617b664", "00");
            Console.WriteLine(result ? "Write successful." : "Write failed.");
        }

        public static async Task<bool> InitializeCharacteristicsAsync(string deviceName, string serviceUuid, List<string> characteristicUuids)
        {
            var device = await FindDeviceByNameAsync(deviceName);
            if (device == null)
            {
                Console.WriteLine("Device not found.");
                return false;
            }

            var gattServicesResult = await device.GetGattServicesAsync(BluetoothCacheMode.Uncached);
            if (gattServicesResult.Status != GattCommunicationStatus.Success)
            {
                Console.WriteLine("Failed to get GATT services.");
                return false;
            }

            var service = gattServicesResult.Services.FirstOrDefault(s => s.Uuid == new Guid(serviceUuid));
            if (service == null)
            {
                Console.WriteLine("Service not found.");
                return false;
            }

            var gattCharacteristicsResult = await service.GetCharacteristicsAsync(BluetoothCacheMode.Uncached);
            if (gattCharacteristicsResult.Status != GattCommunicationStatus.Success)
            {
                Console.WriteLine("Failed to get characteristics.");
                return false;
            }

            foreach (var characteristicUuid in characteristicUuids)
            {
                var characteristic = gattCharacteristicsResult.Characteristics.FirstOrDefault(c => c.Uuid == new Guid(characteristicUuid));
                if (characteristic != null)
                {
                    _characteristics[new Guid(characteristicUuid)] = characteristic;
                }
                else
                {
                    Console.WriteLine($"Characteristic {characteristicUuid} not found.");
                    return false;
                }
            }

            return true;
        }

        public static async Task<bool> WriteCharacteristicAsync(string characteristicUuid, string hexData)
        {
            if (!_characteristics.TryGetValue(new Guid(characteristicUuid), out var characteristic))
            {
                Console.WriteLine("Characteristic not found in the initialized characteristics.");
                return false;
            }

            byte[] data = HexStringToByteArray(hexData);
            var writer = new DataWriter();
            writer.WriteBytes(data);
            var writeResult = await characteristic.WriteValueAsync(writer.DetachBuffer());

            return writeResult == GattCommunicationStatus.Success;
        }

        private static async Task<BluetoothLEDevice> FindDeviceByNameAsync(string deviceName)
        {
            var devices = await DeviceInformation.FindAllAsync(BluetoothLEDevice.GetDeviceSelector());
            foreach (var deviceInfo in devices)
            {
                var device = await BluetoothLEDevice.FromIdAsync(deviceInfo.Id);
                if (device != null && device.Name == deviceName)
                {
                    return device;
                }
            }
            return null;
        }

        private static byte[] HexStringToByteArray(string hex)
        {
            if (hex.Length % 2 != 0)
                throw new ArgumentException("Hex string must have an even length.");

            byte[] bytes = new byte[hex.Length / 2];
            for (int i = 0; i < hex.Length; i += 2)
            {
                bytes[i / 2] = Convert.ToByte(hex.Substring(i, 2), 16);
            }
            return bytes;
        }
    }
}

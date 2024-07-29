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
            string deviceName = ""; // Replace with your device name
            string serviceUuid = ""; // Replace with your service UUID

            bool initResult = await InitializeCharacteristicsAsync(deviceName, serviceUuid, new List<string> {
                "",
                "",
                ""
            });

            if (!initResult)
            {
                Console.WriteLine("Failed to initialize characteristics.");
                return;
            }

            bool result = await WriteCharacteristicAsync("", "01");
            Console.WriteLine(result ? "Write successful." : "Write failed.");

            await Task.Delay(1000);



            result = await WriteCharacteristicAsync("", "");
            Console.WriteLine(result ? "Write successful." : "Write failed.");

            result = await WriteCharacteristicAsync("", "");
            Console.WriteLine(result ? "Write successful." : "Write failed.");


            result = await WriteCharacteristicAsync("", "");
            Console.WriteLine(result ? "Write successful." : "Write failed.");

            result = await WriteCharacteristicAsync("", "");
            Console.WriteLine(result ? "Write successful." : "Write failed.");


            result = await WriteCharacteristicAsync("", "");
            Console.WriteLine(result ? "Write successful." : "Write failed.");

            result = await WriteCharacteristicAsync("", "");
            Console.WriteLine(result ? "Write successful." : "Write failed.");


            //result = await WriteCharacteristicAsync("", "");
            //Console.WriteLine(result ? "Write successful." : "Write failed.");

            //result = await WriteCharacteristicAsync("", "");
            //Console.WriteLine(result ? "Write successful." : "Write failed.");


            result = await WriteCharacteristicAsync("", "");
            Console.WriteLine(result ? "Write successful." : "Write failed.");

            result = await WriteCharacteristicAsync("", "");
            Console.WriteLine(result ? "Write successful." : "Write failed.");




            result = await WriteCharacteristicAsync("", "00");
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

package com.tudor.sendbluetoothidentificationpacket;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import java.util.UUID;

public class MainActivity extends AppCompatActivity {
    private static final String TAG = "BLEActivity";
    private static final String DEVICE_ADDRESS = "E4:E1:12:DB:65:5F";

    // Define the UUIDs for the GATT service and characteristic you will write to.
    private static final UUID SERVICE_UUID = UUID.fromString("d343bfc0-5a21-4f05-bc7d-af01f617b664");
    private static final UUID CHARACTERISTIC_UUID = UUID.fromString("d343bfc4-5a21-4f05-bc7d-af01f617b664");


    private BluetoothAdapter bluetoothAdapter = null;
    private BluetoothGatt bluetoothGatt = null;
    private BluetoothGattService bluetoothGattService = null;
    private BluetoothGattCharacteristic bluetoothGattCharacteristic = null;
    private int index = 1;
    private Context context;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        context = this;
    }

    @SuppressLint("MissingPermission")
    @Override
    protected void onResume() {
        super.onResume();

        if (bluetoothAdapter == null){
            BluetoothManager bluetoothManager = (BluetoothManager) getSystemService(Context.BLUETOOTH_SERVICE);
            bluetoothAdapter = bluetoothManager.getAdapter();
        }

        if (bluetoothAdapter == null)
            return;

        if (bluetoothGatt != null)
            bluetoothGattService = bluetoothGatt.getService(SERVICE_UUID);

        if (bluetoothGatt == null || bluetoothGattService == null) {
            BluetoothDevice device = bluetoothAdapter.getRemoteDevice(DEVICE_ADDRESS);
            bluetoothGatt = device.connectGatt(this, true, new BluetoothGattCallback() {
                @Override
                public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
                    if (newState == BluetoothGatt.STATE_CONNECTED) {
                        Log.d(TAG, "Connected to GATT server.");
                        gatt.discoverServices();
                    } else if (newState == BluetoothGatt.STATE_DISCONNECTED) {
                        Log.d(TAG, "Disconnected from GATT server.");
                    }
                }

                @Override
                public void onServicesDiscovered(BluetoothGatt gatt, int status) {
                    if (status == BluetoothGatt.GATT_SUCCESS){
                        Log.d(TAG, "Services discovered successfully.");

                        bluetoothGattCharacteristic = gatt.getService(SERVICE_UUID).getCharacteristic(CHARACTERISTIC_UUID);
                        sendDataToBLEDevice(context, bluetoothGattCharacteristic, index);
                        index += 1;
                    }
                }
            });

            return;
        }


        bluetoothGattCharacteristic = bluetoothGattService.getCharacteristic(CHARACTERISTIC_UUID);

        if (bluetoothGattCharacteristic == null)
            return;

        sendDataToBLEDevice(context, bluetoothGattCharacteristic, index);
        index += 1;
    }

    @SuppressLint("MissingPermission")
    private void sendDataToBLEDevice(Context context, BluetoothGattCharacteristic characteristic, int ind) {
        // Data to send in the BLE packet (as a byte array)
        int toSend = (ind / 10) * 6 + ind;
        byte[] dataToSend = new byte[]{0x77, (byte) toSend}; // Replace with your data

        characteristic.setValue(dataToSend);
        boolean success = bluetoothGatt.writeCharacteristic(characteristic);

        if (success) {
            Log.d(TAG, "Data sent successfully!");
            // Find the TextView by its ID
            TextView textView = findViewById(R.id.textView);
            // Set the text of the TextView
            textView.setText(String.format("Data sent: %d", ind));
        } else {
            Log.e(TAG, "Failed to send data.");
        }
    }

    @SuppressLint("MissingPermission")
    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (bluetoothGatt != null) {
            bluetoothGatt.close();
            bluetoothGatt = null;
        }
    }

    public void resetIndex(View view) {
        index = 1;
        Toast.makeText(context, "Index reset", Toast.LENGTH_SHORT).show();
    }
}

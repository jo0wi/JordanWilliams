
#include <M5StickCPlus.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

BLEServer* pServer = NULL; 
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool advertising = false;

#define SERVICE_UUID  "e6e84dae-5a39-4c07-9a4b-ae031d4d4cd7"
#define CHARACTERISTIC_UUID "5130bfef-4533-4945-91c0-a2dfed90bffa"

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer, esp_ble_gatts_cb_param_t *param) {
      Serial.println("Device connected");
      // this code isnt necessary, but it makes the bluetooth go faster
      pServer->updateConnParams(param->connect.remote_bda, 0x06, 0x06, 0, 100);
      deviceConnected = true;
      advertising = false;
    };

    void onDisconnect(BLEServer* pServer) {
      Serial.println("Device disconnected");
      deviceConnected = false;
    }
};

void setup() {
  M5.begin();
  M5.IMU.Init();

  BLEDevice::init("M5StickCPlus-Jordan");

  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);

  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_NOTIFY 
                    );

  pCharacteristic->addDescriptor(new BLE2902());

  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x06);  
  pAdvertising->setMaxPreferred(0x0C);
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}
#pragma pack(1) 
typedef struct {
  uint8_t buttonA;
} Packet;
void loop() {
    // notify changed value
    if (deviceConnected) {
        Packet p;
        p.buttonA = 1-digitalRead(37); // front button, converted to 1 pressed, 0 released
        pCharacteristic->setValue((uint8_t*)&p, sizeof(Packet));
        pCharacteristic->notify();
        delay(1); // bluetooth stack will go into congestion, if too many packets are sent
    }
    // disconnecting
    if (!deviceConnected && !advertising) {
        delay(500); // give the bluetooth stack the chance to get things ready
        pServer->startAdvertising(); // restart advertising
        Serial.println("start advertising");
        advertising = true;
    }
    
}
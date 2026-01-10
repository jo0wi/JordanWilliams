#include <M5StickCPlus.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLE2902.h>

#define SERVICE_UUID  "e6e84dae-5a39-4c07-9a4b-ae031d4d4cd7"
#define CHARACTERISTIC_UUID "5130bfef-4533-4945-91c0-a2dfed90bffa"

#pragma pack(1)
typedef struct {
float accx, accy, accz ;
bool btn; 
uint16_t batt;
} Packet;

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool advertising = false;

int num = 0;

class MyServerCallbacks: public BLEServerCallbacks {
  void onConnect(BLEServer* pServer, esp_ble_gatts_cb_param_t *param) {
    M5.Lcd.println("Device connected");
    deviceConnected = true;
    advertising = false;
  };
  void onDisconnect(BLEServer* pServer){
    M5.Lcd.println("Device disconnected");
    deviceConnected = false;
    
  }
};

void setup() {
  M5.begin();
  M5.IMU.Init();
  Serial.begin(115200);
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
  BLEDevice::startAdvertising();  
}

void loop(){
  if (deviceConnected){
    Packet p;
    M5.IMU.getAccelData(&p.accx, &p.accy, &p.accz);
    p.batt = M5.Axp.GetVbatData(); 
    p.btn = M5.BtnA.isPressed();       
    pCharacteristic->setValue((uint8_t*)&p, sizeof(Packet));
    pCharacteristic->notify();
    //Serial.println(p.accx);
    //Serial.print(p.accy);
    //Serial.println(p.accz);
    //Serial.println(p.batt);
    if (p.btn != 0 ){ 
    Serial.println(p.btn);
    }    
    num++;
    delay(10);
  }
  if (!deviceConnected && !advertising){
    BLEDevice::startAdvertising();
    M5.Lcd.println("start advertising");
    advertising = true;
  }
}

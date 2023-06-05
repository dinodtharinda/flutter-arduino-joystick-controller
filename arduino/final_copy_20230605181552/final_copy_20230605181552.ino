
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <stdio.h>
#include <string.h>

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
int counter = 0;
bool swit = false;
char all[100] = "";

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"



class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    BLEDevice::startAdvertising();
  };

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
  }
};



void incrementCounter() {
  swit = !swit;
  digitalWrite(4, swit);
}


void controller(float dg, float dc) {
  if (dg > 0) {
    digitalWrite(13, HIGH);
  } else {
    digitalWrite(13, LOW);
  }

  if((dg> 0 && dg<22.5)|| (dg> 337.5 && dg< 360)){
    Serial.println("N");
  }else if(dg>22.5 && dg<67.5){
    Serial.println("NE");
  }else if(dg>67.5 && dg<112.5){
    Serial.println("E");
  }else if(dg>112.5 && dg<157.5){
    Serial.println("SE");
  }else if(dg>157.5 && dg<202.5){
    Serial.println("S");
  }else if(dg>202.5 && dg<247.5){
    Serial.println("SW");
  }else if(dg>247.5 && dg<292.5){
    Serial.println("W");
  }else if(dg>292.5 && dg<337.5){
    Serial.println("NW");
  }else{
    Serial.println("Stoped");
  }
}

void executeCommandFromFlutter(const char* command) {
  if (strcmp(command, "incrementCounter") == 0) {
    incrementCounter();
  } else if (strcmp(command, "Hello") == 0) {
    Serial.println("Hello ESP");
  } else {
    float dividend, divisor;
    sscanf(all, "%f %f", &dividend, &divisor);
    controller(dividend, divisor);
  }
}

class MyCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic* pCharacteristic) {
    std::string value = pCharacteristic->getValue();
    memset(all, 0, sizeof(all));
    if (value.length() > 0) {
      for (int i = 0; i < value.length(); i++) {
        strncat(all, &value[i], 1);
      }
      executeCommandFromFlutter(all);
    }
  }
};

void setup() {
  Serial.begin(115200);
  pinMode(2, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(13, OUTPUT);

  BLEDevice::init("ESP32 GET NOTI FROM DEVICE");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
  BLEService* pService = pServer->createService(SERVICE_UUID);
  pCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_INDICATE);

  pCharacteristic->setCallbacks(new MyCallbacks());
  pCharacteristic->addDescriptor(new BLE2902());
  pService->start();
  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}


void loop() {
  if (!deviceConnected && oldDeviceConnected) {
    digitalWrite(2, LOW);
    delay(500);
    pServer->startAdvertising();
    esp_restart();
    Serial.println("Device Disconnected!");
    oldDeviceConnected = deviceConnected;
  }
  if (deviceConnected && !oldDeviceConnected) {
    digitalWrite(2, HIGH);
    Serial.println("Device Connected!");
    oldDeviceConnected = deviceConnected;
  }
}

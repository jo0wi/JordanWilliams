#include "auth.h"
#include <WiFi.h> 
#include "esp_wpa2.h" 
#include <M5StickCPlus.h>
#include <ArduinoMqttClient.h>
const char broker[] = "eduoracle.ugavel.com";
int        port     = 1883;

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);
const char topic_status2[] = "elee2045/finalproj/light_status2";
const char topic_control_color2[] = "elee2045/finalproj/light_control_color2";
const char topic_control_status2[] = "elee2045/finalproj/light_control_status2";
char buffer[100];
int r2;
int g2;
int b2;
int status2;

uint16_t rgb565(uint8_t r2, uint8_t g2, uint8_t b2)
{
  return ((r2 / 8) << 11) | ((g2 / 4) << 5) | (b2 / 8);
}

void updateStatus(){
  M5.Axp.ScreenBreath(status2?15:0);
  //colors are in 565 format
  M5.Lcd.fillScreen(rgb565(r2,g2,b2));
}

void onMqttMessage(int messageSize) {
  if(mqttClient.messageTopic() == topic_control_color2){
    //read 3 unsigned bytes
    r2 = mqttClient.read();
    g2 = mqttClient.read();
    b2 = mqttClient.read();
   
  }
  if(mqttClient.messageTopic() == topic_control_status2){
    status2 = mqttClient.read();
  }
  updateStatus();
  sendStatus();
}
unsigned long last_time;
void setup() {
  M5.begin();
  M5.Lcd.fillScreen(BLACK);
  WiFi.disconnect(true);  
  WiFi.mode(WIFI_STA); 
  #ifdef USE_EAP
    esp_wifi_sta_wpa2_ent_set_identity((uint8_t *)EAP_ANONYMOUS_IDENTITY, strlen(EAP_ANONYMOUS_IDENTITY));
    esp_wifi_sta_wpa2_ent_set_username((uint8_t *)EAP_IDENTITY, strlen(EAP_IDENTITY));
    esp_wifi_sta_wpa2_ent_set_password((uint8_t *)EAP_PASSWORD, strlen(EAP_PASSWORD));
    esp_wifi_sta_wpa2_ent_enable();
    WiFi.begin(ssid);
  #else
    WiFi.begin(ssid,WPA_PASSWORD);
  #endif
  WiFi.setSleep(false);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.println("Waiting for connection");
  }
  IPAddress ip = WiFi.localIP();
  Serial.println(ip);
  M5.Lcd.print(ip);
  
  mqttClient.onMessage(onMqttMessage);
  mqttClient.setUsernamePassword("giiuser","giipassword");
  mqttClient.connect(broker, port);
  mqttClient.subscribe(topic_control_color2);
  mqttClient.subscribe(topic_control_status2);
  last_time = millis();
  updateStatus();
}
void sendStatus(){
  mqttClient.beginMessage(topic_status2);
  mqttClient.write(status2);
  mqttClient.write(r2);
  mqttClient.write(g2);
  mqttClient.write(b2);
  mqttClient.endMessage();
}
int waitingForRelease = 0;
void loop(){
  mqttClient.poll();
  if(millis()-last_time > 2000){
    sendStatus();
    last_time = millis();
  }

  if(digitalRead(37)==LOW && !waitingForRelease){
    status2 = !status2;
    updateStatus();
    sendStatus();
    waitingForRelease = 1;
  }
  if(digitalRead(37)==HIGH){
    waitingForRelease = 0;
  }
}

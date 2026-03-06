#include <Wire.h>
#include "SPI.h" //library supports SPI and I2C connection
#include <Adafruit_Sensor.h>
#include "Adafruit_BMP280.h"
#include "DHT.h"
#include <WiFi.h>
#include "ThingSpeak.h"
#include <LiquidCrystal_I2C.h>
#include "auth.h"
#include "esp_wpa2.h"

#define DHTPIN 2    
#define DHTTYPE DHT11  
#define COV_RATIO 0.13            
#define NO_DUST_VOLTAGE 0           
#define ESP_VOLTAGE 3.3   
#define thermPin 3

Adafruit_BMP280 bmp; // I2C
WiFiClient  client;
DHT dht(DHTPIN, DHTTYPE);

//lcd values
int lcdColumns = 16;
int lcdRows = 2;
LiquidCrystal_I2C lcd(0x27, lcdColumns, lcdRows);

//ThingSpeak info
unsigned long myChannelNumber = THINGSPEAK_CHANNEL_NUMBER;
const char * myWriteAPIKey = THINGSPEAK_WRITE_API_KEY;


// Initializing variables
float pressure;		
int altimeter; 		
float hum;
float V_out, V_in, Rt, R1;
int therm_adcValue;
float temp_F;
float temp_C;
float inv_T;
//Steinhart-Hart constants
const float A = 0.001129148;
const float B = 0.000234125;
const float C = 0.0000000876741;
//Variables for Dust Sensor
const int iled = 1;                                            
const int vout = 0;                                            
float dustDensity;
float voltage;
int adcvalue;

//Dust Sensor Filter
int Filter(int m){
  static int flag_first = 0, _buff[10], sum;
  const int _buff_max = 10;
  int i;
  
  if(flag_first == 0){
    flag_first = 1;
    for(i = 0, sum = 0; i < _buff_max; i++){
      _buff[i] = m;
      sum += _buff[i];
    }
    return m;
  }
  else{
    sum -= _buff[0];
    for(i = 0; i < (_buff_max - 1); i++){
      _buff[i] = _buff[i + 1];
    }
    _buff[9] = m;
    sum += _buff[9];
    i = sum / 10.0;
    return i;
  }
}

void setup() {
  	delay(1000);

  	Serial.begin(115200);	
    lcd.init();
    lcd.backlight();
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Connecting WiFi");
    lcd.setCursor(0, 1);

//Connecting to wifi
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
    while(WiFi.status() != WL_CONNECTED){
        Serial.print("*");
        lcd.print("*");
        delay(500);
    }


    Serial.println("\nConnected to the WiFi network");
    Serial.print("Local ESP32 IP: ");
    Serial.println(WiFi.localIP());
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("WiFi Connected!");
    delay(2000);
    lcd.clear();

    ThingSpeak.begin(client);
    dht.begin();
	  bmp.begin(0x77);

    pinMode(iled, OUTPUT);
    digitalWrite(iled, LOW); 
}

void loop() {

//Read values from the sensors:
	pressure = (bmp.readPressure()/1000);
	altimeter = bmp.readAltitude(1013); 
  hum = dht.readHumidity();


//Display error when sensors aren't sending data
  if (isnan(hum) || isnan(temp_F) || isnan(altimeter) || isnan(pressure)) {
    Serial.println(F("Error Reading Sensor"));
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("ERROR!");
    return;
  }

  digitalWrite(iled, HIGH);
  delayMicroseconds(280);
  adcvalue = analogRead(vout);
  digitalWrite(iled, LOW);
  adcvalue = Filter(adcvalue);
  voltage = (3.3 / 4095) * adcvalue;

  if(voltage >= NO_DUST_VOLTAGE) {
    voltage -= NO_DUST_VOLTAGE;  
    dustDensity = (voltage * COV_RATIO) * (10000);
  }
  else
    dustDensity = 0;

  char *AQILevel[] = {"I","II","III","IV","V","VI"};
  int i = 0;

  if(dustDensity <= 35){
    i = 0;
  }
  if((35 < dustDensity) && (dustDensity <= 75)){
    i = 1;

  }
  if((75 < dustDensity) && (dustDensity <= 115)){
    i = 2;
    
  }
  if((115 < dustDensity) && (dustDensity <= 150)){
    i = 3;
    
  }
  if((150 < dustDensity) && (dustDensity <= 250)){
    i = 4;
    
  }
  if((250 < dustDensity) && (dustDensity <= 500)){
    i = 5;
    
  }

  V_out = (3.0/4095) * therm_adcValue;
  V_in = 5;
  therm_adcValue = analogRead(thermPin);
  R1 = 13180;
  Rt = V_out * (R1/(V_in - V_out));

  // using Steinhart-Hart equation to calculate temp
  inv_T = A + B * log(Rt) + C * pow(log(Rt), 3);
  temp_C = 1.0 / inv_T - 273.15;
  temp_F = temp_C * 9.0 / 5.0 + 32.0;

//Print values to serial monitor:
	Serial.print(F("Pressure: "));
  Serial.print(pressure);
  Serial.print(" kPa");
	Serial.print(" | ");
  Serial.print("Altimeter: ");
  Serial.print(altimeter); 
  Serial.print(" m | ");
  Serial.print(F("Humidity: "));
  Serial.print(hum);
  Serial.print(F(" % | Thermistor Temp: "));
  Serial.print(temp_F);
  Serial.print(F(" °F"));
  Serial.print(" | AQI: ");
  Serial.println(AQILevel[i]);



//Display data to lcd
  lcd.setCursor(0, 0);
  lcd.print("Temp: ");
  lcd.print(temp_F);
  lcd.print(" F");
  lcd.setCursor(0, 1);
  lcd.print("Hum: ");
  lcd.print(hum);
  lcd.print(" %");

  delay(2000);
  lcd.clear();

  lcd.setCursor(0, 0);
  lcd.print("Atm: ");
  lcd.print(pressure);
  lcd.print(" kPa");
  lcd.setCursor(0, 1);
  lcd.print("Altitude: ");
  lcd.print(altimeter);
  lcd.print(" m");

  delay(2000);
  lcd.clear();

  lcd.setCursor(0, 0);
  lcd.print("AQI: ");
  lcd.print(AQILevel[i]);
  

  delay(2000);
  lcd.clear();

//Write values to thinkspeak fields
  ThingSpeak.setField( 1, pressure);
  ThingSpeak.setField( 2, temp_F);
  ThingSpeak.setField( 3, altimeter); 
  ThingSpeak.setField( 4, hum );
  ThingSpeak.setField( 5, dustDensity);
  ThingSpeak.writeFields(myChannelNumber,myWriteAPIKey);

}
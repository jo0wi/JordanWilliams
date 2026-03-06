#define EAP_ANONYMOUS_IDENTITY "" 
#define EAP_IDENTITY "**********" 
#define EAP_PASSWORD "**********" //password for eduroam account
#define WPA_PASSWORD "**********" //password for home wifi
//#define USE_EAP
//SSID NAME
#ifdef USE_EAP
  const char* ssid = "**********"; // eduroam SSID
#else
  const char* ssid = "**********"; // home SSID
#endif

//ThingSpeak credentials
#define THINGSPEAK_CHANNEL_NUMBER 2412781
#define THINGSPEAK_WRITE_API_KEY "6R7GOKN3RL45D5RA"
#define EAP_ANONYMOUS_IDENTITY "" 
#define EAP_IDENTITY "jrw22710@uga.edu" 
#define EAP_PASSWORD "Jw200384103!" //password for eduroam account
#define WPA_PASSWORD "5williams5" //password for home wifi
#define USE_EAP
//SSID NAME
#ifdef USE_EAP
  const char* ssid = "eduroam"; // eduroam SSID
#else 
  const char* ssid = "BE4GSUS"; // home SSID
#endif
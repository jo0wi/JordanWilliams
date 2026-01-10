#define EAP_ANONYMOUS_IDENTITY "" 
#define EAP_IDENTITY "jrw22710@uga.edu" 
#define EAP_PASSWORD "Jw200384103!" 
#define WPA_PASSWORD "5williams5" 
#define USE_EAP
//SSID NAME
#ifdef USE_EAP
  const char* ssid = "eduroam"; 
#else 
  const char* ssid = "BE4GSUS"; 
#endif
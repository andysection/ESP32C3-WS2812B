#include <Arduino.h>
#include <iostream>
#include <map>
#include <string>
#include <FastLED.h>
#include <SPIFFS.h>
#include <FS.h>
#include <ArduinoJson.h>

class LEDmodel
{
    public:
        LEDmodel(int red, int green, int blue, float alpha)
        {
            this->red = red;
            this->green = green;
            this->blue = blue;
            this->alpha = alpha;
        }

        int red;
        int green;
        int blue;
        float alpha; 
};

#define LED_PIN 2
#define NUM_LEDS 90
#define row 5
#define column 17
int screen[row * column] = {0};
CRGB leds[NUM_LEDS];
DynamicJsonDocument animationDoc(1024*50);
//当前第几帧
int kCurrentPage = 0;
int screenMap[] = {
        17	,0	,16	,1	,15	,2	,14	,3	,13	,4	,12	,5	,11	,6	,10	,7	,9,
        35	,18	,34	,19	,33	,20	,32	,21	,31	,22	,30	,23	,29	,24	,28	,25	,27,
        53	,36	,52	,37	,51	,38	,50	,39	,49	,40	,48	,41	,47	,42	,46	,43	,45,
        71	,54	,70	,55	,69	,56	,68	,57	,67	,58	,66	,59	,65	,60	,64	,61	,63,
        89	,72	,88	,73	,87	,74	,86	,75	,85	,76	,84	,77	,83	,78	,82	,79	,81
};

void setup() {
  Serial.begin(115200);

  //读取json文件处理
  if (!SPIFFS.begin()) {
    Serial.println("SPIFFS Mount Failed");
    delay(1000);
  }

  File file = SPIFFS.open("/cry.json", "r");
  if (!file) {
    Serial.printf("NO FIle");
  }
  String fileContent = file.readString();
  file.close();
  Serial.println(fileContent);

  //文件数据解析
  deserializeJson(animationDoc, fileContent);

  FastLED.addLeds<WS2812B, LED_PIN, GRB>(leds, NUM_LEDS);
}

void loop() {
  //获取数组
  JsonObject root = animationDoc.as<JsonObject>();
  JsonArray data = root["data"];
  JsonArray frame = data[kCurrentPage]["map"]; 
  int duration = data[kCurrentPage]["duration"];
  for (int i = 0; i < row * column; i++)
  {
    //LED赋值
     if (screen[i] != frame[i]["color"]) {
      int color = frame[i]["color"];
      int red = (color & 0xFF0000) >> 16;
      int green = (color & 0xFF00) >> 8;
      int blue = color & 0xFF;
      int screenIndex = screenMap[i];
      leds[screenIndex].setRGB(red, green, blue);
      // Serial.printf("index %d/%d - %d - %d -%d color %d\n", i, screenIndex, red, green, blue, color);
      screen[i] = frame[i]["color"];
     }
  }
  FastLED.show();
  delay(150);
  kCurrentPage++;
  if (kCurrentPage == data.size()) {
    kCurrentPage = 0;
  }

  // Serial.println(kCurrentPage);
  // Serial.println();
  // Serial.println();
  // Serial.println();
  // Serial.println();
  // Serial.println();

  // leds[1] = CRGB::Brown;
  // leds[1].nscale8(64);
  // FastLED.setBrightness(64);// Set the brightness to 64/255
}
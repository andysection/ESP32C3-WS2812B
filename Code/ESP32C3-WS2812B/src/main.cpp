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
#define NUM_LEDS 60
#define row 5
#define column 17
int screen[row * column] = {0};
CRGB leds[NUM_LEDS];
DynamicJsonDocument animationDoc(1024*100);

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

  //文件数据解析
  deserializeJson(animationDoc, fileContent);

  FastLED.addLeds<WS2812B, LED_PIN, GRB>(leds, NUM_LEDS);
  std::map<int, LEDmodel> maps;
}
//当前第几帧
int kCurrentPage = 0;
void loop() {
  //获取数组
  JsonObject root = animationDoc.as<JsonObject>();
  JsonArray data = root["data"];
  JsonArray frame = data[kCurrentPage]["map"]; 
  int duration = data[kCurrentPage]["duration"];
  for (int i = 0; i < row * column; i++)
  {
    if (screen[i] != frame[i]) {
      //LED赋值
      int color = frame[i];
      int red = (color & 0xFF0000) >> 16;
      int green = (color & 0xFF00) >> 8;
      int blue = color & 0xFF;
      leds[i].setRGB(red, green, blue);
      screen[i] = frame[i];
    }
  }
  delay(duration);
  kCurrentPage++;
  if (kCurrentPage == data.size()) {
    kCurrentPage = 0;
  }

  // leds[1] = CRGB::Brown;
  // leds[1].nscale8(64);
  // FastLED.setBrightness(64);// Set the brightness to 64/255
}
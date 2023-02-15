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
CRGB leds[NUM_LEDS];

void setup() {
  Serial.begin(115200);

  //读取json文件处理
  if (!SPIFFS.begin()) {
    Serial.println("SPIFFS Mount Failed");
    delay(1000);
  }

  File file = SPIFFS.open("/demo1.json", "r");
  if (!file) {
    Serial.printf("NO FIle");
  }
  String fileContent = file.readString();
  file.close();
  Serial.println(fileContent);


  // Serial.print(fileContent);
  DynamicJsonDocument doc(1024*100);
  deserializeJson(doc, fileContent);
  int name = doc["flag"];
  JsonObject root = doc.as<JsonObject>();
  // int count = doc["data"][1]["duration"];
  JsonArray arr = root["data"]; 
  // Serial.println(arr);
  JsonObject obj = arr[0];
  // Serial.println(obj);
  JsonArray map = obj["map"];
  int count1 = obj["duration"];
  int color = arr[2]["map"][0]["color"];
  JsonObject objColor = map[1];
  int color1 = objColor["color"];
  Serial.printf("duration - %d\n", count1);
  Serial.printf("color - %d\n", color);
  Serial.printf("color1 - %d\n", color1);
  Serial.printf("map count - %d\n", map.size());
  Serial.printf("data count - %d\n", arr.size());

  FastLED.addLeds<WS2812B, LED_PIN, GRB>(leds, NUM_LEDS);
  std::map<int, LEDmodel> maps;
}

void loop() {
  for (int i = 0; i < NUM_LEDS; i++) {
    leds[i].setRGB(random(255), random(255), random(255));
    if (i > 8) {
      leds[i-8].setRGB(random(255), random(255), random(255));
    }
    if (i > 16) {
      leds[i-16].setRGB(random(255), random(255), random(255));
    }
    leds[i-1].setRGB(random(0), random(0), random(0));
    FastLED.show();
    delay(100);
    Serial.println("run");
  }

  // leds[1] = CRGB::Brown;
  // leds[1].nscale8(64);
  // FastLED.setBrightness(64);// Set the brightness to 64/255
}
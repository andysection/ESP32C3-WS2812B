#include <Arduino.h>
#include <iostream>
#include <map>
#include <string>
#include <FastLED.h>

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
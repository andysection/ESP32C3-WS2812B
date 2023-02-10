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

#define LED_PIN 4
#define NUM_LEDS 90
CRGB leds[NUM_LEDS];

void setup() {
  FastLED.addLeds<WS2812B, LED_PIN, GRB>(leds, NUM_LEDS);
  std::map<int, LEDmodel> maps;
}

void loop() {
  leds[1] = CRGB::Brown;
  leds[1].nscale8(64);
  FastLED.setBrightness(64);// Set the brightness to 64/255
}
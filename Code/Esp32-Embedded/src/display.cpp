#include <Arduino.h>
#include <TFT_eSPI.h>


void createBlendTable(uint16_t blendTable[256][256]) {
  for (int a = 0; a < 256; a++) {
    for (int c1 = 0; c1 < 256; c1++) {
      for (int c2 = 0; c2 < 256; c2++) {
        blendTable[a][256*c1 + c2] = ((c1*a + c2*(255-a)) >> 8);
      }
    }
  }
}
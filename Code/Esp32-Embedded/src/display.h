#include <Arduino.h>
#include <TFT_eSPI.h>

void drawThickLine(TFT_eSprite *sprite, int x0, int y0, int x1, int y1, uint16_t color, int thickness);

void initDisplay();

void drawWatchFaces(int watchface, int& degrees, int& altitude, int& steps, int& kcal, int& kcalGoal, int& seconds, int& minutes, int& hours, double (&sleep1)[12], int date);

void drawStats(int (&values)[50], int& avg);

void drawHeartRate(int (&values)[50], int &avg);
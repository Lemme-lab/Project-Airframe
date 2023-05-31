#include <Arduino.h>
#include <TFT_eSPI.h>

void drawThickLine(TFT_eSprite *sprite, int x0, int y0, int x1, int y1, uint16_t color, int thickness);

void initDisplay();

void drawWatchFaces(int watchface, int& degrees, int& altitude, int& steps, int& kcal, int& kcalGoal, int& seconds, int& minutes, int& hours, double (&sleep1)[12], int date);

void drawThickLineWithRoundedCorners(TFT_eSprite *img, int x0, int y0, int x1, int y1, uint32_t color, int thickness, int radius);

void drawHeartRate(int (&values)[50], int &avg, int max, int min);

void drawOxyLevels(int (&values)[50], int &avg, int max, int min);

void drawECGLevels(int (&values)[50], int &avg, int max, int min);

void drawStats(int (&heartRate)[50], int& Heartavg, int& Heartmax, int& Heartmin, int (&OxyRate)[50],int& Oxyavg, int& Oxymax, int& Oxymin,int (&ECGValues)[50],  int counter);

void drawInfos(String watch_type, double hardware_version, String sensors, String soc, String ram, String flash, String wireless, String software_version, String last_update);

void displaySleepingData(double (&sleep)[12], double (&sleepquality)[12]);

enum SwipeDirection {
    SWIPE_LEFT,
    SWIPE_RIGHT,
    NO_SWIPE
};

SwipeDirection checkSwipeDirection(int startX, int startY, int endX, int endY);

bool isDisplayPressed(int touchX, int touchY);

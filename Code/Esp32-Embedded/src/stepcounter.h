
#include <tuple>
#include <cmath>

class StepCounter {
public:
    int calculateSteps(std::tuple<double, double> gps, std::tuple<double, double, double> acceleration, int heartRate);

private:
    int totalSteps = 0;
    double prevLatitude = 0.0;
    double prevLongitude = 0.0;

    bool isStep(double, double, double, int);
};


class StepCounter1 {
    public:
        StepCounter1(): counter(0), threshold(1.2), min_interval(0.2), last_step_time(0) {}

    int update(float acceleration[3], int heart_beat, long current_time, bool& flag);

    private:
    int counter;
    double threshold;
    long min_interval;
    long last_step_time;
};

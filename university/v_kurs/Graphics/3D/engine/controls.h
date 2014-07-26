#ifndef CONTROLS
#define CONTROLS

void initControlFuncs();

// Keyboard
void pressKey_s(int key, int x, int y);
void releaseKey_s(int key, int x, int y);
void pressKey(unsigned char key, int x, int y);
void releaseKey(unsigned char key, int x, int y);

// Mouse
void mousePressed(int button, int state, int x, int y);
void mousePressedMove(int x, int y);
void mouseMove(int x, int y);

#include "controls.cpp"

#endif
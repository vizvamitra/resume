void initControlFuncs(){
  // Keyboard
  glutIgnoreKeyRepeat(true);
  glutSpecialFunc(pressKey_s);
  glutSpecialUpFunc(releaseKey_s);
  glutKeyboardFunc(pressKey);
  glutKeyboardUpFunc(releaseKey);

  // Mouse
  glutMouseFunc(mousePressed);
  glutMotionFunc(mousePressedMove);
  glutPassiveMotionFunc(mouseMove);
}

void pressKey_s(int key, int x, int y){
  switch(key){
    case GLUT_KEY_RIGHT:events[Right] = true; break;
    case GLUT_KEY_LEFT: events[Left] = true; break;
    case GLUT_KEY_UP:   events[Up] = true; break;
    case GLUT_KEY_DOWN: events[Down] = true; break;
    case 114 /*Ctrl*/:  events[Ctrl] = true; break;
    case 112 /*Shift*/: events[Shift] = true; break;
    default: std::cerr << "No action yet for special key '" << key << "'" << std::endl;
  }
}

void releaseKey_s(int key, int x, int y){
  switch(key){
    case GLUT_KEY_RIGHT:events[Right] = false; break;
    case GLUT_KEY_LEFT: events[Left] = false; break;
    case GLUT_KEY_UP:   events[Up] = false; break;
    case GLUT_KEY_DOWN: events[Down] = false; break;
    case 114 /*Ctrl*/:  events[Ctrl] = false; break;
    case 112 /*Shift*/: events[Shift] = false; break;
  }
}

void pressKey(unsigned char key, int x, int y){
  switch(key){
    case (unsigned char)27: // ESC
      glutDestroyWindow(1);
      exit(0);
    case 'r':
      p.reset();
      camera.reset();
      light.reset();
      mesh->reset();
      glutPostRedisplay();
      break;
    // controll keys
    case '+': events[Plus] = true; break;
    case '-': events[Minus] = true; break;
    case 'w': events[W] = true; break;
    case 's': events[S] = true; break;
    case 'a': events[A] = true; break;
    case 'd': events[D] = true; break;
    case ' ': events[Space] = true; break;
    case '[': events[OpenBracket] = true; break;
    case ']': events[CloseBracket] = true; break;
    case ';': events[Semicolon] = true; break;
    case '\'':events[SingleQuote] = true; break;
    default: std::cerr << "No action yet for key '" << key << "'" << std::endl;
  }
}

void releaseKey(unsigned char key, int x, int y){
  switch(key){
    case '+': events[Plus] = false; break;
    case '-': events[Minus] = false; break;
    case 'w': events[W] = false; break;
    case 's': events[S] = false; break;
    case 'a': events[A] = false; break;
    case 'd': events[D] = false; break;
    case ' ': events[Space] = false; break;
    case '[': events[OpenBracket] = false; break;
    case ']': events[CloseBracket] = false; break;
    case ';': events[Semicolon] = false; break;
    case '\'':events[SingleQuote] = false; break;
  }
}

void mousePressed(int button, int state, int x, int y){}

void mousePressedMove(int x, int y){}

void mouseMove(int x, int y){
  camera.onMouseMove(x, y);
}
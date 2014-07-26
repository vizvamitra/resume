#include <iostream>
#include <fstream>
#include <iomanip>
#include <unistd.h>
using namespace std;

int main (int args, char **argv ){
	if (args!=5){
		cout<< "ERROR: wrong parameters\n";
		cout<< "USAGE: lab3-2 has 4 parameters:\n\
			full_lab3_filename\n\
			parent_out_filename\n\
			filename_for_lab3_parent\n\
			filename_for_lab3_child\n";
		return 1;
	}
	
	ofstream hOut1(argv[2],ofstream::out);
	if (!hOut1){
		cout<< "ERROR: failed opening/creating parent output file\n";
		return 2;
	}
	int pid = fork();
	if (pid <0){
		cout<< "ERROR: can't create child process\n";
		return 2;
	}
/************PARENT PROCESS***************/
	if (pid >0){
		hOut1.setf(ios::left);
		hOut1<< setw(8) << "PID:" << getpid() << endl;
		hOut1<< setw(8) << "ChPID" << pid << endl;
		hOut1<< setw(8) << "PGRP:" << getpgrp() << endl;
		hOut1<< setw(8) << "UID:" << getuid() << endl;
		hOut1<< setw(8) << "EUID:" << geteuid() << endl;
		hOut1<< setw(8) << "GID:" << getgid() << endl;
		hOut1<< setw(8) << "EGID:" << getegid() << endl;
		hOut1<< setw(8) << "TERMID:" << ctermid(0) << endl;
		hOut1.close();
	} else {
/*****************************************/
/************CHILD PROCESS****************/
		execl(argv[1], argv[1], argv[3], argv[4], (char*)0);
	}
/*****************************************/
	return 0;
}

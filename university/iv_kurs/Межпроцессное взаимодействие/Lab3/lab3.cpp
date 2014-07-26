#include <iostream>
#include <fstream>
#include <iomanip>
#include <unistd.h>
using namespace std;

int main(int argc, char **argv){
	if (argc!=3){
		cout<< "ERROR: You should specify two output files\n";
		return 1;
	}
	int pid = fork();
	if (pid <0){
		cout<< "ERROR: can't create child process\n";
		return 2;
	}
/************PARENT PROCESS***************/
	if (pid > 0){
		ofstream hOutParent (argv[1],ofstream::out);
		if (!hOutParent){
			cout<< "ERROR: failed opening/creating parent output file\n";
			return 3;
		}
		hOutParent.setf(ios::left);
		hOutParent<< setw(8) << "PID:" << getpid() << endl;
                hOutParent<< setw(8) << "ChPID:" << pid << endl;
                hOutParent<< setw(8) << "PGRP:" << getpgrp() << endl;
                hOutParent<< setw(8) << "UID:" << getuid() << endl;
                hOutParent<< setw(8) << "EUID:" << geteuid() << endl;
                hOutParent<< setw(8) << "GID:" << getgid() << endl;
                hOutParent<< setw(8) << "EGID:" << getegid() << endl;
                hOutParent<< setw(8) << "TERMID:" << ctermid(0) << endl;
		hOutParent.close();
	} else {
/*****************************************/
/************CHILD PROCESS****************/
		ofstream hOutChild (argv[2],ofstream::out);
		if (!hOutChild){
			cout<< "ERROR: failed opening/creating child output file\n";
			return 4;
		}
		hOutChild.setf(ios::left);
		hOutChild<< setw(8) << "PID:" << getpid() << endl;
		hOutChild<< setw(8) << "PPID:" << getppid() << endl;
		hOutChild<< setw(8) << "PGRP:" << getpgrp() << endl;
		hOutChild<< setw(8) << "UID:" << getuid() << endl;
		hOutChild<< setw(8) << "EUID:" << geteuid() << endl;
		hOutChild<< setw(8) << "GID:" << getgid() << endl;
		hOutChild<< setw(8) << "EGID:" << getegid() << endl;
		hOutChild<< setw(8) << "TERMID:" << ctermid(0) << endl;
		hOutChild.close();
	}
/****************************************/
	return 0;
}

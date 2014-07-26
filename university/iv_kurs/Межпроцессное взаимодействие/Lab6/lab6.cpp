#include <iostream>
#include <fstream>
#include <sys/msg.h>
#include <signal.h>
#include <unistd.h>
using namespace std;
int count = 2;

void finished(int){
	count--;
}
int main(int args, char* arga[]){
	if (args<3){
		cout<<"ERROR: 2 input files must be specified\n";
		return 1;
	}
	int fildes[2];
	if (pipe(fildes)==(-1)){
		cout<<"ERROR: can't open pipe\n";
		return 2;
	}
	signal(SIGUSR1,finished);
	int child1 = fork();
	if (child1 < 0){
		cout<< "ERROR: can't create child process 1\n";
		return 3;
	}
	/********************Child1********************/
	if (child1 == 0){
		close(fildes[0]);
		ifstream input1 (arga[1], ifstream::in);
		if (!input1){
			cout<<"ERROR: wrong input file\n";
			return 4;
		}
		char buf1;
		while(input1.good()){
			buf1=input1.get();
			write(fildes[1], &buf1, sizeof(char));
		}
		close(fildes[1]);
		kill(getppid(),SIGUSR1);
	} else {
	/**********************************************/
		int child2 = fork();
		if (child2 < 0){
			cout<< "ERROR: can't create child process 2\n";
			return 3;
		}
		/*******************Child2********************/
		if (child2 == 0){
			close(fildes[0]);
			ifstream input2 (arga[2], ifstream::in);
                	if (!input2){
				cout<<"ERROR: wrong input file\n";
				return 4;
			}
			char buf2;
			while(input2.good()){
				buf2=input2.get();
				write(fildes[1], &buf2, sizeof(char));
			}
			close(fildes[1]);
			kill(getppid(),SIGUSR1);
	/********************************************/
		} else {
	/*******************Parent*******************/
			close(fildes[1]);
			char buf;
			while (read(fildes[0],&buf,sizeof(char))){
				cout<<buf;
			}
			close(fildes[0]);
			cout<<endl;
			return 0;
		}
	}
}

#include <iostream>
#include <sys/wait.h>
#include <unistd.h>
using namespace std;

int main(){
	int child1 = fork();
	if (child1 < 0){
		cout<< "ERROR: can't create child process 1\n";
		return 1;
	}
	/*****Child1*******/
	if (child1 == 0){ //
		sleep(3);//
		return 3; //
	} else {	  //
	/******************/
		int child2 = fork();
		if (child2 < 0){
			cout<< "ERROR: can't create child process 2\n";
			return 2;
		}
		/*****Child2*******/
		if (child2 == 0){ //
			sleep(7); //
			return 7; //
		} else {	  //
		/******************/
		/******Parent******/
			sleep(5);
			int status1 = 0;
			int status2 = 0;
			int pid1 = waitpid(child1, &status1, WNOHANG);
			int pid2 = waitpid(child2, &status2, WNOHANG);
			cout<<"Child "<<child1;
			switch (pid1) {
				case 0: cout<<" still working\n";break;
				default: cout<<" has ended\n";
			}
			cout<<"Child "<<child2;
			switch (pid2){
				case 0: cout<<" still working\n";break;
				default: cout<<" has ended\n";
			}
		}
	}
}

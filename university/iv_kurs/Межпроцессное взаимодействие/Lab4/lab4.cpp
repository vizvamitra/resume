#include <iostream>
#include <unistd.h>
#include <sys/wait.h>
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
			sleep(5);//
			return 5; //
		} else {	  //
		/******************/	
		/******Parent******/
			int status;
			int pid1 = wait(&status);
			cout<<"Child "<<pid1<<" slept "<<WEXITSTATUS(status)<<" seconds\n";
			int pid2 = wait(&status);
			cout<<"Child "<<pid2<<" slept "<<WEXITSTATUS(status)<<" seconds\n";
			return 0;
		}
	}
}

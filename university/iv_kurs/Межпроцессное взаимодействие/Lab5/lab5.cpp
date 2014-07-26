#include <iostream>
#include <unistd.h>
#include <signal.h>
#include <sys/time.h>
#include <stdlib.h>
using namespace std;

void react1(int){
	cout<<getpid()<<" (child1) is sending SIGALRM to parent process "<<getppid()<<endl;
	kill(getppid(), SIGALRM);
}

void react2(int sig, siginfo_t *siginfo, void*){
	cout<<getpid()<<" (child2) recived "<<sig<<" (SIGALRM) from "<<siginfo->si_pid<<" (himself)\n";
}

void react3(int sig, siginfo_t *siginfo, void* useless){
	cout<<getpid()<<" recived "<<sig<<" (SIGALRM) from "<<siginfo->si_pid<<" (child1)\n";
}

void CtrlC(int){
	cout<<"\nRecieved SIGINT (Ctrl+C). Will now exit\n";
	exit(0);
}

int main(){
	int child1 = fork();
	if (child1 < 0){
		cout<< "ERROR: can't create child process 1\n";
		return 1;
	}
	/********************Child1********************/
	if (child1 == 0){
		struct sigaction act1;
		act1.sa_handler = react1;
		sigemptyset(&(act1.sa_mask));
		act1.sa_flags = 0;
		sigaction(SIGALRM, &act1, 0);
		struct itimerval val, oval;
		val.it_interval.tv_sec = 3;
		val.it_interval.tv_usec = 0;
		val.it_value.tv_sec = 3;
		val.it_value.tv_usec = 0;
		setitimer(ITIMER_REAL, &val, &oval);
		cout<< "To stop child1 press Ctrl+c\n";
		while(1){}
	} else {
	/**********************************************/
		int child2 = fork();
		if (child2 < 0){
			cout<< "ERROR: can't create child process 2\n";
			return 2;
		}
		/*******************Child2********************/
		if (child2 == 0){
			sigset_t mask;
			sigemptyset(&mask);
			sigaddset(&mask, SIGINT);
			sigprocmask(SIG_BLOCK, &mask,0);
			struct sigaction act2;
			act2.sa_sigaction = &react2;
			sigemptyset(&(act2.sa_mask));
			act2.sa_flags = SA_SIGINFO;
			sigaction(SIGALRM, &act2, 0);
			int numSIG=5;
			for (int i=0; i<numSIG; i++){
				sleep(1);
				raise(SIGALRM);
			}
			cout<<getpid()<<" (child2) finished\n";
		} else {
		/*********************************************/	
		/*******************Parent*******************/
			struct sigaction act3;
			act3.sa_sigaction = react3;
			sigemptyset(&(act3.sa_mask));
			act3.sa_flags = SA_SIGINFO;
			sigaction(SIGALRM, &act3, 0);
			signal(SIGINT, CtrlC);
			while(1){}
		}
	}
}

#include <iostream>
#include <fstream>
#include <cstdlib>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <unistd.h>
using namespace std;

union semun {
	int val; 
	struct semid_ds *buf;
	unsigned short  *array;  
	struct seminfo  *__buf;
};

int main(int args, char **argv){
	if (args<2){
		cout<< "ERROR: delay must be specified\n";
		return 1;
	}
	int delay = atoi(argv[1]);
	int shmDatID = shmget(1000, 4*sizeof(char), 0666|IPC_CREAT);
	int shmDoneID = shmget(1100, sizeof(int), 0666|IPC_CREAT);
	if ((shmDatID == -1) || (shmDoneID == -1)){
		cout<< "ERROR: can't get shared memory\n";
		return 2;
	}
	char *shmDatAddr = (char*)shmat(shmDatID, 0, 0);
	char *shmDoneAddr = (char*)shmat(shmDoneID, 0, 0);
	*shmDoneAddr = 0;
	int semID = semget(1200,3,0666|IPC_CREAT);
	if (semID == -1){
		cout<< "ERROR: can't create semaphore\n";
		return 4;
	}
	sembuf 	opEnterExcl = {0,-1,0},
			opLeaveExcl = {0,1,0},
			opReadChar[2] = {{2,-1,0}, {1,1,0}},
			opChkEmpty = {2,0,IPC_NOWAIT};
	int ptrn=0;
	while(*shmDoneAddr != 1){
		if (semop(semID, &opChkEmpty, 1) != 0){
			semop(semID, &opEnterExcl, 1);
			semop(semID, opReadChar, 2);
			cout<< *(shmDatAddr+ptrn)<<endl;
			if (ptrn==4) ptrn=0;
				else ptrn++;
			semop(semID, &opLeaveExcl, 1);
		} else {
			cout<<"Buffer is empty\n";
		}
		sleep (delay);
	}
	cout<< "Consumer has finished\n";
	*shmDoneAddr = 2;
	shmdt(shmDatAddr);
	shmdt(shmDoneAddr);
	return 0;
}

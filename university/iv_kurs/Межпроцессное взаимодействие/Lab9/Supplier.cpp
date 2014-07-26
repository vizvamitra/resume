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
	if (args<3){
		cout<< "ERROR: filename and delay must be specified\n";
		return 1;
	}
	ifstream hInput(argv[1], fstream::in);
	if (!hInput){
		cout<< "ERROR: can't open input file\n";
		return 2;
	}
	int delay = atoi(argv[2]);
	int shmDatID = shmget(1000, 4*sizeof(char), 0666|IPC_CREAT);
	int shmDoneID = shmget(1100, sizeof(int), 0666|IPC_CREAT);
	if ((shmDatID == -1) || (shmDoneID == -1)){
		cout<< "ERROR: can't get shared memory\n";
		return 3;
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
			opWriteChar[2] = {{1,-1,0}, {2,1,0}},
			opChkEmpty = {2,0},
			opChkFull = {1,0,IPC_NOWAIT};
	semun semControl;
	unsigned short arr[3] = {1,4,0};
	semControl.array = arr;
	semctl (semID, 0, SETALL, semControl);
	char ch;
	int ptrn=0;
	while(hInput.good()){
		if (semop(semID, &opChkFull, 1) != 0){
			semop(semID, &opEnterExcl, 1);
		 	ch = hInput.get();
			if (ch == EOF) {
				semop(semID, &opLeaveExcl, 1);
				break;
			}
			semop(semID, opWriteChar, 2);
			*(shmDatAddr+ptrn) = ch;
			if (ptrn==4) ptrn=0;
				else ptrn++;
			semop(semID, &opLeaveExcl, 1);
		} else {
			cout<<"Buffer is full\n";
		}
		sleep (delay);
	}
	semop(semID, &opChkEmpty, 1);
	cout<< "Supplier has finished\n";
	*shmDoneAddr = 1;
	while(*shmDoneAddr!=2){}
	semctl(semID, 0, IPC_RMID, 0);
	shmdt(shmDatAddr);
	shmdt(shmDoneAddr);
	shmctl(shmDatID, IPC_RMID, 0);
	shmctl(shmDoneID, IPC_RMID, 0);
	return 0;
}

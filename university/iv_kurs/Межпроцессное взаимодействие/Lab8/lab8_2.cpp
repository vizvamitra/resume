#include <iostream>
#include <sys/shm.h>
#include <sys/ipc.h>
#include <stdlib.h>
#define DATA_SHM_SIZE 32
#define SYNC_SHM_SIZE 4

using namespace std;

int main(int argc, char* arga[]){
	if (argc != 2){
		cout<<"ERROR: number of iterations must be specified\n";
		cout<<"USAGE: \"lab8_2 10\"\n";
		return 3;
	}
	int iters = atoi(arga[1]);
	if (!iters){
		cout<< "ERROR: argument must be integer\n";
		return 4;
	};
	int shm1_id, shm2_id;
	shm1_id = shmget(1200, DATA_SHM_SIZE, 0666|IPC_CREAT);
	shm2_id = shmget(1000, SYNC_SHM_SIZE, 0666|IPC_CREAT);
	if ( (shm1_id == -1) || (shm2_id == -1) ){
		cout<< "ERROR: can't get shared memory IDs\n";
		return 1;
	}
	void *shm1_addr, *shm2_addr;
	shm1_addr = shmat(shm1_id, 0, 0);
	shm2_addr = shmat(shm2_id, 0, 0);
	if ( (shm1_addr == (void*)-1) || (shm2_addr == (void*)-1) ){
		cout<< "ERROR: can't attach shared memory\n";
		return 2;
	}
	int *pshm2 = (int*)shm2_addr;
	*pshm2 = 0;
	while (iters > 0){
		if(*pshm2 == 1){
			*pshm2 = 2;
			int buff, *pnext, *pshm1;
			for (int i=0; i<DATA_SHM_SIZE/4-1; i++){
				pshm1 = (int*)shm1_addr;
				pnext = pshm1;
				for (int j=0; j<(DATA_SHM_SIZE/4-i-1); j++){
					pnext++;
					if(*pshm1 < *pnext){
						buff = *pshm1;
						*pshm1 = *pnext;
						*pnext = buff;
					}
					pshm1++;
				}
			}
			pshm1 = (int*)shm1_addr;
			for (int i=0; i<DATA_SHM_SIZE/4; i++){
				cout<< *pshm1 << " ";
				pshm1++;
			}
			cout<< endl;
			*pshm2 = 3;
			iters--;
		}
	}
	*pshm2 = 4;
	shmdt(shm2_addr);
	shmdt(shm1_addr);
	cout<< "Finished\n";
	return 0;
}


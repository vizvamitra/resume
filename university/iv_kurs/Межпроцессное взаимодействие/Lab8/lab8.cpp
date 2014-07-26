#include <iostream>
#include <sys/shm.h>
#include <sys/ipc.h>
#include <stdlib.h>
#define DATA_SHM_SIZE 32
#define SYNC_SHM_SIZE 4

using namespace std;

int main(){
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
	int *pshm1 = (int*)shm1_addr;
	int *pshm2 = (int*)shm2_addr;
	*pshm2 = 0;
	while (*pshm2 != 4){
		switch(*pshm2){
			case 0:	pshm1 = (int*)shm1_addr;
					for (int i=0; i<DATA_SHM_SIZE/4; i++){
						*pshm1 = rand() % 20;
						cout<< *pshm1 << " ";
						pshm1++;
				    }
					cout<< endl;
					*pshm2 = 1;
					break;
			case 3:	*pshm2 = 0; 
					break;
		}
	}
	cout<< "Finished\n";
	shmdt(shm1_addr);
	shmdt(shm2_addr);
	shmctl(shm1_id, IPC_RMID, 0);
	shmctl(shm2_id, IPC_RMID, 0);
	return 0;
}

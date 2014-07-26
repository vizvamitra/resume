#include <iostream>
#include <unistd.h>
#include <sys/msg.h>
#include <signal.h>
#include <sys/ipc.h>
#include <sys/types.h>
#include <time.h>

#define SERVER_KEY 122 
#define MSG_INIT 1
#define MSG_TIME 2

using namespace std;

struct msgIdent{
	long mtype;
	int pid;
	int portID;
};
struct msgTime{
	long mtype;
	time_t time;
	int serverPID;
};

int portID;

void stop(int){
	msgctl(portID, IPC_RMID, 0);
	raise(SIGKILL);
}

int main(){
	signal(SIGINT,stop);
	signal(SIGKILL,stop);
	cout<<"Opening port...";
	portID = msgget(SERVER_KEY,(IPC_CREAT|IPC_EXCL|0622));//server can read, others can write
	if (portID == -1){
		cout<<"ERROR: can't open port\n";
		return 1;
	}
	cout<<"done. Port ID: "<<portID<<endl;
	int status;
	struct msgIdent msg;
	cout<<"Waiting for clients...\n";
	while(1){
		status = msgrcv(portID, &msg, sizeof(msgIdent),MSG_INIT,0);
		if (status!=sizeof(msgIdent)){
			cout<<"ERROR: can't read init message\n";
			msgctl(portID, IPC_RMID,0);
			return 2;
		} else {
			cout<<"Client "<<msg.pid<<" connected on port "<<msg.portID<<endl;
			struct msgTime response = {MSG_TIME,time(NULL),getpid()};
			status = msgsnd(msg.portID, &response, sizeof(msgTime), 0);
			if (status != 0){
				cout<<"ERROR: can't send response message\n";
				msgctl(portID, IPC_RMID,0);
				return 3;
			}
			cout<<"Response successfully sent to "<<msg.pid<<endl;
		}
	}
}

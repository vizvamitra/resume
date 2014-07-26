#include <iostream>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>
#include <sys/msg.h>
#include <sys/ipc.h>
#include <string.h>

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
	cout<<endl;
	//raise(SIGKILL);
	exit(0);
}

int main(int argc, char *argv[]){
	signal(SIGINT,stop);
	signal(SIGKILL,stop);
	cout<< "\nRequesting port...";
	portID=msgget(IPC_PRIVATE, 0622);
	if(portID<=0){
		cout<<"ERROR: can't open port\n";
		msgctl(portID, IPC_RMID, 0);
		return 1;
	}
	cout<<"done. Port ID: "<<portID<<endl;
	cout<<"Establishing connection to server...";
	int serverID = msgget(SERVER_KEY,IPC_CREAT);
	if (serverID<=0){
		cout<<"ERROR: can't find server\n";
		msgctl(portID, IPC_RMID, 0);
		return 2;
	}
	cout<<"done. Server found at port "<<serverID<<endl;
	cout<<"Sending identification inpormation...";
	struct msgIdent ident = {MSG_INIT, getpid(), portID};
	int status = msgsnd(serverID, &ident, sizeof(msgIdent), 0);
	if (status == -1){
		cout<<"ERROR: can't send identification information\n";
		msgctl(portID, IPC_RMID, 0);
		return 3;
	}
	cout<<"done.\n";
	cout<<"Waiting for server response...";
	struct msgTime response;
	status = msgrcv(portID, &response, sizeof(msgTime),MSG_TIME, 0);
	if (status != sizeof(msgTime)){
		cout<<"ERROR: can't get server response\n";
                msgctl(portID, IPC_RMID, 0);
                return 4;
	}
	cout<<"done.\n";
	struct tm *timeInfo= localtime(&response.time);
	char buffer[30];
	strftime (buffer,30,"%a, %d %b %Y, %H:%M:%S",timeInfo);
	cout<<"Current date and time: "<<buffer<<endl;
	if (argc==2 && !strcmp(argv[1],"-kill")){
		cout<<"Shuting down server...";
		kill(response.serverPID, SIGINT);
		cout<<"done\n";
	}
	stop(0);
}

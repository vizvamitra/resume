#include <iostream>
#include <iomanip>
#include <mpi.h>
#include <windows.h>
#include <vector>
#include <conio.h>
#pragma comment (lib, "cvwmpi.lib")

const int TASK_INFO_MSG_TAG	= 0x80000001;
const int TASK_DATA_MSG_TAG	= 0x80000002;
const int RESULT_MSG_TAG	= 0x80000003;
const int END_MSG_TAG		= 0x80000004;


using namespace std;

void PrintRus(char* string){	// Функция для вывода русского языка
	char ansiBuf[100];
	AnsiToOem(string,ansiBuf);
	cout<<ansiBuf;
}

inline void VerifyMPI(int iRes){
	if(iRes != MPI_SUCCESS){
		cout << "Error occurred: 0x";
		cout << setw(8) << hex << setfill('0') << iRes << endl;
		exit(0);
	}
}

int GetData(int *vars, int &value){
	PrintRus("Введите 6 натуральных чисел через пробел: ");
	cin >> vars[0] >> vars[1] >> vars[2] >> vars[3] >> vars[4] >> vars[5];
	PrintRus("Введите y: ");
	cin >> value;
	return 0;
}

int SendTasks(int vars[], int value, int groupSize){
	int taskSize1 = 1024 / (groupSize-1);
	int taskSize2 = taskSize1+1;
	int twoGroups = 1024 % (groupSize-1);
	int current = 0;
	for (int i=1; i<groupSize; i++){
		int last = current + (i-1 >= twoGroups ? taskSize1 : taskSize2);
		int arrTaskInfo[3] = {value, current, last};
		VerifyMPI(MPI_Send(arrTaskInfo, 3, MPI_INT, i, TASK_INFO_MSG_TAG, MPI_COMM_WORLD));
		VerifyMPI(MPI_Send(vars, 6, MPI_INT, i, TASK_DATA_MSG_TAG, MPI_COMM_WORLD));
		current = last;
	}
	return 0;
}

int SendData(int s1, int s2, int s3, int s4, int s5){
	int result = s1*256 + s2*64 + s3*16 + s4*4 + s5;
	VerifyMPI(MPI_Send(&result, 1, MPI_INT, 0, RESULT_MSG_TAG, MPI_COMM_WORLD));
	return 0;
}

int SendEnd(){
	VerifyMPI(MPI_Send(NULL, 0, MPI_INT, 0, END_MSG_TAG, MPI_COMM_WORLD));
	return 0;
}

char* IntToSign(int sign){
	switch (sign){
		case 0: return " + ";
		case 1: return " - ";
		case 2: return " * ";
		case 3: return " / ";
		default: return "";
	}
}

int PrintData(vector<int> results, int vars[], int val){
	PrintRus("Полученные решения:\n");
	if (results.size() == 0){
		PrintRus("Решений нет\n");
		return 0;
	}
	int s1, s2, s3, s4, s5;
	for (int i=0; i<results.size(); i++){
		s5 =   results[i] & 3   /*0000000011*/;
		s4 = ( results[i] & 12  /*0000001100*/ ) >> 2;
		s3 = ( results[i] & 48  /*0000110000*/ ) >> 4;
		s2 = ( results[i] & 192 /*0011000000*/ ) >> 6;
		s1 = ( results[i] & 768 /*1100000000*/ ) >> 8;
		cout << "((((" << vars[0] << IntToSign(s1) << vars[1] << ")" << IntToSign(s2) << vars[2] << ")"\
			<< IntToSign(s3) << vars[3] << ")" << IntToSign(s4) << vars[4] << ")" << IntToSign(s5) << vars[5]\
				<< " = " << val << endl;
	}
	return 0;
}

int MasterProcess(int groupSize){
	if(groupSize < 2){
		PrintRus("Нет подчинённых процессов.\n");
		exit(0);
	}
	PrintRus("Подчинённых процессов найдено: "); cout << groupSize-1 << endl;
	int vars[6], value;
	GetData(&vars[0], value);
	SendTasks(vars, value, groupSize);

	// receiving data
	vector<int> results;
	int buffer;
	MPI_Status status;
	while (groupSize > 1){
		VerifyMPI(MPI_Recv(&buffer, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status));
		if (status.MPI_TAG == RESULT_MSG_TAG){
			results.insert(results.end(), buffer);
		} else if(status.MPI_TAG == END_MSG_TAG){
			groupSize--;
		}
	}

	// printing results
	PrintData(results, vars, value);
	system("pause");
	return 0;
}

int SlaveProcess(int groupSize){
	// geting task information
	MPI_Status status;
	int arrTaskInfo[3];
	VerifyMPI(MPI_Recv(arrTaskInfo, 3, MPI_INT, 0, TASK_INFO_MSG_TAG, MPI_COMM_WORLD, &status));
	int vars[6];
	VerifyMPI(MPI_Recv(vars, 6, MPI_INT, 0, TASK_DATA_MSG_TAG, MPI_COMM_WORLD, &status));

	// processing task information
	int s1, s2, s3, s4, s5; // signs
	s5 =   arrTaskInfo[1] & 3   /*0000000011*/;
	s4 = ( arrTaskInfo[1] & 12  /*0000001100*/ ) >> 2;
	s3 = ( arrTaskInfo[1] & 48  /*0000110000*/ ) >> 4;
	s2 = ( arrTaskInfo[1] & 192 /*0011000000*/ ) >> 6;
	s1 = ( arrTaskInfo[1] & 768 /*1100000000*/ ) >> 8;

	int iters = arrTaskInfo[2]-arrTaskInfo[1]; // number of iterations

	// processing data
	float r1, r2, r3, r4, r5;
	for (  ; s1<4; s1++){
		r1 = vars[0];
		switch (s1){
			case 0: r1 += vars[1]; break;
			case 1: r1 -= vars[1]; break;
			case 2: r1 *= vars[1]; break;
			case 3: r1 /= vars[1]; break;
			default: return 1;
		}
		for (  ; s2<4; s2++){
			r2 = r1;
			switch (s2){
				case 0: r2 += vars[2]; break;
				case 1: r2 -= vars[2]; break;
				case 2: r2 *= vars[2]; break;
				case 3: r2 /= vars[2]; break;
				default: return 1;
			}
			for (  ; s3<4; s3++){
				r3 = r2;
				switch (s3){
					case 0: r3 += vars[3]; break;
					case 1: r3 -= vars[3]; break;
					case 2: r3 *= vars[3]; break;
					case 3: r3 /= vars[3]; break;
					default: return 1;
				}
				for (  ; s4<4; s4++){
					r4 = r3;
					switch (s4){
						case 0: r4 += vars[4]; break;
						case 1: r4 -= vars[4]; break;
						case 2: r4 *= vars[4]; break;
						case 3: r4 /= vars[4]; break;
						default: return 1;
					}
					for (  ; s5<4; s5++){
						r5 = r4;
						switch (s5){
							case 0: r5 += vars[5]; break;
							case 1: r5 -= vars[5]; break;
							case 2: r5 *= vars[5]; break;
							case 3: r5 /= vars[5]; break;
							default: return 1;
						}
						if (r5 == arrTaskInfo[0]){
							SendData(s1, s2, s3, s4, s5);
						}
						iters--;
						if (iters == 0){
							SendEnd();
							return 0;
						}
					}
					s5 = 0;
				}
				s4 = 0;
			}
			s3 = 0;
		}
		s2 = 0;
	}

	return 1;
}

int main(int argc, char **argv){
	VerifyMPI(MPI_Init (&argc, &argv));
	int groupSize, rank;
	MPI_Comm_size( MPI_COMM_WORLD, &groupSize );
	MPI_Comm_rank( MPI_COMM_WORLD, &rank );
	VerifyMPI(MPI_Barrier(MPI_COMM_WORLD));
	if (rank == 0){
		MasterProcess(groupSize);
	}
	else
		SlaveProcess(groupSize);
	MPI_Finalize();
	return 0;
}
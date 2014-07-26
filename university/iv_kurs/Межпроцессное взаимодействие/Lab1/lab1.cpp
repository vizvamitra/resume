#include <iostream>
#include <fstream>
using namespace std;

int main(int arg,char* arga[]){
	if(arg<2){
		cout<<"You must specify input file\n";
		return(1);
	}
	ifstream hInput;
	hInput.open(arga[1], ifstream::in);
	if (!hInput){
		cout<<"Wrong file specified. Will now exit\n";
		return(2);
	}
	int ch = hInput.get();
 	while (hInput.good()) {
		cout << (char) ch;
		ch = hInput.get();
	}
	hInput.close();
	return(0);	
}

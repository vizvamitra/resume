#include <iostream>
#include <fstream>
#include <pwd.h>
#include <grp.h>
#include <iomanip>
using namespace std;

int main(int arg, char* arga[]){
	if (arg<2){
		cout<< "You must specify output file\n";
		return 1;
	}
	ofstream hOut (arga[1],ofstream::out);
	if (!hOut){
		cout<< "Error opening/creating output file";
		return 2;
	}
	cout<< "Enter login you interested in\n";
	char lname[30];
	cin>> lname;
	passwd* user = getpwnam(lname);
	if (!user){
		cout<<"Wrong login specified. Will now exit\n";
		return 3;
	}	
	hOut.setf(ios::left);
	hOut<<setw(10)<<"Login:"<<user->pw_name<<endl;
        hOut<<setw(10)<<"Password:"<<user->pw_passwd<<endl;
        hOut<<setw(10)<<"UID:"<<user->pw_uid<<endl;
        hOut<<setw(10)<<"GrID:"<<user->pw_gid<<endl;
        hOut<<setw(10)<<"Info:"<<user->pw_gecos<<endl;
        hOut<<setw(10)<<"Shell:"<<user->pw_shell<<endl;
        hOut<<setw(10)<<"Dir:"<<user->pw_dir<<endl;
	hOut.close();

	cout.setf(ios::left);
	cout<<endl<<setw(10)<<"Login:"<<user->pw_name<<endl;
	cout<<setw(10)<<"Password:"<<user->pw_passwd<<endl;
	cout<<setw(10)<<"UID:"<<user->pw_uid<<endl;
	cout<<setw(10)<<"GrID:"<<user->pw_gid<<endl;
	cout<<setw(10)<<"Info:"<<user->pw_gecos<<endl;
	cout<<setw(10)<<"Shell:"<<user->pw_shell<<endl;
	cout<<setw(10)<<"Dir:"<<user->pw_dir<<endl<<endl;

	return 0;
}

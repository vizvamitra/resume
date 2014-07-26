#include <fstream>
#include <iostream>
#include <conio.h>
#include <windows.h>
using namespace std; 

extern "C"{
	void _asmSearch(char*, unsigned long, char*, long, int*,char*,unsigned long*);
}

int getPrefixFunction(char searchWord[50], int *prefixFunction){
	prefixFunction[0]=0;
	for (int i=0; i<strlen(searchWord); i++){
		int prefixLen = prefixFunction[i];
		while ((searchWord[prefixLen]!=searchWord[i+1]) && (prefixLen>0)){
			prefixLen = prefixFunction[prefixLen-1];
		}
		if (searchWord[prefixLen] == searchWord[i+1]){
			prefixFunction[i+1] = prefixLen + 1;
		}
		else{
			prefixFunction[i+1]=0;
		}
	}
	return 1;
}

void printRus(char* string){	// Функция для вывода русского языка
	char ansiBuf[100];
	AnsiToOem(string,ansiBuf);
	cout<<ansiBuf;
}

unsigned long search(char* text, unsigned long textLen, char* tempText){
	int i,j,found=0;
	unsigned long tempTextLen=0;

	printRus("Введите слово для поиска: ");
	char* searchWord = new char[50];
	gets(searchWord);
	long wordLen=strlen(searchWord);

	int* prefixFunction = new int[wordLen];
	getPrefixFunction(searchWord, prefixFunction);

	/*for (i=0;i<(textLen-wordLen+1);i++){
		for (j=0;j<wordLen;j++){
			if (text[i+j] != searchWord[j]){
				if ((int)text[i+j]==13 || (int)text[i+j]==10)
					found=0;
				for (int k=0;k<=j-prefixFunction[j];k++)
					tempText[tempTextLen+k]=text[i+k];
				tempTextLen+=j-prefixFunction[j]+1;
				i+=j-prefixFunction[j];
				break;
			}
			if (j == (wordLen-1)){
				found++;
				if (found==1){
					for (int k=0;k<wordLen;k++)
						tempText[tempTextLen+k]=searchWord[k];
					tempTextLen+=wordLen;
					i+=wordLen-1;
					break;
				}
				i+=wordLen-1;
			}
		}
	}*/
	_asmSearch(text,textLen,searchWord,wordLen,prefixFunction,tempText,&tempTextLen);
	return tempTextLen;
}

void main(){
	fstream fin("text.txt", fstream::in | fstream::out| ios::binary);
	ofstream fout;
	char cont;
	if (!fin){
		printRus("Ошибка окрытия text.txt\n");
		getch();
	}
	else{
		fin.seekg(0, ios::end);				//
		unsigned long len=fin.tellg();		// Определение длины текста
		char *text=new char[len+1];			//
		fin.seekg(0,ios::beg);
		fin.read(text,len);
		text[len]='\0';
		char* tempText = new char[len];
		
		do {
			system("cls");
			unsigned long tempTextLen = search(text, len, tempText);
			printRus("\nРезультат:\n\n");
			cout<<tempText;

			fout.open("text2.txt", ios::out| ios::binary);	//
			fout<<tempText;									// Сохранение в файл
			fout.close();									//
			
			printRus("\n\nПовторить? (y/n): ");
			fflush(stdin);
			cin>>cont;
			fflush(stdin);			
		} while (cont == 'y' || cont == 'Y');
	}
}
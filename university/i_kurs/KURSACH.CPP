#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<conio.h>
#define STOP_STRING ""

struct song
       {
	   char title[50];
	   char author[50];
	   char album[50];
	   song *next;
           song *prev;
       };

struct author
       {
	   song *song;
           unsigned num;
	   author *next_song;
           author *prev_song;
       };

unsigned songlist_open (song* &pbeg,song* &pend)
    {
	FILE *fp=fopen("songlist.dat","rb");
	song *ptr,*pprev;
	unsigned n=0;
	if (!fp)
	   {
	       fp=fopen("songlist.dat","ab");
	       if (!fp)
		  {
		      puts("Oshibka sozdaniya fila, programma ostanovlena");
		      exit(0);
		  }
	       return(0);
	   }
	pbeg=new song;
	n=fread(pbeg,sizeof(song),1,fp);
	if (n==0)
	   {
               free(pbeg);
	       printf("\n  Oshibka v file. File budet ochishen. Prodolzhit'? (y/n): ");
	       char cont;
	       fflush(stdin);
	       cont=getch();
	       if (cont!='y' && cont!='Y')
		  {
		      exit(0);
		  }
               fp=fopen("songlist.dat","wb");
	       return(0);
	   }
        pprev=pbeg;
	while (!feof(fp))
	      {
		  ptr=new song;
		  if (!ptr)
		     {
		         puts("Oshibka videleniya pamyati");
			 exit(0);
                     }
		  if (fread(ptr,sizeof(song),1,fp))
		     {
			 n++;
                         pprev->next=ptr;
		         ptr->prev=pprev;
			 pprev=ptr;
		     }
		     else
			  {
			      free(ptr);
			      ptr=pprev;
                          }
	      }
	pend=ptr;
        pend->next=NULL;
	return(n);
    }

void changeover (song* &ptr, song* &ptr2, song* &pbeg,song* &pend)
     {
	 if (ptr!=pbeg && ptr2!=pend)
	    {
		ptr->prev->next=ptr2;
		ptr->next=ptr2->next;
		ptr2->next=ptr;
		ptr->next->prev=ptr;
		ptr2->prev=ptr->prev;
		ptr->prev=ptr2;
                return;
	    }
	 if (ptr==pbeg && ptr2!=pend)
	    {
		pbeg=ptr2;
		ptr->next=ptr2->next;
		ptr2->next=ptr;
		ptr2->prev=NULL;
		ptr->prev=pbeg;
		ptr->next->prev=ptr;
		return;
	    }
	 if (ptr!=pbeg && ptr2==pend)
	    {
		pend=ptr;
		ptr->prev->next=ptr2;
		ptr->next=NULL;
		ptr2->next=pend;
		ptr2->prev=ptr->prev;
		ptr->prev=ptr2;
		return;
	    }
	 ptr2->next=ptr;
	 ptr->prev=ptr2;
	 ptr->next=NULL;
	 ptr2->prev=NULL;
	 pbeg=ptr2;
         pend=ptr;
     }

void songlist_alfsort (int parametr, song* &pbeg,song* &pend,unsigned kol)
     {
	 char poryadok[]="0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz !#$%&'()*+,-./[:;<=>?@[\]^_`{|}~\n";
         char str1[50],str2[50];
	 song *pprev, *ptr;
	 unsigned i,j,k,c1;
	 for (i=kol; i>0; i--)
	     {
		 pprev=pbeg;
		 ptr=pbeg;
		 switch (parametr)
		        {
			    case 1: strcpy(str1,pprev->title);
                                    for (k=0;k<strlen(str1);k++)
					{
					    c1=(int)str1[k];
					    if (c1>96 && c1<123)
					       {
					           str1[k]=(char)(c1-32);
					       }
					}
				    for (j=1; j<kol; j++)
		                        {
					    ptr=ptr->next;
					    strcpy(str2,ptr->title);
					    for (k=0; k<strlen(str2);k++)
						{
                                                    c1=(int)str2[k];
						    if (c1>96 && c1<123)
						       {
							   str2[k]=(char)(c1-32);
						       }
                                                }
					    for (k=0; k<( (strlen(str2) < strlen(str1)) ? strlen(str2) : strlen(str1)); k++)
                                                {
						    if (str1[k]!=str2[k])
						       {
							   if (strchr(poryadok,str1[k]) > strchr(poryadok,str2[k]))
			        			      {
								  changeover(pprev, ptr,pbeg,pend);
								  pprev=ptr;
								  ptr=ptr->next;
								  strcpy(str2,str1);
							      }
                                                           break;
						       }
						}
					    strcpy(str1,str2);
					    pprev=ptr;
					    
					}
				    break;

			    case 2: strcpy(str1,pprev->author);
                                    for (k=0;k<strlen(str1);k++)
					{
					    c1=(int)str1[k];
					    if (c1>96 && c1<123)
					       {
					           str1[k]=(char)(c1-32);
					       }
					}
				    for (j=1; j<kol; j++)
		                        {
					    ptr=ptr->next;
					    strcpy(str2,ptr->author);
					    for (k=0; k<strlen(str2);k++)
						{
                                                    c1=(int)str2[k];
						    if (c1>96 && c1<123)
						       {
							   str2[k]=(char)(c1-32);
						       }
                                                }
					    for (k=0; k<( (strlen(str2) < strlen(str1)) ? strlen(str2) : strlen(str1)); k++)
                                                {
						    if (str1[k]!=str2[k])
						       {
							   if (strchr(poryadok,str1[k]) > strchr(poryadok,str2[k]))
			        			      {
								  changeover(pprev, ptr,pbeg,pend);
								  pprev=ptr;
								  ptr=ptr->next;
								  strcpy(str2,str1);
							      }
                                                           break;
						       }
						}
					    strcpy(str1,str2);
					    pprev=ptr;
					    
					}
				    break;

			    case 3: strcpy(str1,pprev->album);
                                    for (k=0;k<strlen(str1);k++)
					{
					    c1=(int)str1[k];
					    if (c1>96 && c1<123)
					       {
					           str1[k]=(char)(c1-32);
					       }
					}
				    for (j=1; j<kol; j++)
		                        {
					    ptr=ptr->next;
					    strcpy(str2,ptr->album);
					    for (k=0; k<strlen(str2);k++)
						{
                                                    c1=(int)str2[k];
						    if (c1>96 && c1<123)
						       {
							   str2[k]=(char)(c1-32);
						       }
                                                }
					    for (k=0; k<( (strlen(str2) < strlen(str1)) ? strlen(str2) : strlen(str1)); k++)
                                                {
						    if (str1[k]!=str2[k])
						       {
							   if (strchr(poryadok,str1[k]) > strchr(poryadok,str2[k]))
			        			      {
								  changeover(pprev, ptr,pbeg,pend);
								  pprev=ptr;
								  ptr=ptr->next;
								  strcpy(str2,str1);
							      }
                                                           break;
						       }
						}
					    strcpy(str1,str2);
					    pprev=ptr;
					    
					}
				    break;
			}
		 kol--;
	     }
     }

unsigned autosort (song* &pbeg,song* &pend, author* &au_beg,unsigned kol)
    {
        unsigned k,song_kol=1,au_kol=1,c1;
	song *ptr=pbeg;
        char str1[50],str2[50];
	author *au_ptr,*au_song;
	songlist_alfsort(2,pbeg,pend,kol);
        au_beg=new author;
	au_beg->song=pbeg;
        au_ptr=au_beg;
	au_song=au_beg;
	if (pbeg==pend)
	   {
               au_beg->num=1;
	       return(1);
	   }
	strcpy(str1,pbeg->author);
	for (k=0; k<strlen(str1); k++)
	    {
		c1=(int)str1[k];
		if (c1>96 && c1<123)
		   {
 		       str1[k]=(char)(c1-32);
		   }
	    }
	ptr=pbeg->next;
	while (1)
	      {
		  strcpy(str2,ptr->author);
		  for (k=0;k<strlen(str2);k++)
		      {
			  c1=(int)str2[k];
		          if (c1>96 && c1<123)
		             {
		                 str2[k]=(char)(c1-32);
			     }
		      }
		  while (strcmp(str1,str2))
		        {
                            au_ptr->num=song_kol;
			    au_ptr->prev_song=new author;
                            au_ptr=au_ptr->prev_song;
                            au_song=au_ptr;
			    au_song->song=ptr;
			    au_kol++;
			    if (ptr==pend)
		               {
                                   au_ptr->num=1;
			           return(au_kol);
			       }
			    ptr=ptr->next;
			    strcpy(str1,str2);
			    strcpy(str2,ptr->author);
		            for (k=0;k<strlen(str2);k++)
		                {
			            c1=(int)str2[k];
		                    if (c1>96 && c1<123)
		                       {
		                           str2[k]=(char)(c1-32);
			               }
		                }
                            song_kol=1;
		        }
	          au_song->next_song=new author;
                  au_song->next_song->prev_song=au_song;
	          au_song=au_song->next_song;
		  au_song->song=ptr;
                  song_kol++;
	          if (ptr==pend)
		     {
                         au_ptr->num=song_kol;
			 au_ptr->prev_song=NULL;
		         return(au_kol);
		     }
	          ptr=ptr->next;
	      }
    }

int main_menu (unsigned kol,unsigned auth_kol)
     {
	 int select;
	 char cont[2]={'0','\n'};
	 do
	    {
	        clrscr();
		printf(" Pesen: %5u                                                    Avtorov: %5u ",kol,auth_kol);
		printf("-----------------------------------Main  menu-----------------------------------\n");
	 	puts(" 1. Vivod spiska avtorov");
	 	puts(" 2. Vivod vsego spiska pesen");
	 	puts(" 3. Poisk");
	 	puts(" 4. Dobavlenie pesni");
	 	puts(" 5. Sohranenie izmeneniy i vihod");
		puts(" 6. Vihod bez sohraneniya izmeneniy");
		puts("\n--------------------------------------------------------------------------------\n\n");
		printf("  Vvedite nomer deystviya: ");
		fflush(stdin);
		cont[0]=getch();
		fflush(stdin);
            }
	    while ( (int)cont[0]<49 || (int)cont[0]>54 );
	 sscanf(cont,"%d",&select);
	 switch (select)
		{
		    case 1: clrscr();
		            if (auth_kol==0)
		               {
				   printf("\n-------------------------------------Avtori-------------------------------------\n");
				   printf("  V baze net ni odnoy pesni. Nazhmite lubuyu klavishu dlya vozvrata c menu.");
		                   getch();
		                   return(0);
		               }
		            return(1);

		    case 2: clrscr();
		            if (kol==0)
			       {
				   printf("\n-------------------------------Vivod spiska pesen-------------------------------\n");
				   printf("  V baze net ni odnoy pesni. Nazhmite lubuyu klavishu dlya vozvrata c menu.");
		                   getch();
		                   return(0);
			       }
			    if (kol==1)
			       {
				   return(20);
			       }
		            do
			       {
				   clrscr();
				   printf("\n-------------------------------Vivod spiska pesen-------------------------------\n");
				   printf("  Sortirovat pesni? (y/n): ");
				   cont[0]=getch();
				   fflush(stdin);
			       }
			       while (cont[0]!='y' && cont[0]!='Y' && cont[0]!='n' && cont[0]!='N');
			    switch (cont[0])
				   {
				       case 'y':
				       case 'Y': do
						    {
							clrscr();
							printf("\n-------------------------------Vivod spiska pesen-------------------------------\n");
							puts(" 1. Po nazvaniyu");
						 	puts(" 2. Po avtoru");
						 	puts(" 3. Po albomu");
							puts("\n 4. Vozvrat v glavnoe menu");
							puts("\n\n--------------------------------------------------------------------------------\n\n");
							printf("  Viberite variant sortirovki: ");
							cont[0]=getch();
							fflush(stdin);
						    }
						    while ( (int)cont[0]<49 || (int)cont[0]>52 );
						 sscanf(cont,"%d",&select);
						 if (select==4)
			                            {
				                        return(0);
			                            }
                                                 return(select+20);

				       default : return(20);

				   };

		    case 3: clrscr();
		            if (kol==0)
			       {
				   printf("\n-------------------------------Vivod spiska pesen-------------------------------\n");
				   printf("  V baze net ni odnoy pesni. Nazhmite lubuyu klavishu dlya vozvrata c menu.");
		                   getch();
		                   return(0);
			       }
		            do
			       {
                                   clrscr();
				   printf("\n----------------------------------Poisk  pesen----------------------------------\n");
				   puts(" 1. Po nazvaniyu");
				   puts(" 2. Po avtoru");
				   puts(" 3. Po albomu");
				   puts(" 4. Po vsem polyam");
				   puts("\n 5. Vozvrat v glavnoe menu");
				   puts("\n--------------------------------------------------------------------------------\n\n");
				   printf("  Viberite variant poiska: ");
				   cont[0]=getch();
				   fflush(stdin);
			       }
			    while ( (int)cont[0]<49 || (int)cont[0]>53 );
			    sscanf(cont,"%d",&select);
			    if (select==5)
			       {
				   return(0);
                               }
			    return(select+30);

		    case 4: return(4);

		    case 5: do
                               {
		                   clrscr();
				   printf("\n-------------------------------Sohranenie i vihod-------------------------------\n");
				   printf("  Vnimanie! Posle sohraneniya izmeneniya ne otmenit'. Prodolzhit'? (y/n): ");
				   cont[0]=getch();
			       }
			       while (cont[0]!='y' && cont[0]!='Y' && cont[0]!='n' && cont[0]!='N');
			    switch (cont[0])
				   {
				       case 'y':
				       case 'Y': return(5);

				       default:  return(0);
				   };

		    case 6: do
                               {
		                   clrscr();
				   printf("\n------------------------------Vihod bez sohraneniya-----------------------------\n");
				   printf("  Vnimanie! Vse vnesennie izmeneniya budut poteryani. Prodolzhit'? (y/n): ");
				   cont[0]=getch();
			       }
			       while (cont[0]!='y' && cont[0]!='Y' && cont[0]!='n' && cont[0]!='N');
			    switch (cont[0])
				   {
				       case 'y':
				       case 'Y': return(6);

				       default:  return(0);
				   };
		}
     }

void add_song (song* &pbeg,song* &pend, unsigned &kol)
     {
         char cont='y';
	 clrscr();
	 printf("\n--------------------------------Dobavlenie pesni--------------------------------\n");
	 if (kol==0)
	    {
	        pbeg=new song;
		if (!pbeg)
		   {
		       puts("Oshibka videleniya pamyati, programma ostanovlena");
		       exit(0);
		   }
		kol++;
		printf("  Zapolnite polya.\n\n");
		printf("  Title: ");
	 	gets(pbeg->title);
	 	printf(" Author: ");
		gets(pbeg->author);
		if (!strcmp(pbeg->author,STOP_STRING))
		   {
		       strcpy(pbeg->author,"Neizvestniy ispolnitel");
		   }
	 	printf("  Album: ");
	 	gets(pbeg->album);
		printf("\n  Dobavit' esche odnu? (y/n): ");
		do
		   {
		       cont=getch();
		   }
		   while ( cont!='y' && cont!='Y' && cont!='n' && cont!='N' );
                pend=pbeg;
            }
	 if (cont=='y' || cont=='Y')
	    {
	        do
		   {
		       clrscr();
		       printf("\n--------------------------------Dobavlenie pesni--------------------------------\n");
	 	       pend->next=new song;
	 	       if (!(pend->next))
	    	          {
		              printf ("Oshibka videleniya pamyati");
		              break;
			  }
		       kol++;
		       pend->next->prev=pend;
		       pend=pend->next;
         	       printf("  Zapolnite polya.\n\n");
		       printf("  Title: ");
	 	       gets(pend->title);
	 	       printf(" Author: ");
		       gets(pend->author);
		       if (!strcmp(pend->author,STOP_STRING))
		          {
		              strcpy(pend->author,"Neizvestniy ispolnitel");
		          }
	 	       printf("  Album: ");
		       gets(pend->album);
		       printf("\n  Dobavit' esche odnu? (y/n): ");
		       do
		          {
		              cont=getch();
		          }
			  while ( cont!='y' && cont!='Y' && cont!='n' && cont!='N' );
		   }
		   while (cont=='y' || cont=='Y');
            }
	 pend->next=NULL;
     }

void save (song *pbeg,unsigned n)
     {
         FILE *fp=fopen("songlist.dat","wb");
	 if (n==0)
	    {
		return;
            }
	 if (n==1)
	    {
		fwrite(pbeg,sizeof(song),1,fp);
		return;
            }
	 song *ptr=pbeg;
	 fwrite(ptr,sizeof(song),1,fp);
	 for (unsigned i=1;i<n;i++)
	     {
		 ptr=ptr->next;
		 fwrite(ptr,sizeof(song),1,fp);
	     }
	 printf("\n\n  %u pesen sohraneno v file songlist.dat\n",n);
     }

unsigned search (int parametr, song *pbeg,song *pend, author* &searchlist_beg)
         {
	     song *ptr=pbeg;
	     char searchword[50],str1[50];
	     unsigned kol=0,c1;
	     searchlist_beg=new author;
	     author *sptr=searchlist_beg;
	     clrscr();
	     printf("\n----------------------------------Poisk  pesen----------------------------------\n");
	     printf("  Vvedite slovo dlya poiska: ");
	     scanf("%50s",&searchword);
	     for (int i=0;i<strlen(searchword);i++)
	         {
		     c1=(int)searchword[i];
		     if (c1>96 && c1<123)
		        {
			    searchword[i]=(char)(c1-32);
			}
		 }
	     switch (parametr)
                    {
			case 31: while (1)
			               {
                                           strcpy(str1,ptr->title);
					   for (i=0;i<strlen(str1);i++)
	                                       {
		                                   c1=(int)str1[i];
		                                   if (c1>96 && c1<123)
		                                      {
			                                  str1[i]=(char)(c1-32);
			                              }
					       }
					   if (strstr(str1,searchword))
					      {
						  sptr->song=ptr;
						  kol++;
						  if (ptr==pend)
						     {
						         break;
					             }
						  ptr=ptr->next;
						  break;
					      }
					   if (ptr==pend)
				              {
				                  break;
					      }
                                           ptr=ptr->next;
				       }
				 if (ptr==pend)
				    {
				        break;
				    }
				 while (1)
				       {
					   strcpy(str1,ptr->title);
					   for (i=0;i<strlen(str1);i++)
	                                       {
		                                   c1=(int)str1[i];
		                                   if (c1>96 && c1<123)
		                                      {
			                                  str1[i]=(char)(c1-32);
			                              }
					       }
				           if (strstr(str1,searchword))
					      {
					          sptr->next_song=new author;
						  sptr->next_song->prev_song=sptr;
						  sptr=sptr->next_song;
						  sptr->song=ptr;
						  kol++;
					      }
					   if (ptr==pend)
					      {
					          break;
					      }
					   ptr=ptr->next;
				       }
                                 break;
				     
			case 32: while (1)
			               {
					   strcpy(str1,ptr->author);
					   for (i=0;i<strlen(str1);i++)
	                                       {
		                                   c1=(int)str1[i];
		                                   if (c1>96 && c1<123)
		                                      {
			                                  str1[i]=(char)(c1-32);
			                              }
					       }
					   if (strstr(str1,searchword))
					      {
						  sptr->song=ptr;
						  kol++;
						  if (ptr==pend)
						     {
						         break;
					             }
						  ptr=ptr->next;
						  break;
					      }
					   if (ptr==pend)
				              {
				                  break;
					      }
					   ptr=ptr->next;
				       }
				 if (ptr==pend)
				    {
					break;
			            }
				 while (1)
				       {
					   strcpy(str1,ptr->author);
					   for (i=0;i<strlen(str1);i++)
	                                       {
		                                   c1=(int)str1[i];
		                                   if (c1>96 && c1<123)
		                                      {
			                                  str1[i]=(char)(c1-32);
			                              }
					       }
				           if (strstr(str1,searchword))
					      {
					          sptr->next_song=new author;
						  sptr->next_song->prev_song=sptr;
						  sptr=sptr->next_song;
						  sptr->song=ptr;
						  kol++;
					      }
					   if (ptr==pend)
					      {
					          break;
					      }
					   ptr=ptr->next;
				       }
                                 break;

			case 33: while (1)
			               {
					   strcpy(str1,ptr->album);
					   for (i=0;i<strlen(str1);i++)
	                                       {
		                                   c1=(int)str1[i];
		                                   if (c1>96 && c1<123)
		                                      {
			                                  str1[i]=(char)(c1-32);
			                              }
					       }
					   if (strstr(str1,searchword))
					      {
						  sptr->song=ptr;
						  kol++;
						  if (ptr==pend)
						     {
						         break;
					             }
						  ptr=ptr->next;
						  break;
					      }
					   if (ptr==pend)
				              {
				                  break;
					      }
					   ptr=ptr->next;
				       }
				 if (ptr==pend)
				    {
					break;
			            }     
				 while (1)
				       {
					   strcpy(str1,ptr->album);
					   for (i=0;i<strlen(str1);i++)
	                                       {
		                                   c1=(int)str1[i];
		                                   if (c1>96 && c1<123)
		                                      {
			                                  str1[i]=(char)(c1-32);
			                              }
					       }
				           if (strstr(str1,searchword))
					      {
					          sptr->next_song=new author;
						  sptr->next_song->prev_song=sptr;
						  sptr=sptr->next_song;
						  sptr->song=ptr;
						  kol++;
					      }
					   if (ptr==pend)
					      {
					          break;
					      }
					   ptr=ptr->next;
				       }
                                 break;

			case 34: while (1)
			               {
					   strcpy(str1,ptr->title);
					   for (i=0;i<strlen(str1);i++)
	                                       {
		                                   c1=(int)str1[i];
		                                   if (c1>96 && c1<123)
		                                      {
			                                  str1[i]=(char)(c1-32);
			                              }
					       }
					   if (strstr(str1,searchword))
					      {
						  sptr->song=ptr;
						  kol++;
						  if (ptr==pend)
						     {
						         break;
					             }
						  ptr=ptr->next;
						  break;
					      }
					      else
						   {
						       strcpy(str1,ptr->author);
					               for (i=0;i<strlen(str1);i++)
	                                                   {
		                                               c1=(int)str1[i];
		                                               if (c1>96 && c1<123)
		                                                  {
			                                              str1[i]=(char)(c1-32);
			                                          }
					                   }
					               if (strstr(str1,searchword))
					                  {
						              sptr->song=ptr;
						              kol++;
							      if (ptr==pend)
						                 {
						                     break;
					                         }
						              ptr=ptr->next;
						              break;
							  }
							  else
							       {
								   strcpy(str1,ptr->album);
					                           for (i=0;i<strlen(str1);i++)
	                                                               {
		                                                           c1=(int)str1[i];
		                                                           if (c1>96 && c1<123)
		                                                              {
			                                                          str1[i]=(char)(c1-32);
			                                                      }
					                               }
					                           if (strstr(str1,searchword))
					                              {
						                          sptr->song=ptr;
						                          kol++;
									  if (ptr==pend)
						                             {
						                                 break;
					                                     }
						                          ptr=ptr->next;
						                          break;
								      }
							       }
						   }
					   if (ptr==pend)
				              {
				                  break;
				              }
                                           ptr=ptr->next;
				       }
				 if (ptr==pend)
				    {
					break;
				    }
				 while (1)
				       {
					   strcpy(str1,ptr->title);
					   for (i=0;i<strlen(str1);i++)
	                                       {
		                                   c1=(int)str1[i];
		                                   if (c1>96 && c1<123)
		                                      {
			                                  str1[i]=(char)(c1-32);
			                              }
					       }
					   if (strstr(str1,searchword))
					      {
					          sptr->next_song=new author;
						  sptr->next_song->prev_song=sptr;
						  sptr=sptr->next_song;
						  sptr->song=ptr;
						  kol++;
					      }
					      else
						   {
						       strcpy(str1,ptr->author);
					               for (i=0;i<strlen(str1);i++)
	                                                   {
		                                               c1=(int)str1[i];
		                                               if (c1>96 && c1<123)
		                                                  {
			                                              str1[i]=(char)(c1-32);
			                                          }
					                   }
					               if (strstr(str1,searchword))
					                  {
					                      sptr->next_song=new author;
						              sptr->next_song->prev_song=sptr;
						              sptr=sptr->next_song;
						              sptr->song=ptr;
						              kol++;
					                  }
							  else
							       {
								   strcpy(str1,ptr->album);
					                           for (i=0;i<strlen(str1);i++)
	                                                               {
		                                                           c1=(int)str1[i];
		                                                           if (c1>96 && c1<123)
		                                                              {
			                                                          str1[i]=(char)(c1-32);
			                                                      }
					                               }
					                           if (strstr(str1,searchword))
					                              {
					                                  sptr->next_song=new author;
						                          sptr->next_song->prev_song=sptr;
						                          sptr=sptr->next_song;
						                          sptr->song=ptr;
						                          kol++;
					                             }
							       }
						   }
					   if (ptr==pend)
					      {
					          break;
					      }
					   ptr=ptr->next;
				       }
                                 break;
		    }
	     if (kol==0)
	        {
		    clrscr();
	            printf("\n----------------------------------Poisk  pesen----------------------------------\n");
		    printf("  Po vashemu zaprosu nichego ne naydeno. Enter - vozvrat v menu.");
		    getch();
                    return(0);
		}
	     return(kol);
	 }

void song_red (unsigned songnum,song* &pbeg,song* &pend,unsigned &kol)
     {
         song *ptr=pbeg;
	 char cont[2]={'0','\n'};
	 int select;
	 for (unsigned i=1;i<songnum;i++)
	     {
	         ptr=ptr->next;
	     }
	 while (1)
	       {
	           do
	              {
		          clrscr();
		          printf("\n------------------------------Redaktirovanie pesni------------------------------\n");
		          printf("  Title: %s\n Author: %s\n  Album: %s\n\n",ptr->title,ptr->author,ptr->album);
		          puts(" 1. Izmenenie nazvaniya");
		          puts(" 2. Izmenenie avtora");
		          puts(" 3. Izmenenie nazvaniya alboma");
			  puts(" 4. Udalenie");
			  puts("\n 5. Vozvrat v menu\n");
			  printf("  Vvedite nomer deystviya: ");
			  cont[0]=getch();
		      }
		      while ( (int)cont[0]<48 || (int)cont[0]>53 );
                   sscanf(cont,"%d",&select);
	           switch (select)
                          {
			      case 1: clrscr();
				      printf("\n------------------------------Redaktirovanie pesni------------------------------\n");
				      printf("  Title: ");
				      gets(ptr->title);
                                      break;

			      case 2: clrscr();
				      printf("\n------------------------------Redaktirovanie pesni------------------------------\n");
				      printf("  Author: ");
				      gets(ptr->author);
				      if (!strcmp(ptr->author,STOP_STRING))
					 {
					     strcpy(ptr->author,"Neizvestniy ispolnitel");
					 }
                                      break;

			      case 3: clrscr();
				      printf("\n------------------------------Redaktirovanie pesni------------------------------\n");
				      printf("  Album: ");
				      gets(ptr->album);
                                      break;

			      case 4: do
                                         {
		                             clrscr();
					     printf("\n------------------------------Redaktirovanie pesni------------------------------\n");
				             printf("  Vi uvereni? (y/n): ");
				             cont[0]=getch();
			                 }
					 while (cont[0]!='y' && cont[0]!='Y' && cont[0]!='n' && cont[0]!='N');
                                      if (cont[0]=='n' || cont[0]=='N')
					 {
					     return;
					 }
                                      kol--;
				      if (ptr!=pbeg && ptr!=pend)
					    {
						ptr->prev->next=ptr->next;
						ptr->next->prev=ptr->prev;
                                                free(ptr);
					    }
					    else
						 {
						     if (ptr==pend && ptr!=pbeg)
							{
							    pend=pend->prev;
                                                            free(pend->next);
							    pend->next=NULL;
							}
							else
                                                             {
								 if (ptr==pbeg && ptr!=pend)
								    {
									pbeg=pbeg->next;
                                                                        free(pbeg->prev);
									pbeg->prev=NULL;
								    }
								    else
                                                                         {
								             free(ptr);
									 }
                                                             }
						 }
			              return; 

			      case 5: return;
		          }
	       }
     }

unsigned song_red (unsigned songnum,author* &songlist_beg,song* &pbeg, song* &pend, unsigned &found,unsigned &kol)
         {
             author *sptr=songlist_beg;
	     char cont[2]={'0','\n'};
	     int select;
	     for (unsigned i=1;i<songnum;i++)
	         {
		     sptr=sptr->next_song;
	         }
	     while (1)
	           {
	              do
	                 {
		             clrscr();
		             printf("\n------------------------------Redaktirovanie pesni------------------------------\n");
		             printf("  Title: %s\n Author: %s\n  Album: %s\n\n",sptr->song->title,sptr->song->author,sptr->song->album);
		             puts(" 1. Izmenenie nazvaniya");
		             puts(" 2. Izmenenie avtora");
		             puts(" 3. Izmenenie nazvaniya alboma");
			     puts(" 4. Udalenie");
                             puts(" 5. Vozvrat k spisku poiska");
			     puts("\n 6. Vozvrat v menu\n");
			     printf("  Vvedite nomer deystviya: ");
			     cont[0]=getch();
			 }
			 while ( (int)cont[0]<48 || (int)cont[0]>54 );
		      sscanf(cont,"%d",&select);
	              switch (select)
                             {
				 case 1: clrscr();
				         printf("\n------------------------------Redaktirovanie pesni------------------------------\n");
				         printf("  Title: ");
					 gets(sptr->song->title);
                                         break;

				 case 2: clrscr();
				         printf("\n------------------------------Redaktirovanie pesni------------------------------\n");
				         printf("  Author: ");
					 gets(sptr->song->author);
					 if (!strcmp(sptr->song->author,STOP_STRING))
					    {
						strcpy(sptr->song->author,"Neizvestniy ispolnitel");
                                            }
                                         break;

				 case 3: clrscr();
				         printf("\n------------------------------Redaktirovanie pesni------------------------------\n");
				         printf("  Album: ");
					 gets(sptr->song->album);
                                         break;

				 case 4: do
                                            {
		                                clrscr();
					        printf("\n------------------------------Redaktirovanie pesni------------------------------\n");
				                printf("  Vi uvereni? (y/n): ");
				                cont[0]=getch();
			                    }
					    while (cont[0]!='y' && cont[0]!='Y' && cont[0]!='n' && cont[0]!='N');
					 if (cont[0]=='n' || cont[0]=='N')
					    {
						break;
					    }
					 kol--;
					 found--;
                                         if (sptr->song!=pbeg && sptr->song!=pend)
					    {
						sptr->song->prev->next=sptr->song->next;
						sptr->song->next->prev=sptr->song->prev;
                                                free(sptr->song);
					    }
					    else
						 {
						     if (sptr->song==pend && sptr->song!=pbeg)
							{
							    pend=pend->prev;
                                                            free(pend->next);
							    pend->next=NULL;
							}
							else
                                                             {
								 if (sptr->song==pbeg && sptr->song!=pend)
								    {
									pbeg=pbeg->next;
                                                                        free(pbeg->prev);
									pbeg->prev=NULL;
								    }
								    else
                                                                         {
								             free(sptr->song);
									 }
                                                             }
                                                 }
					 if (sptr==songlist_beg)
					    {
						songlist_beg=songlist_beg->next_song;
						free(songlist_beg->prev_song);
						songlist_beg->prev_song=NULL;

						return(1);
					    }
					 if (sptr->next_song==NULL)
					    {
						sptr=sptr->prev_song;
						free(sptr->next_song);
						sptr->next_song=NULL;
						return(1);
					    }
					 sptr->prev_song->next_song=sptr->next_song;
					 sptr->next_song->prev_song=sptr->prev_song;
					 free(sptr);
					 return(1); 

				 case 5: return(1);

				 case 6: sptr=songlist_beg->next_song;
				         for (unsigned i=1;i<found;i++)
					     {
						free(sptr->prev_song);
						sptr=sptr->next_song;
					     }
					 free(sptr);
				         return(0);
		             }
		   }
	 }

unsigned searchlist_print (author* searchlist_beg,unsigned kol)
         {
	     author *sptr=searchlist_beg;
	     char buffer[50];
	     unsigned IDs[5]={0,0,0,0,0},i=0,check;
	     clrscr();
	     printf(" Naydeno pesen: %5u\n",kol);
	     printf("----------------------------------Poisk  pesen----------------------------------\n");
	     for (unsigned j=1;j<=kol;j++)
	           {
		       printf("%5u. Title: %s\n      Author: %s\n       Album: %s\n\n",j,sptr->song->title,sptr->song->author,sptr->song->album);
		       IDs[(j-1)%5]=j;
		       if ((j%5)==0 && j!=kol)
		          {
			      printf("  Vvedite nomer pesni dlya izmeneniya (enter - prodolzheniya vivoda): ");
		              do
			         {
                                     fflush(stdin);
				     if (!strcmp(gets(buffer),STOP_STRING))
				        {
                                            i=0;
				            break;
					}
				     fflush(stdin);
				     check=sscanf(buffer,"%u",&i);
			         }
				 while ((i!=IDs[0] && i!=IDs[1] && i!=IDs[2] && i!=IDs[3] && i!=IDs[4]) || i==0 || check!=1);
			      if (i)
			         {
			             return(i);
				 }
			      clrscr();
			      printf(" Naydeno pesen: %5u\n",kol);
			      printf("----------------------------------Poisk  pesen----------------------------------\n");
			      for (int k=0;k<5;k++)
				  {
				      IDs[k]=0;
                                  }
			  }
		       sptr=sptr->next_song;
                   }
	     if ((j-1)==kol)
	        {
		    printf("  Vvedite nomer pesni dlya izmeneniya (enter - vozvrat v menu): ");
		    do
		       {
                           fflush(stdin);
			   if (!strcmp(gets(buffer),STOP_STRING))
			      {
                                  i=0;
				  return(0);
			      }
                           fflush(stdin);
			   check=sscanf(buffer,"%u",&i);
		       }
		       while ((i!=IDs[0] && i!=IDs[1] && i!=IDs[2] && i!=IDs[3] && i!=IDs[4]) || i==0 || check!=1);
		    if (i)
		       {
		           return(i);
		       }
		}
	 }

unsigned authorlist_print (author *au_beg,unsigned au_kol)
	 {
	     clrscr();
	     printf("\n-------------------------------------Avtori-------------------------------------\n");
	     author *auptr=au_beg;
	     char buffer[50];
	     unsigned check=0,i=0;
	     for (unsigned n=1;n<=au_kol;n++)
		 {
		     if ((int)auptr->song->author[0]>96 && (int)auptr->song->author[0]<123)
			{
			    auptr->song->author[0]-=32;
                        }
		     printf(" %u. %s (%u)\n",n,auptr->song->author,auptr->num);
		     if (n%18==0)
			{
			    printf("\n  Viberite avtora (enter - prodolzhenie vivoda spiska avtorov): ");
			    do
			       {
                                   fflush(stdin);
				   if (!strcmp(gets(buffer),STOP_STRING))
				      {
                                          i=0;
				          break;
				      }
				   check=sscanf(buffer,"%u",&i);
			       }
			       while (i<0 || i>n || check!=1);
			    if (i)
			       {
			           return(i);
			       }
			    clrscr();
	                    printf("\n-------------------------------------Avtori-------------------------------------\n");
			}
		     auptr=auptr->prev_song;
                 }
	     if (au_kol%18!=0)
		{
		    printf("\n  Viberite avtora (enter - vozvrat v menu): ");
		    do
		         {
                             fflush(stdin);
			     if (!strcmp(gets(buffer),STOP_STRING))
			        {
				    return(0);
				}
                             fflush(stdin);
			     check=sscanf(buffer,"%u",&i);
			 }
			 while (i<0 || i>n || check!=1);
			 if (i)
			    {
			        return(i);
			    }
		}
	 }

unsigned songlist_print (song *pbeg,unsigned kol)
	 {
	     song *ptr=pbeg;
	     char buffer[50];
	     unsigned IDs[5]={0,0,0,0,0},i=0,check;
	     clrscr();
	     printf(" Pesen v spiske: %5u\n",kol);
	     printf("----------------------------------Spisok pesen----------------------------------\n");
	     for (unsigned j=1;j<=kol;j++)
	           {
		       printf("%5d. Title: %s\n      Author: %s\n       Album: %s\n\n",j,ptr->title,ptr->author,ptr->album);
		       IDs[(j-1)%5]=j;
		       if (((j%5)==0) && j!=kol)
		          {
			      printf("  Vvedite nomer pesni dlya izmeneniya (enter - prodolzheniya vivoda): ");
		              do
				 {
                                     fflush(stdin);
				     if (!strcmp(gets(buffer),STOP_STRING))
				        {
                                            i=0;
				            break;
					}
				     fflush(stdin);
				     check=sscanf(buffer,"%u",&i);
			         }
				 while ((i!=IDs[0] && i!=IDs[1] && i!=IDs[2] && i!=IDs[3] && i!=IDs[4]) || i==0 || check!=1);
			      if (i)
			         {
				     return(i);
				 }
			      clrscr();
			      printf(" Pesen v spiske: %5u\n",kol);
			      printf("----------------------------------Spisok pesen----------------------------------\n");
			      for (int k=0;k<5;k++)
			          {
			              IDs[k]=0;
				  }
			  }
		       ptr=ptr->next;
                   }
	     if ((j-1)==kol)
	        {
		    printf("  Vvedite nomer pesni dlya izmeneniya (enter - vozvrat v menu): ");
		    do
		       {
			   fflush(stdin);
			   if (!strcmp(gets(buffer),STOP_STRING))
			      {
			          return(0);
			      }
			   fflush(stdin);
			   check=sscanf(buffer,"%u",&i);
		       }
		       while ((i!=IDs[0] && i!=IDs[1] && i!=IDs[2] && i!=IDs[3] && i!=IDs[4]) || i==0 || check!=1);
		    if (i)
		       {
		           return(i);
		       }
		}
	 }

void main()
     {
	 song *pbeg, *pend, *ptr;
	 author *au_beg, *searchlist_beg, *auptr;
	 unsigned n,kol=0,au_kol=0,select,num=0,found;
	 kol=songlist_open(pbeg,pend);
	 while (1)
	       {
		   if (kol>0)
		      {
			  au_kol=autosort(pbeg,pend,au_beg,kol);
		      }
		      else
                           {
			       au_kol=0;
                           }
	           do
	              {
		          select=main_menu(kol,au_kol);
	              }
		      while (select==0);
		   switch (select)
			  {
			      case 1: auptr=au_beg;
				      num=authorlist_print(au_beg,au_kol);
				      if (num==0)
                                         {
					     break;
                                         }
				      for (n=1; n<num; n++)
					  {
					      auptr=auptr->prev_song;
					  }
                                      ptr=auptr->song;
				      num=songlist_print(ptr,auptr->num);
				      if (num==0)
					 {
					     break;
					 }
				      ptr=auptr->song;
				      song_red(num,ptr,pend,kol);
				      break;

			      case 20: num=songlist_print(pbeg,kol);
				       if (num==0)
					  {
					      break;
					  }
				       song_red(num,pbeg,pend,kol);
				       break;

			      case 21: songlist_alfsort(1,pbeg,pend,kol);
				       num=songlist_print(pbeg,kol);
				       if (num==0)
					  {
					      break;
					  }
				       song_red(num,pbeg,pend,kol);
				       break;

			      case 22: songlist_alfsort(2,pbeg,pend,kol);
				       num=songlist_print(pbeg,kol);
				       if (num==0)
					  {
					      break;
					  }
				       song_red(num,pbeg,pend,kol);
				       break;

			      case 23: songlist_alfsort(3,pbeg,pend,kol);
				       num=songlist_print(pbeg,kol);
				       if (num==0)
					  {
					      break;
					  }
				       song_red(num,pbeg,pend,kol);
				       break;

			      case 31: found=search(31,pbeg,pend,searchlist_beg);
				       if (found==0)
					  {
					      break;
					  }
				       do
					  {
					      num=searchlist_print(searchlist_beg,found);
				              if (num==0)
					         {
					             break;
						 }
					      select=song_red(num,searchlist_beg,pbeg,pend,found,kol);
					      if (found==0)
						 {
						     break;
						 }
					  }
					  while (select==1);
				       break;

			      case 32: found=search(32,pbeg,pend,searchlist_beg);
				       if (found==0)
					  {
					      break;
					  }
				       do
					  {
					      num=searchlist_print(searchlist_beg,found);
				              if (num==0)
					         {
					             break;
						 }
					      select=song_red(num,searchlist_beg,pbeg,pend,found,kol);
					      if (found==0)
						 {
						     break;
						 }
					  }
					  while (select==1);
				       break;

			      case 33: found=search(33,pbeg,pend,searchlist_beg);
				       if (found==0)
					  {
					      break;
					  }
				       do
					  {
					      num=searchlist_print(searchlist_beg,found);
				              if (num==0)
					         {
					             break;
						 }
					      select=song_red(num,searchlist_beg,pbeg,pend,found,kol);
					      if (found==0)
						 {
						     break;
						 }
					  }
					  while (select==1);
				       break;

			      case 34: found=search(34,pbeg,pend,searchlist_beg);
				       if (found==0)
					  {
					      break;
					  }
				       do
					  {
					      num=searchlist_print(searchlist_beg,found);
					      if (num==0)
					         {
					             break;
						 }
					      select=song_red(num,searchlist_beg,pbeg,pend,found,kol);
					      if (found==0)
						 {
						     break;
                                                 }
					  }
					  while (select==1);
				       break;

			      case 4: add_song(pbeg,pend,kol);
				      break;

			      case 5: save(pbeg,kol);
                                      exit(0);

			      case 6: exit(0);
			  }
               }
     }  


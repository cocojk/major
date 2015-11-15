#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<sys/socket.h>
#include<arpa/inet.h>
#include<netdb.h>
#include<signal.h>
#include<fcntl.h>
#include<time.h>
#include<grp.h>
#include<pwd.h> 
#include<dirent.h>
#define CONNMAX 1
#define BYTES 1024
#define BUFFERSIZE 4096
void pathInfo (char * paths,int client);
void showls(char *path,int client,char* filename);
void dread(char * paths,int client);
void wrcontent(char*PATH,int client);
char *ROOT;
char *PORT;
int listenfd, clients[CONNMAX];
void error(char *);
void startServer(char *);
void respond(int);

int main(int argc, char* argv[])
{
		struct sockaddr_in clientaddr;
		socklen_t addrlen;
		char c;


		//Default Values PATH = ~/ and PORT=10000
		int slot=0;

		//Parsing the command line arguments
		while ((c = getopt (argc, argv, "p:r:")) != -1)
				switch (c)
				{
						case 'r':
								ROOT = malloc(strlen(optarg));
								strcpy(ROOT,optarg);
								break;
						case 'p':
								PORT = malloc(strlen(optarg));
								strcpy(PORT,optarg);
								break;
						case '?':
								fprintf(stderr,"Wrong arguments given!!!\n");
								exit(1);
						default:
								exit(1);
				}

		printf("Server started at port no. %s%s%s with root directory as %s%s%s\n","\033[92m",PORT,"\033[0m","\033[92m",ROOT,"\033[0m");
		// Setting all elements to -1: signifies there is no client connected
		int i;
		for (i=0; i<CONNMAX; i++)
				clients[i]=-1;







		startServer(PORT);


		pid_t pid;

		pid_t chpid;
		int statusch;


				while(1)
				{
		addrlen = sizeof(clientaddr);
		clients[slot] = accept (listenfd, (struct sockaddr *) &clientaddr, &addrlen);
		

		if (clients[slot]<0)
		{
			error ("accept() error");
		
			break;
		}
		else if((pid = fork())<0)
						{

						printf("fork error \n");

		//All further send and recieve operations are DISABLED...
		close(clients[slot]);
		clients[slot]=-1;
		continue;
		}
		else if(pid==0)
		{



	
		 					
		respond(slot); 

									//wait 
			
			}
			else
			{


		//All further send and recieve operations are DISABLED...
		close(clients[slot]);
		clients[slot]=-1;
		continue;
		}

		}
		 
		return 0;


}

//start server
void startServer(char *port)
{
		struct addrinfo hints, *res, *p;
		

		// getaddrinfo for host
		memset (&hints, 0, sizeof(hints));
		hints.ai_family = AF_INET;
		hints.ai_socktype = SOCK_STREAM;
		hints.ai_flags = AI_PASSIVE;
		if (getaddrinfo( NULL, port, &hints, &res) != 0)
		{
				perror ("getaddrinfo() error");
				exit(1);
		}
		// socket and bind
		for (p = res; p!=NULL; p=p->ai_next)
		{
				listenfd = socket (p->ai_family, p->ai_socktype, 0);
				if (listenfd == -1) continue;
				if (bind(listenfd, p->ai_addr, p->ai_addrlen) == 0) break;
		}
		if (p==NULL)
		{
				perror ("socket() or bind()");
				exit(1);
		}

		freeaddrinfo(res);

		// listen for incoming connections
		if ( listen (listenfd, 1000000) != 0 )
		{
				perror("listen() error");
				exit(1);
		}
}

//client connection
void respond(int n)
{
		char mesg[99999], *reqline[4], data_to_send[BYTES], *path, html[999];
		int rcvd, fd, bytes_read;

		memset( (void*)mesg, (int)'\0', 99999 );

		//rcvd=recv(clients[n], mesg, 99999, 0);
		rcvd=read(clients[n], mesg, 99999);

		if (rcvd<0)    // receive error
				fprintf(stderr,("recv() error\n"));
		else if (rcvd==0)    // receive socket closed
				fprintf(stderr,"Client disconnected upexpectedly.\n");
		else    // message received
		{
				printf("%s", mesg);
				reqline[0] = strtok (mesg, " \t\n");
				if ( strncmp(reqline[0], "GET\0", 4)==0 )
				{

						reqline[1] = strtok (NULL, "= \t\n");
						reqline[2] = strtok (NULL, "= \t\n ");
						reqline[3] = strtok (NULL, " \t\n");
						if(strncmp(reqline[1],"/?param",7)==0)
						{
								if ((strncmp( reqline[3], "HTTP/1.0", 8)!=0) &&( strncmp( reqline[3], "HTTP/1.1", 8)!=0) )
								{
										write(clients[n], "HTTP/1.0 400 Bad Request\n", 25);
								}
								else
								{                
										//     char *html1 = "<html><body>Hellow World";
										//   char *html2 = "</body></html>";
										//  printf("file: %s\n", path);
										//	sprintf(html,"%s path is %s port is %s %s\0", html1,ROOT,PORT,html2); 


										pathInfo(reqline[2],clients[n]);

								}
						}
						else
						{

								if ((strncmp( reqline[2], "HTTP/1.0", 8)!=0) &&( strncmp( reqline[2], "HTTP/1.1", 8)!=0) )
								{
										write(clients[n], "HTTP/1.0 400 Bad Request\n", 25);
								}
								else
								{                
										//     char *html1 = "<html><body>Hellow World";
										//   char *html2 = "</body></html>";
										//  printf("file: %s\n", path);
										//	sprintf(html,"%s path is %s port is %s %s\0", html1,ROOT,PORT,html2); 
										//       write(clients[n], html,strlen(html));
										//	write(clients[n],reqline[1],strlen(reqline[1]));
										char *helloclient = "hello \n";
										write(clients[n],helloclient,strlen(helloclient));

								}




						}
				}
		}



		//wait


		
		
/*		int nummessage =1;
	while(nummessage)
	{

	
			char readmessage[4096];
		nummessage =read(clients[n],readmessage,4096);
		if(nummessage<0)
		{

				printf("read error \n");
				break;
		}
	}
*/		
		shutdown (clients[n], SHUT_RDWR);      //All further send and recieve operations are DISABLED...
		close(clients[n]);
		clients[n]=-1;


}

void pathInfo (char * paths,int client)
{
		struct stat pathnames;
		stat(paths,&pathnames);


		int i=0;
		if(S_ISREG(pathnames.st_mode))
				i=0;
		else if (S_ISDIR(pathnames.st_mode))
				i=1;
		else if (S_ISCHR(pathnames.st_mode))
				i=2;
		else if (S_ISBLK(pathnames.st_mode))
				i=3;
		else if (S_ISFIFO(pathnames.st_mode))
				i=4;
		else if (S_ISLNK(pathnames.st_mode))
				i=5;
		else if (S_ISSOCK(pathnames.st_mode))
				i=6;


		switch(i)
		{
				case 1:

						dread(paths,client);

						break;

				default:
						wrcontent(paths,client);
						break;
		}
}


void wrcontent(char*PATH,int client)
{
		int i;
		int j;
		char *info[BUFFERSIZE];
		if((i=open(PATH,O_RDONLY))>=0)
		{

				while((j=read(i,info,BUFFERSIZE))>0)
				{
						if((write(client,info,j))!=j)
								printf("write error");

				}

				if(j<0)
						printf("read error");




		}

		if(i<0)
				printf("open error");

		close(i);

}

void dread(char * paths,int client)
{

		int i=0;
		DIR *dirp;
		struct dirent *dp;
		if((dirp =opendir(paths))>=0)
		{
				while(dp = readdir(dirp))
				{


						char finalpath[BUFFERSIZE]={};

						strcpy(finalpath,paths);

						strcat(finalpath,dp->d_name);

						showls(finalpath,client,dp->d_name);
				}


				//	printf("%s \n",finalpath);
				//	printf("%d",(int)(sizeof(finalpath)/sizeof(char)));
				//		write(client,finalpath,strlen(finalpath));





				//	}





}
else
{ printf("error");


}

closedir(dirp);

}

void showls(char *path,int client,char *filename)
{

		char info[BUFFERSIZE]={};
		struct stat pathnames;
		stat(path,&pathnames);


		if(S_ISREG(pathnames.st_mode))
				strcat(info,"-");
		else if (S_ISDIR(pathnames.st_mode))
				strcat(info,"d");
		else if (S_ISCHR(pathnames.st_mode))
				strcat(info,"c");
		else if (S_ISBLK(pathnames.st_mode))
				strcat(info,"b");
		else if (S_ISFIFO(pathnames.st_mode))
				strcat(info,"f");
		else if (S_ISLNK(pathnames.st_mode))
				strcat(info,"l");
		else if (S_ISSOCK(pathnames.st_mode))
				strcat(info,"s");

		if((pathnames.st_mode&S_IRUSR)==S_IRUSR)
				strcat(info,"r");
		else
				strcat(info,"-");


		if((pathnames.st_mode&S_IWUSR)==S_IWUSR)
				strcat(info,"w");
		else
				strcat(info,"-");


		if((pathnames.st_mode&S_IXUSR)==S_IXUSR)
				strcat(info,"x");
		else
				strcat(info,"-");
		if((pathnames.st_mode&S_IRGRP)==S_IRGRP)
				strcat(info,"r");
		else
				strcat(info,"-");

		if((pathnames.st_mode&S_IWGRP)==S_IWGRP)
				strcat(info,"w");
		else
				strcat(info,"-");


		if((pathnames.st_mode&S_IXGRP)==S_IXGRP)
				strcat(info,"x");
		else
				strcat(info,"-");


		if((pathnames.st_mode&S_IROTH)==S_IROTH)
				strcat(info,"r");
		else
				strcat(info,"-");
		if((pathnames.st_mode&S_IWOTH)==S_IWOTH)
				strcat(info,"w");
		else
				strcat(info,"-");

		if((pathnames.st_mode&S_IXOTH)==S_IXOTH)
				strcat(info,"x");
		else
				strcat(info,"-");

		char p[5];
		int nlink = pathnames.st_nlink;
		sprintf(p," %d ",nlink);
		strcat(info,p);

		struct passwd * usrid;
		usrid = getpwuid(pathnames.st_uid);

		// usrid->pw_name;
		strcat(info,usrid->pw_name);
		struct group * grpid;
		grpid = getgrgid(pathnames.st_gid);
		strcat(info," ");
		strcat(info,grpid->gr_name);
		int nsize = pathnames.st_size;
		char tempsize[10];
		sprintf(tempsize,"  %d",nsize);
		strcat(info,tempsize);
		struct tm* filetime;
		filetime = localtime(&(pathnames.st_mtime));
		char temptime[20];
		sprintf(temptime," %d-%d %d:%d ",filetime->tm_mon+1,filetime->tm_mday,filetime->tm_hour,filetime->tm_min);
		strcat(info,temptime);
		strcat(info,filename);



		strcat(info,"\n");
		write(client,info,strlen(info));


}

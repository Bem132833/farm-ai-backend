#include <iostream>
using namespace std;
int max ( int a, int b , int c);
int min( int &x, int &y , int &z);
int main(){
    int a, b, c;
    cout<< "enter three numbers:"<< endl;
    cin>> a>>b>>c;
     
     cout<<"enter three numbers"<<endl;
     cin>>a>>b>>c;
     max( a,b,c);
  int x,y,z;
  cout<<" enter three numbers:"<<endl;
 cin>>x>>y>>z;

  cout<<" enter three numbers:"<< endl;
  cin>>x>>y>>z;
  min( x,y,z  );

    return 0 ;
}
int max (int a, int b, int c){
  if ( a>b && a>c){
    cout<<"a is the maximum number"<<a<<endl;

  }
  else if (b>a && b>c){
 cout<<"b is the maximum number"<< b<< endl;
}
 else {
    cout<<"c is the maximum number"<<c<< endl;
 }
}



int min(int &x , int &y, int &z ){
    if( x<y && x<z) {
       cout<<" the smallest number is x"<<x;

    }
    else if (y<x && y<z){
        cout<<"the smallest number is y"<<y;



    }else{
        cout<<"the smallest numbe is z"<<z;
    }
}
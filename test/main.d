import std.stdio;
import dmdspec;

void main() {

auto bla = subjectFactory( 5 );
bla.print();

auto ble = new GenSubject!( string )( "kshndjkashn" );
ble.print(); 

}

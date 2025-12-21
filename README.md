Shell-BashKit-OOP
================================

> [Aeon Digital](http://www.aeondigital.com.br)  
> rianna@aeondigital.com.br

&nbsp;

Simple OOP simulation in bash.


&nbsp;
&nbsp;


________________________________________________________________________________

## Install
### Shrink version 

Open your shell (Bash compatible) and use:


``` shell
  # Download dependency
  curl -O "https://raw.githubusercontent.com/AeonDigital/Shell-BashKit/main/package-shell-bashkit.sh"

  curl -O "https://raw.githubusercontent.com/AeonDigital/Shell-BashKit-OOP/main/package-shell-bashkit-oop.sh"
```


&nbsp;
&nbsp;


________________________________________________________________________________

## Example

In the 'example' directory, there is the implementation of a 'burl' (bash url) 
class to make HTTP requests using pure bash.

This is the best usage 'documentation' we can have at the moment.

Below is the main snippet of the burl class definition:

``` shell
  #
  # Definition of type
  objectTypeCreate burl burlConstructor

  #
  # Properties
  objectTypeSetProperty burl assoc header "" burlSetHeader burlGetHeader
  objectTypeSetProperty burl string verb "GET" burlSetVerb
  objectTypeSetProperty burl string protocol "http" burlSetProtocol
  objectTypeSetProperty burl string protocolVersion "1.1" burlSetProtocolVersion
  objectTypeSetProperty burl string domain "" burlSetDomain
  objectTypeSetProperty burl int port "80" burlSetPort
  objectTypeSetProperty burl string path "/" burlSetPath
  objectTypeSetProperty burl assoc querystring "" burlSetQuerystring
  objectTypeSetProperty burl string fragment ""

  #
  # Methods
  objectTypeSetMethod burl clear burlClear
  objectTypeSetMethod burl printHeaders burlPrintHeaders
  objectTypeSetMethod burl printQuerystrings burlPrintQuerystrings
  objectTypeSetMethod burl setURL burlSetURL
  objectTypeSetMethod burl printURL burlPrintURL
  objectTypeSetMethod burl request burlRequest

  #
  # End definition
  objectTypeCreateEnd burl
```


### Test the BURL example

We created a test script that performs several operations to be used in a 
simple test that consists of making a GET request to the homepage of our site.

You can run the tests after downloading the project and its dependency and then 
execute:

``` shell
  . "package-shell-bashkit.sh"
  . exec.sh

  . "example/burl.sh"
  . "example/burl-test.sh"
  burlLiveTest
```


&nbsp;
&nbsp;


________________________________________________________________________________

## Licence

This project is offered under the [MIT license](LICENCE.md).
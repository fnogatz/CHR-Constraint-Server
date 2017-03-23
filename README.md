# A Persistent CHR Webserver

Example implementation of a Prolog webserver as an incremental constraint store for Constraint Handling Rules (CHR). It creates a sub-thread to hold all the persistent constraints. As an example, the classical greatest common divisor CHR example program is used.

## Example

Here is an example on how to start the example webserver on port 8080:

```sh
> swipl -q -s server.pl -g 'server(8080)'
```

You can add new constraints by simple calling the root URL:

```sh
> curl -X GET http://localhost:8080/?gcd=12
12
> curl -X GET http://localhost:8080/?gcd=8
4
> curl -X GET http://localhost:8080/?gcd=16
4
```

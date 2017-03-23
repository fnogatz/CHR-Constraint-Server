# A Persistent CHR Webserver

Example implementation of a Prolog webserver as an incremental constraint store for Constraint Handling Rules (CHR). It creates a sub-thread to hold all the persistent constraints.

## Usage

Here is an example on how to start the example webserver on port 8080:

```sh
> swipl -q -s server.pl -g 'server(8080)'
```

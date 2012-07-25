Threequel
=========

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jackross/threequel)
[![Build Status](https://secure.travis-ci.org/jackross/threequel.png)](http://travis-ci.org/jackross/threequel)


Modules
-------

#### Commandant

Objectify your SQL scripts.  Take blocks of SQL from an .sql script and turn them into class methods on your models/classes.

    include Threequel::Commandant


#### Servant

Run a series of co-dependant .sql scripts to perform tasks.


Classes
-------

#### SQL::CommandHash
A Hash subclass that maps to Commandant SQL class methods.  Keys are the SQL class method names and Values are SQL::Command objects.

#### SQL::Command
A class that can execute a series of SQL blocks on a connection.  Wraps a SQL::StatementArray.

#### SQL::StatementArray
An Array subclass that splits a 

#### SQL::Statement
A class that can execute a single SQL block on a connection.

#### Logging

Adds logging to any instance method.

    extend Threequel::Logging
    add_logging_to :my_method

#### LoggingHandler

#### ConsoleLogger

#### DBLogger

#### DBLoggerStorage

#### Timer

Wrap code in a Timer.clock block and get timing information about your code block.

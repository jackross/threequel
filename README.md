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
A class that can execute a series of SQL blocks on a specified connection.

````ruby
sql = <<-"SQL"
 CREATE TABLE dbo.foo (bar varchar(20) NOT NULL);
 GO

 DROP TABLE dbo.foo;
 GO
SQL

connection = ActiveRecord::Base.connection

cmd = Threequel::SQL::Command.new(sql, "My Command")
cmd.execute_on connection

# SQL (23.6ms)  CREATE TABLE dbo.foo (bar varchar(20) NOT NULL);
# SQL (37.1ms)  DROP TABLE dbo.foo;
# => {:message=>"Command executed successfully", :status=>:success} 

# or
Threequel::SQL::Command.new(sql, "My Command") do |cmd|
  cmd.execute_on connection
end

# SQL (23.6ms)  CREATE TABLE dbo.foo (bar varchar(20) NOT NULL);
# SQL (37.1ms)  DROP TABLE dbo.foo;
# => {:message=>"Command executed successfully", :status=>:success} 
````

#### Logging

Adds logging to any instance method.

````ruby
sql = <<-"SQL"
 CREATE TABLE dbo.foo (bar varchar(20) NOT NULL);
 GO

 DROP TABLE dbo.foo;
 GO
SQL

connection = ActiveRecord::Base.connection

Threequel::SQL::Command.new(sql, "My Command") do |cmd|
  cmd.extend Threequel::Logging
  cmd.add_logging_to :execute_on, :console
  cmd.execute_on connection
end
# -- Starting execution of My Command at 2012-07-25 17:13:43 -0400
# SQL (23.6ms)  CREATE TABLE dbo.foo (bar varchar(20) NOT NULL);
# SQL (37.1ms)  DROP TABLE dbo.foo;
# -- Finishing execution of My Command at 2012-07-25 17:13:43 -0400 in 0.006583 seconds
# => [#<Threequel::ConsoleLogger:0x007ffc47f95240 @attributes={:sql=>"CREATE TABLE dbo.foo (bar varchar(20) NOT NULL);\nGO\n\nDROP TABLE dbo.foo;\nGO\n", :command=>"My Command", :statement=>nil, :name=>"My Command", :started_at=>2012-07-25 17:13:43 -0400, :finished_at=>2012-07-25 17:13:43 -0400, :duration=>0.006583, :stage=>:finished, :message=>"Command executed successfully", :status=>:success}>]
````

#### LoggingHandler

#### ConsoleLogger

#### DBLogger

#### DBLoggerStorage

#### Timer

Wrap code in a Timer.clock block and get timing information about your code block.

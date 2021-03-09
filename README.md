# Getting Started
### Description
The assessment-engine is an orchestration service which aggregates user's information and decides the user eligibility

## Starting the service
### Dependencies
We need to have the following services pre installed.
* Docker
* Docker-compose

### Properties and env files
We need to have the following files created similar to the sample files at the specified location before starting the service,
* src/main/resources/liquibase/config/liquibase.properties
* src/main/resources/application.env
* src/main/resources/application.yaml

### Start
`make start` cmd will start the service with required dependent services like postgres.

By default swagger-ui can be opened at http://127.0.0.1:28080/swagger-ui.html# after starting the service.

### Debug
In `application-sample.env` JAVA_TOOL_OPTIONS is used to setup remote debugging.

If the same env is set then remote debugging will be enabled on port `28000` of docker host

### Stop
`make stop` cmd will stop the service along with dependent services like postgres

For more commands look into the Makefile.

## Liquibase Migrations
Liquibase is integrated for database migrations. Below is the overview of liquibase commands

### Generate change log
`make mvn CMD=liquibase:generateChangeLog`

This is used to generate change log which contains all the schema changes in the database until now.
So this command is used when integrating liquibase for the first time with an existing database.
The file that is modified is indicated by `outputChangeLogFile` in liquibase.properties 

### Sync change log
`make mvn CMD=liquibase:changelogSync`

This is used to sync the changes in the changeLog file to the db without applying any schema changes.
Useful when the db changes are done manually (or without using liquibase) and now we need to sync it for tracking.
This can be used when integrating the db with liquibase for the first time along with `generateChangeLog` to fake and sync all the existing changes without actually applying the changes.
The file that is used to pick up the schema changes to sync can be indicated by `changeLogFile` in liquibase.properties

### Diff change log
`make mvn CMD=liquibase:diff`

This is used to generate change log which contains diff between database and referenceURL configured in liquibase.properties.
If liquibase.properties is generated using sampe we will have referenceURL configured to our code.
So to generate migration(changeSet) for our schema changes in the code we can use the diff command.
The file that is modified is indicated by `diffChangeLogFile` in liquibase.properties


### Update change log
`make mvn CMD=liquibase:update`

This is used to update the db with the schema changes in the change log file.
The file that is used to pick up the schema changes to apply the changes and sync can be indicated by `changeLogFile` in liquibase.properties.

**Always review the changeLog before actually applying them to the db.**


### Rollback
`make mvn CMD="liquibase:rollback -Dliquibase.rollbackCount=1"`

This is used to rollback migrations.
Rollback can be done using count, tag or date.
The sample command given does rollback by count.


### Reference Documentation
For further reference, please consider the following sections:

* [Official Apache Maven documentation](https://maven.apache.org/guides/index.html)
* [Spring Boot Maven Plugin Reference Guide](https://docs.spring.io/spring-boot/docs/2.4.3/maven-plugin/reference/html/)
* [Create an OCI image](https://docs.spring.io/spring-boot/docs/2.4.3/maven-plugin/reference/html/#build-image)
* [Spring Data JDBC](https://docs.spring.io/spring-data/jdbc/docs/current/reference/html/)
* [Liquibase Migration](https://docs.spring.io/spring-boot/docs/2.4.3/reference/htmlsingle/#howto-execute-liquibase-database-migrations-on-startup)
* [Spring Data JPA](https://docs.spring.io/spring-boot/docs/2.4.3/reference/htmlsingle/#boot-features-jpa-and-spring-data)

### Guides
The following guides illustrate how to use some features concretely:

* [Using Spring Data JDBC](https://github.com/spring-projects/spring-data-examples/tree/master/jdbc/basics)
* [Accessing Data with JPA](https://spring.io/guides/gs/accessing-data-jpa/)


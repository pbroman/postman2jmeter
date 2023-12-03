# postman2jmeter
A jsonnet implementation transforming postman collections and environments into jmx files for jmeter.

## Use Case
You maintain postman collections and environments to tests the correctness of your API. And you want to perform load 
testing of the applications as well, without getting the extra effort of maintaining jmeter tests too.
Then you can use this script to transform postman collections (or parts of them) and environments to jmeter jmx files. 

## Usage

Precondition: jsonnet is installed (TODO: wrap in Dockerfile)  
`./postman2jmeter.sh -h`:
```
Usage: ./postman2jmeter.sh [OPTIONS]

Options:
  -c, --collection           Path to postman collection file (mandatory)
  -e, --environment          Path to postman environment file (mandatory)
  -t, --target_file          Path to target jmx file to be created (mandatory)
  -p, --prefix_variables     Space separated string of variables to be prefixed with thread number, e.g. "var1 var2 var3" (optional)
  -s, --suffix_variables     Space separated string of variables to be suffixed with thread number, e.g. "var1 var2 var3" (optional)
  -h, --help                 Show this help
```

### Suffixing or prefixing variables with the thread number
If you are i.e. running CRUD tests is postman, such as adding a user with a given name, updating it, and deleting it,
this would of course not work with parallel threads. To make this possible, you have the option to add the thread number
to the variables you want using the -s (for suffixing) or -p (prefixing) properties. Example:
```
postman2jmeter.sh -p "var1 var2" -s "var3 var4" -c <collection> -e <env> -t <target_file>
```

### Variables for jmeter cli
All postman requests are put in a jmeter thread group with the following properties:

| Property          | Value                   |
|-------------------|-------------------------|
| Number of Threads | ${__P(thread_count, 1)} |
| Ramp-up period    | ${__P(rampup, 1)}       |
| Loop Count        | ${__P(loop_count, 1)}   |

Additionally, there is a global constant timer with thread delay `${__P(global_timer, 100)}`.

Thus, you may control thread count, loop count, ramp-up time, and delay before each request using the `-J` property:
```
jmeter -Jthread_count=<number of threads> -Jloop_count=<number of threads> -Jrampup=<ramp-up time> -Jglobal_timer=<delay in ms>
```

Also, all variables in the postman collection and environment used to create the jmeter file that do not have a value 
are given the value `${__P(variable_key, '')}`. Thus, you may set these values running the test.   


## Preparing postman collections
You don't *have* to prepare your postman collections, but you can.  

### Skipping folders or requests
If you want to skip folders or requests in the jmeter transformation, just add the keyword `jmeter_skip` to the description of the folder/request.

### Transforming parts of the postman tests to a jmeter JSR223PostProcessor
The general assumption is that you don't want the postman tests in you jmeter test. So normally, these will be ignored.
But sometimes you need to set variables from response bodies or headers. 

To accomplish this, put a trailing comment `//jmeter_keep` on all postman test javascript code lines you wish to keep. 
These lines are then mapped to groovy code using regular expressions during the preprocessing in the [wrapping bash script](src/postman2jmeter.sh). 

If there is a `//jmeter_keep` comment in the postman test code, a JSR223PostProcessor using groovy will be created. 
This postprocessor always contains a JsonSlurper and a headers array containing the response headers 
([the code is here](src/jmx_templates/sampler/helpers/post_processing.libsonnet))

Example: if you have postman test code looking like this:
```
pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
});
pm.test("A JSON object is returned", function () {
    const responseJson = pm.response.json();                //jmeter_keep
    pm.expect(responseJson).to.be.an("object");
    pm.environment.set("someVar", responseJson.someVar);    //jmeter_keep
});
pm.test("CorrelationID header is present", function () {
    pm.response.to.have.header("CorrelationID");
    pm.environment.set("corrId", pm.response.headers.get("CorrelationID")); //jmeter_keep
});
```
you will get a JSR223PostProcessor with this groovy code:
```
import groovy.json.JsonSlurper

def jsonSlurper = new JsonSlurper();
def headers = prev.getResponseHeaders().split('\n').inject([:]) { out, header ->
    if (header.contains(':')) {
        header.split(':').with {
            out[it[0].trim()] = it[1].trim()
        }
    }
    out
}

    def responseJson = jsonSlurper.parseText(prev.getResponseDataAsString());  //jmeter_keep
    vars.put("someVar", responseJson.someVar);    //jmeter_keep
    vars.put("corrId", headers["CorrelationID"]); //jmeter_keep
```

### Jmeter response assertions
If you want requests with response status other than 200s in your jmeter test, you need a ResponseAssertion for jmeter to interpret the result correctly.
To get this, put a comment `//jmeter_status: <status code regex>` in the postman test javascript code.

## Cookbook
This implementation certainly doesn't cover every aspect of postman or jmeter. But if you have additional needs, 
it is fairly easy to extend the implementation.

### Basic concept
Postman collections and environments are defined in JSON, and jmeter tests in JMX, which is an XML format.

The implementation resides on the capability of [jsonnet](https://jsonnet.org/) to produce XML provided that the jsonnet 
templates are in jsonML. Any XML (such as .jmx files) can eaily be transformed to jsonML using [this XSLT](https://raw.githubusercontent.com/mckamey/jsonml/master/jsonml.xslt).
Once you have JMX in jsonML format, you chop it up and put the pieces as templates in jsonnet functions.

Then you wrap the postman json files in a `_config` object and use them as configuration for the jsonnet templates.
That's basically it. 

### Extending it
So if you wish to extend the implementation, feel free to fork this repository and do the following:
* Write (or extend) a jmeter test with the components you need
* Transform the .jmx file into jsonML
* Find the parts you want and put them in jsonnet functions (don't forget the `hashtree` trailing every jmeter component). 
You will find [examples here](src/jmx_templates).
* Bind the templates into the overall implementation 
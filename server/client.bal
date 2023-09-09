import ballerina/http;

public isolated client class Client {
    final http:Client clientEp;
    # Gets invoked to initialize the `connector`.
    #
    # + clientConfig - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(http:ClientConfiguration clientConfig =  {}, string serviceUrl = "http://localhost:7070/api/v1") returns error? {
        http:Client httpEp = check new (serviceUrl, clientConfig);
        self.clientEp = httpEp;
        return;
    }
    # Get all lecturers
    #
    # + return - A list of all lecturers 
    remote isolated function getAll() returns Lecturer[]|error {
        string resourcePath = string `/lecturers`;
        Lecturer[] response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Create a new lecturer
    #
    # + return - Lecturer successfully created 
    remote isolated function create(Lecturer payload) returns InlineResponse201|error {
        string resourcePath = string `/lecturers`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody, "application/json");
        InlineResponse201 response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Get a single lecturer
    #
    # + staffnumber - staff number of the lecturer 
    # + return - lecturer response 
    remote isolated function getLecturer(string staffnumber) returns Lecturer|error {
        string resourcePath = string `/lecturer/${getEncodedUri(staffnumber)}`;
        Lecturer response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Update an existing lecturer
    #
    # + staffnumber - staff number of the lecturer 
    # + return - Lecturer was successfully updated 
    remote isolated function updateLecturer(string staffnumber, Lecturer payload) returns Lecturer|error {
        string resourcePath = string `/lecturer/${getEncodedUri(staffnumber)}`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody, "application/json");
        Lecturer response = check self.clientEp->put(resourcePath, request);
        return response;
    }
    # Delete an existing lecturer
    #
    # + staffnumber - staff number of the lecturer 
    # + return - Lecturer was successfully deleted 
    remote isolated function deleteLecturer(string staffnumber) returns http:Response|error {
        string resourcePath = string `/lecturer/${getEncodedUri(staffnumber)}`;
        http:Response response = check self.clientEp->delete(resourcePath);
        return response;
    }
    # Get all courses taught by a lecturer
    #
    # + staffnumber - staff number of the lecturer 
    # + return - A list of courses taught by the lecturer 
    remote isolated function getLecturerCourses(string staffnumber) returns Course[]|error {
        string resourcePath = string `/lecturer/${getEncodedUri(staffnumber)}/courses`;
        Course[] response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Get all lecturers in the same office
    #
    # + staffnumber - staff number of the lecturer 
    # + return - A list of lecturers in the same office 
    remote isolated function getLecturersInOffice(string staffnumber) returns Lecturer[]|error {
        string resourcePath = string `/lecturer/${getEncodedUri(staffnumber)}/office`;
        Lecturer[] response = check self.clientEp->get(resourcePath);
        return response;
    }
}

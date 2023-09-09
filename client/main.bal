import ballerina/io;
import ballerina/lang.'int as ints;
import ballerina/http;

public type Lecturer record {
    string staffnumber?;
    string officenumber?;
    string staffname?;
    string title?;
    Course[] courses;
};

public type Course record {
    string coursename?;
    string coursecode?;
    int nqflevel?;
};

final http:Client clientEndpoint = check new ("http://localhost:7070/api/v1");

function GetLecturerRequest() returns error? {
    io:print("");
    string staffNumber = io:readln("Enter Staff Number of the Lecturer: ");
    json|string resp = check clientEndpoint->get("/lecturer/" + staffNumber);
    io:println(resp.toJsonString());
    io:println("");
}

function GetAllLecturersRequest() returns error? {
    io:println("");
    json resp = check clientEndpoint->get("/lecturers");
    io:println(resp.toJsonString());
    io:println("");
}

function CreateLecturerRequest() returns error? {
    io:println("");
    string staffNumber = io:readln("Enter Staff Number: ");
    string officeNumber = io:readln("Enter Office Number: ");
    string staffName = io:readln("Enter Staff Name: ");
    string title = io:readln("Enter Title: ");

    Course[] courses = [];

    string noOfCourses1 = io:readln("Enter Number of Courses: ");
    int noOfCourses = check ints:fromString(noOfCourses1);

    foreach int i in 1 ... noOfCourses {
        io:print(i, ". ");
        string courseName = io:readln("Enter Course Name: ");
        string courseCode = io:readln("Enter Course Code: ");
        string nqfLevel1 = io:readln("Enter NQF Level: ");
        int nqfLevel = check ints:fromString(nqfLevel1);

        Course course = {
            coursename: courseName,
            coursecode: courseCode,
            nqflevel: nqfLevel
        };

        courses.push(course);
    }

    Lecturer postLecturer = {
        staffnumber: staffNumber,
        officenumber: officeNumber,
        staffname: staffName,
        title: title,
        courses: courses
    };

    io:println("\nPOST request:");
    json resp = check clientEndpoint->post("/lecturers", postLecturer);
    io:println(resp.toJsonString());
    io:println("");
}

function UpdateLecturerRequest() returns error? {
    io:println("");
    string staffNumber = io:readln("Enter Staff Number of the Lecturer to Update: ");
    string officeNumber = io:readln("Enter New Office Number: ");
    string staffName = io:readln("Enter New Staff Name: ");
    string title = io:readln("Enter New Title: ");

    // You can add code to update the courses if needed

    Lecturer updateLecturer = {
        staffnumber: staffNumber,
        officenumber: officeNumber,
        staffname: staffName,
        title: title,
        courses: [] // Add the updated courses here if needed
    };

    io:println("\nPUT request:");
    json resp = check clientEndpoint->put("/lecturer/" + staffNumber, updateLecturer);
    io:println(resp.toJsonString());
    io:println("");
}

function DeleteLecturerRequest() returns error? {
    io:println("");
    string staffNumber = io:readln("Enter Staff Number of the Lecturer to Delete: ");
    json|string resp = check clientEndpoint->delete("/lecturer/" + staffNumber);
    io:println(resp.toJsonString());
    io:println("");
}

function GetLecturersByCourseRequest() returns error? {
    io:println("");
    string courseCode = io:readln("Enter Course Code: ");
    json resp = check clientEndpoint->get("/courses/" + courseCode);
    io:println(resp.toJsonString());
    io:println("");
}

function GetLecturersByOfficeRequest() returns error? {
    io:println("");
    string officeNumber = io:readln("Enter Office Number: ");
    json resp = check clientEndpoint->get("/office/" + officeNumber);
    io:println(resp.toJsonString());
    io:println("");
}

public function main() returns error? {
    boolean cont = true;

    while cont == true {
        io:println("Choose one of the Following Options: ");
        io:println("1. Get All Lecturers (GET)");
        io:println("2. Get A Single Lecturer (GET)");
        io:println("3. Create a Lecturer (POST)");
        io:println("4. Update a Lecturer (PUT)");
        io:println("5. Delete a Lecturer (DELETE)");
        io:println("6. Get Lecturers by Course (GET)");
        io:println("7. Get Lecturers by Office (GET)");
        string ans = io:readln("Which Option Would you like: ");
        io:println("");
        int res1 = check ints:fromString(ans);

        if res1 == 1 {
            io:println(GetAllLecturersRequest());
        } else if res1 == 2 {
            io:println(GetLecturerRequest());
        } else if res1 == 3 {
            io:println(CreateLecturerRequest());
        } else if res1 == 4 {
            io:println(UpdateLecturerRequest());
        } else if res1 == 5 {
            io:println(DeleteLecturerRequest());
        } else if res1 == 6 {
            io:println(GetLecturersByCourseRequest());
        } else if res1 == 7 {
            io:println(GetLecturersByOfficeRequest());
        } else {
            io:println("Please pick a number from 1-7");
            cont = true;
        }

        io:print("");
        string answer1 = io:readln("Do you want to call another function? y/n: ");

        if answer1 == "y" {
            cont = true;
        } else {
            cont = false;
        }
    }
}


import ballerina/http;

listener http:Listener ep0 = new (7070, config = {host: "localhost"});

public type Lecturer record {
    # the staff number of the lecturer
    string staffnumber?;
    # the office number of the lecturer
    string officenumber?;
    # the name of the lecturer
    string staffname?;
    # the title of the lecturer
    string title?;
    # Array of courses taught by the lecturer
    Course[] courses;
};

public type Course record {
    # the course name
    string coursename?;
    # the course code
    string coursecode?;
    # the NQF level of the course
    int nqflevel?;
};

public Lecturer[] lecturers = [
    {
        "staffnumber": "L1",
        "officenumber": "Office A",
        "staffname": "Dr. John Smith",
        "title": "Professor",
        "courses": [
            {
                "coursename": "Data Structures and Algorithms",
                "coursecode": "DSA",
                "nqflevel": 7
            }
        ]
    },
    {
        "staffnumber": "L2",
        "officenumber": "OffA",
        "staffname": "Dr. Sarah Johnson",
        "title": "Associate Professor",
        "courses": [
            {
                "coursename": "Software Engineering",
                "coursecode": "SE",
                "nqflevel": 6
            }
        ]
    },
    {
        "staffnumber": "L3",
        "officenumber": "OffA",
        "staffname": "Prof. Michael Brown",
        "title": "Professor",
        "courses": [
            {
                "coursename": "Programming Fundamentals",
                "coursecode": "DSA",
                "nqflevel": 5
            }
        ]
    },
    {
        "staffnumber": "5",
        "officenumber": "OffB",
        "staffname": "Dr. Emily Davis",
        "title": "Associate Professor",
        "courses": [
            {
                "coursename": "Database Systems",
                "coursecode": "DBS",
                "nqflevel": 6
            }
        ]
    }
];

service /api/v1 on ep0 {
    resource function get lecturers() returns Lecturer[] {
        return lecturers;
    }
    resource function post lecturers(@http:Payload Lecturer payload) returns json {

        lecturers.push(payload);
        return {message: "Lecturer has been successfully created"};
    }
    resource function get lecturer/[string staffnumber]() returns json|Lecturer {

        foreach var i in 0 ... lecturers.length() {
            if (staffnumber == lecturers[i].staffnumber) {
                //return {"message": staffnumber[i]};
                return lecturers[i];
            }
        }
        return {message: "No Lecturer with that staff number found"};

    }
    resource function put lecturer/[string staffnumber](@http:Payload Lecturer payload) returns json|Lecturer {
        foreach var lecturer in lecturers {
            if (staffnumber == lecturer.staffnumber) {

                lecturer.staffnumber = <string>payload.staffnumber;
                lecturer.officenumber = <string>payload.officenumber;
                lecturer.staffname = <string>payload.staffname;
                lecturer.title = <string>payload.title;

                return lecturer;
            }
        }

        return {message: "No lecturer with that staff number found"};
    }
    resource function delete lecturer/[string staffnumber]() returns json {

        foreach var i in 0 ... lecturers.length() {
            if (staffnumber == lecturers[i].staffnumber) {

                Lecturer removedLecturer = lecturers.remove(i);

                return {message: removedLecturer.staffname.toString() + " has been removed"};
            }
        }

        return {message: "No lecturer with that staff number found"};
    }

    resource function get courses/[string coursecode]() returns Course[]|http:Response|string {

        Lecturer[] tempCourseArray = [];
        foreach var lecturer in lecturers {

            foreach var course in lecturer.courses {
                if (coursecode == course.coursecode) {
                    tempCourseArray.push(lecturer);
                }

            }

        }

        return tempCourseArray;
    }
    resource function get office/[string officenumber]() returns Lecturer[]|string {
        Lecturer[] tempOfficeArray = [];
        foreach var lecturer in lecturers {
            if (officenumber == lecturer.officenumber) {
                tempOfficeArray.push(lecturer);
            }
        }

        return tempOfficeArray;

    }

}

import ballerina/http;

public type CreatedInlineResponse201 record {|
    *http:Created;
    InlineResponse201 body;
|};

public type LecturerArr Lecturer[];

public type CourseArr Course[];

public type InlineResponse201 record {
    # the staff number of the lecturer newly created
    string staffnumber?;
};

public type Error record {
    string errorType?;
    string message?;
};

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
    Course[] courses?;
};

public type Course record {
    # the course name
    string coursename?;
    # the course code
    string coursecode?;
    # the NQF level of the course
    int nqflevel?;
};

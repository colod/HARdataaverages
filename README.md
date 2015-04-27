The program first reads in the activity labels and the features. 
It determines the features of interest by looking for features that are labeled with mean or std.

It then pulls in the test data with appropriate column names, then pares it down to the columns of interest- 
the standard deviations and means. Also adds a named factor level based on activity names to help label rows.

It then pulls in the train data with appropriate column names, then pares it down to the columns of interest- 
the standard deviations and means. Also adds a named factor level based on activity names to help label rows.

It then merges the pared down test data and trial data.

It then programatically renames the variables to meet the formatting standards of full descriptive words, 
lowercase, and no underscores, slashes, or dots.

It then melts the merged data into tall skinny table of variables and their values by activityname and subject number.
It finally recasts the data into a wide table with the average of each variable over each combination of activity 
and subject.
This final table is then written and exported. It follows the principles of tidy data. It has one row per observation 
(namely activity performed by a single subject) and each column contains a single variable (the two identifiers, then
the means of the rest of each variable).

# Notes Towards A Public Compensation Database

There's a large body of evidence that silence about compensation is not in the interest of those being paid.
Let's do something about that: let's build a system for analyzing and reporting over salary info.

## Design Goals

1. Respect the safety and consent of the participants.

2. Promote a long-term, public conversation about compensation and salary, both in tech and in other fields.

## Concerns

* Compensation data is historically contentious.
    For a cautionary tale, see [@EricaJoy's Storify](https://storify.com/_danilo/ericajoy-s-salary-transparency-experiment-at-googl) about salary transparency at Google.
    Protecting participants from reprisal requires both effective transparency about how data will be collected and used and a deep, pervasive respect for consent.

* Naive implementations of anonymity will encourage abusive submissions: defamatory posts, fictional people, attempts to skew the data in a variety of ways.
    If this tool succeeds, abuses will discredit it and may damage the larger conversation.
    Abuses may also prevent the tool from succeeding.

* _Actual laws_ around salary discussion are not uniform.
    Tools should not make it easy for people to harm themselves by mistake.

* Voluntary disclosure is an inherently unequal process.

## Design

The tool stores _observations_ of compensation as of a given date, consisting of one or more of the following compensation types:

* Salary
* Hourly wage
* Bonus packages
* Equity (at approximate or negotiated value, eg. stock options or grants)
* “Other Compensation” of Yearly, Quarterly, Monthly, or One-Time periodicity

From these, the tool will derive a “total compensation” for the observation, used as a basis for reporting.

Each observation can carry _zero or more_ structured labels:

* Employer
    * Employer's city, district, and country
* Employee's name
    * Employee's city, district, and country
* Job Title
* Years In Role (senority)
* Years In Field (experience)
* Sex
* Gender
* Ethnicity
* Age
* Family Status
* Disabilities

All labels are _strictly_ voluntary and will be signposted clearly in the submission process.
Every label consists of freeform text or numeric fields.
Text fields will suggest autocompletions using values from existing verified observations, to encourage submitters to enter data consistently.

There are two core workflows:

* Submitting an observation
* Reporting on observed compensation

The submission workflow opens a UI which requests a date (defaulting to the date of submission) and a compensation package.
The UI also contains expandable sections to allow the user to choose which labels to add to the submission.
Finally, the UI contains an email address field used to validate the submission.
The validation process will be described later in this document, and serves to both deter abuse and to enable post-facto moderation of a user's submissions.

The report workflow will allow users to select a set of labels and see the distribution of total compensation within those labels, and how it breaks down.
For example, a user may report on compensation for jobs in Toronto, ON, Canada with three years' experience and see the distribution of compensation, and then break that down further by gender and ethnicity.

The report workflow will also users to enter a tentative observation and review how that compares to other compensation packages for similar jobs.
For example, a user may enter a tentative observation for Research In Motion, for Software Team Lead jobs, with a compensation of CAD 80,000/yr, and see the percentile their compensation falls in, and the distribution of compensation observations for the same job.

## Verification

To allow moderation of observations, users must include an email address when submitting observations.
This email address _must not be stored_, since storing it would allow submissions to be traced to specific people.
Instead, the tool digests the email address with a preconfigured salt, and associates the digest with the unverified observation.
The tool then emails the given address with a verification message, and discards the address.

The verification message contains the following:

* Prose outlining the verification process.
* A brief summary of the observation, containing the date of the observation and the total compensation observed.
* A link to the unverified observation, where the user can verify or destroy the observation.

The verification system serves three purposes:

1. It discourages people from submitting spurious observations by increasing the time investment needed to get an observation into the data set.
2. It complicates automated attempts to skew the data.
3. It allows observations from the same person to be correlated with one another without necessarily identifying the submitter.

The correlation provided by the verification system also allows observations to be moderated retroactively: observations shown to be abusive can be used to prevent the author from submitting further observations, and to remove all of that author's submissions (at least, under that address) to be removed from the data set.

Correlations may also allow amending or superceding observations safely. Needs fleshing out.

## Similar Efforts

* Piper Miriam's [Am I Underpaid](https://github.com/pipermerriam/am-i-underpaid), which attempts to address the question of compensation equality in a local way.
* As mentioned above, [@EricaJoy's Storify](https://storify.com/_danilo/ericajoy-s-salary-transparency-experiment-at-googl) covers doing this with Google Docs.
